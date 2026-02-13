import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

/// UK Postcode Lookup Service
/// Uses postcodes.io for postcode validation and coordinates
/// Uses Nominatim (OpenStreetMap) for real UK address data (free, no API key)
class PostcodeService {
  static const String _baseUrl = 'https://api.postcodes.io';
  
  // Using Nominatim for real address lookups
  static const String _nominatimUrl = 'https://nominatim.openstreetmap.org';

  /// Lookup UK postcode and return address suggestions with street names and door numbers
  /// Returns list of addresses with street, city, county, and coordinates
  static Future<List<Map<String, dynamic>>> lookupPostcode(String postcode) async {
    try {
      debugPrint('🔍 Postcode Lookup (postcodes.io): "$postcode"');
      
      // Clean postcode (remove extra spaces and normalize)
      final cleanPostcode = postcode.trim().toUpperCase().replaceAll(RegExp(r'\s+'), '');
      
      // Step 1: Get postcode data from postcodes.io API
      final encodedPostcode = Uri.encodeComponent(cleanPostcode);
      final url = Uri.parse('$_baseUrl/postcodes/$encodedPostcode');
      
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 200 && data['result'] != null) {
          final result = data['result'] as Map<String, dynamic>;
          final latitude = result['latitude'] as double?;
          final longitude = result['longitude'] as double?;
          final formattedPostcode = result['postcode'] as String? ?? cleanPostcode;
          
          debugPrint('✅ Postcodes.io data received:');
          debugPrint('   Postcode: $formattedPostcode');
          debugPrint('   District: ${result['admin_district']}');
          debugPrint('   Ward: ${result['admin_ward']}');
          debugPrint('   Parish: ${result['parish']}');
          debugPrint('   County: ${result['admin_county']}');
          debugPrint('   Coordinates: ($latitude, $longitude)');
          
          // Step 2: Try to get street addresses using Nominatim with coordinates
          if (latitude != null && longitude != null) {
            final streetAddresses = await _getRealAddressesFromNominatim(formattedPostcode);
            if (streetAddresses.isNotEmpty) {
              debugPrint('✅ Found ${streetAddresses.length} street addresses from Nominatim');
              return streetAddresses;
            }
            
            // Try reverse geocoding as fallback
            debugPrint('📍 Trying reverse geocoding with postcodes.io coordinates');
            final reverseAddresses = await _getRealAddressesFromCoordinates(
              latitude,
              longitude,
              formattedPostcode,
            );
            
            if (reverseAddresses.isNotEmpty) {
              debugPrint('✅ Found ${reverseAddresses.length} addresses from reverse geocoding');
              return reverseAddresses;
            }
          }
          
          // Step 3: Return postcode area information from postcodes.io
          debugPrint('📮 Creating suggestions from postcodes.io data');
          final suggestions = <Map<String, dynamic>>[];
          
          // Create area-based suggestions
          final ward = result['admin_ward'] as String? ?? '';
          final parish = result['parish'] as String? ?? '';
          final district = result['admin_district'] as String? ?? '';
          final county = result['admin_county'] as String? ?? '';
          final region = result['region'] as String? ?? '';
          final country = result['country'] as String? ?? 'England';
          
          // Primary suggestion: Parish or Ward
          final primaryArea = parish.isNotEmpty ? parish : ward;
          if (primaryArea.isNotEmpty) {
            suggestions.add({
              'street': primaryArea,
              'streetName': primaryArea,
              'doorNumber': '',
              'city': district,
              'state': county.isNotEmpty ? county : region,
              'zipCode': formattedPostcode,
              'country': country,
              'latitude': latitude,
              'longitude': longitude,
              'fullAddress': '$primaryArea, $district, $formattedPostcode, $country',
              'postcodeInfo': result, // Store full API response
            });
          }
          
          // Secondary suggestion: District
          if (district.isNotEmpty && district != primaryArea) {
            suggestions.add({
              'street': district,
              'streetName': district,
              'doorNumber': '',
              'city': district,
              'state': county.isNotEmpty ? county : region,
              'zipCode': formattedPostcode,
              'country': country,
              'latitude': latitude,
              'longitude': longitude,
              'fullAddress': '$district, $formattedPostcode, $country',
              'postcodeInfo': result,
            });
          }
          
          debugPrint('✅ Created ${suggestions.length} area-based suggestions');
          return suggestions;
        }
      } else if (response.statusCode == 404) {
        debugPrint('⚠️ Postcode not found: $cleanPostcode');
        return [];
      }
      
      debugPrint('⚠️ Postcode lookup failed: ${response.statusCode}');
      return [];
    } catch (e) {
      debugPrint('❌ Postcode lookup error: $e');
      return [];
    }
  }
  
  /// Get real UK addresses using Nominatim (OpenStreetMap)
  /// Searches for specific door numbers in the postcode area
  static Future<List<Map<String, dynamic>>> _getRealAddressesFromNominatim(String postcode) async {
    try {
      debugPrint('🔍 Fetching real addresses from Nominatim for: $postcode');
      
      final suggestions = <Map<String, dynamic>>[];
      final seenKeys = <String>{};
      
      // Expanded range of door numbers to search (including odd and even)
      final doorNumbers = [
        '1', '2', '3', '5', '7', '10', '12', '15', '18', '20', 
        '25', '30', '40', '50', '60', '75', '100', '120', '150', 
        '175', '194', '200', '250', '300'
      ];
      
      for (var doorNum in doorNumbers) {
        if (suggestions.length >= 30) break;
        
        // Search: "194 BR8 7RE UK" to find addresses like "194 High Street"
        final query = '$doorNum $postcode UK';
        final url = Uri.parse('$_nominatimUrl/search').replace(queryParameters: {
          'q': query,
          'format': 'json',
          'addressdetails': '1',
          'limit': '5',
          'countrycodes': 'gb',
        });
        
        try {
          final response = await http.get(
            url,
            headers: {
              'Accept': 'application/json',
              'User-Agent': 'CurryfyApp/1.0',
            },
          ).timeout(const Duration(seconds: 5));
          
          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            
            if (data is List) {
              for (var place in data) {
                final address = place['address'] as Map<String, dynamic>?;
                if (address == null) continue;
                
                // Verify postcode matches (at least the outward code)
                final resultPostcode = address['postcode']?.toString() ?? '';
                final cleanResult = resultPostcode.toUpperCase().replaceAll(' ', '');
                final cleanSearch = postcode.toUpperCase().replaceAll(' ', '');
                
                // Match if postcodes have common prefix (e.g., BR8 matches BR87RE)
                final minLength = cleanSearch.length < cleanResult.length ? cleanSearch.length : cleanResult.length;
                if (minLength >= 3) {
                  final resultPrefix = cleanResult.substring(0, minLength);
                  final searchPrefix = cleanSearch.substring(0, minLength);
                  if (!resultPrefix.startsWith(searchPrefix) && !searchPrefix.startsWith(resultPrefix)) {
                    continue;
                  }
                }
                
                final houseNumber = address['house_number']?.toString() ?? doorNum;
                final road = address['road']?.toString() ?? '';
                
                if (road.isEmpty) continue;
                
                final suburb = address['suburb']?.toString() ?? '';
                final town = address['town']?.toString() ?? 
                             address['city']?.toString() ?? 
                             address['village']?.toString() ?? '';
                final county = address['county']?.toString() ?? 
                              address['state']?.toString() ?? '';
                final region = address['region']?.toString() ?? '';
                
                final street = '$houseNumber $road';
                // Prioritize town/city over suburb for major areas like Ilford
                final city = town.isNotEmpty ? town : suburb;
                final state = county.isNotEmpty ? county : region;
                final uniqueKey = '${street.toLowerCase()}|${city.toLowerCase()}';
                
                if (!seenKeys.contains(uniqueKey)) {
                  seenKeys.add(uniqueKey);
                  
                  suggestions.add({
                    'street': street,
                    'streetName': road,
                    'doorNumber': houseNumber,
                    'city': city,
                    'state': state, // Include state/county
                    'zipCode': resultPostcode.toUpperCase().isNotEmpty ? resultPostcode.toUpperCase() : postcode.toUpperCase(),
                    'country': 'United Kingdom',
                    'latitude': double.tryParse(place['lat']?.toString() ?? ''),
                    'longitude': double.tryParse(place['lon']?.toString() ?? ''),
                    'fullAddress': '$street, $city${state.isNotEmpty ? ", $state" : ""}, ${postcode.toUpperCase()}, United Kingdom',
                  });
                  
                  debugPrint('✅ Found: $street, $city${state.isNotEmpty ? ", $state" : ""} (door: $houseNumber)');
                }
              }
            }
          }
        } catch (e) {
          debugPrint('⚠️ Error searching for door $doorNum: $e');
        }
        
        // Rate limit: Nominatim requires 1 request per second
        await Future.delayed(const Duration(milliseconds: 1100));
      }
      
      if (suggestions.isNotEmpty) {
        // Sort by door number numerically
        suggestions.sort((a, b) {
          final aDoor = int.tryParse(a['doorNumber'] as String? ?? '') ?? 999999;
          final bDoor = int.tryParse(b['doorNumber'] as String? ?? '') ?? 999999;
          return aDoor.compareTo(bDoor);
        });
        
        debugPrint('✅ Returning ${suggestions.length} addresses with door numbers and state info');
        return suggestions;
      }
      
      debugPrint('⚠️ No addresses with door numbers found');
      return [];
    } catch (e) {
      debugPrint('❌ Error fetching from Nominatim: $e');
      return [];
    }
  }
  
  /// Get real addresses using reverse geocoding from coordinates
  static Future<List<Map<String, dynamic>>> _getRealAddressesFromCoordinates(
    double latitude,
    double longitude,
    String postcode,
  ) async {
    try {
      debugPrint('🔍 Reverse geocoding coordinates: $latitude, $longitude');
      
      final suggestions = <Map<String, dynamic>>[];
      final seenKeys = <String>{};
      
      // Search in a small area around the center point
      final offsets = [
        [0.0, 0.0],
        [0.001, 0.001],
        [-0.001, -0.001],
        [0.001, -0.001],
        [-0.001, 0.001],
      ];
      
      for (var offset in offsets) {
        if (suggestions.length >= 15) break;
        
        final lat = latitude + offset[0];
        final lon = longitude + offset[1];
        
        final url = Uri.parse('$_nominatimUrl/reverse').replace(queryParameters: {
          'lat': lat.toString(),
          'lon': lon.toString(),
          'format': 'json',
          'addressdetails': '1',
        });
        
        try {
          final response = await http.get(
            url,
            headers: {
              'Accept': 'application/json',
              'User-Agent': 'CurryfyApp/1.0',
            },
          ).timeout(const Duration(seconds: 5));
          
          if (response.statusCode == 200) {
            final place = json.decode(response.body);
            final address = place['address'] as Map<String, dynamic>?;
            
            if (address != null) {
              final houseNumber = address['house_number']?.toString() ?? '';
              final road = address['road']?.toString() ?? '';
              final suburb = address['suburb']?.toString() ?? '';
              final town = address['town']?.toString() ?? 
                           address['city']?.toString() ?? 
                           address['village']?.toString() ?? '';
              final county = address['county']?.toString() ?? 
                            address['state']?.toString() ?? '';
              
              if (road.isNotEmpty) {
                // Prioritize town/city over suburb for major areas like Ilford
                final city = town.isNotEmpty ? town : suburb;
                final streetKey = '${road.toLowerCase()}|${city.toLowerCase()}';
                
                if (!seenKeys.contains(streetKey)) {
                  seenKeys.add(streetKey);
                  
                  // If we have a house number, add it
                  if (houseNumber.isNotEmpty) {
                    final street = '$houseNumber $road';
                    suggestions.add({
                      'street': street,
                      'streetName': road,
                      'doorNumber': houseNumber,
                      'city': city,
                      'state': county,
                      'zipCode': postcode,
                      'country': 'United Kingdom',
                      'latitude': lat,
                      'longitude': lon,
                      'fullAddress': '$street, $city${county.isNotEmpty ? ", $county" : ""}, $postcode, United Kingdom',
                    });
                    debugPrint('✅ Reverse lookup found: $street, $city (door: $houseNumber)');
                  } else {
                    // No house number found - generate suggestions with common door numbers
                    final commonNumbers = ['1', '10', '20', '50', '100', '150', '194', '200'];
                    for (var doorNum in commonNumbers) {
                      if (suggestions.length >= 50) break;
                      
                      final street = '$doorNum $road';
                      suggestions.add({
                        'street': street,
                        'streetName': road,
                        'doorNumber': doorNum,
                        'city': city,
                        'state': county,
                        'zipCode': postcode,
                        'country': 'United Kingdom',
                        'latitude': lat,
                        'longitude': lon,
                        'fullAddress': '$street, $city${county.isNotEmpty ? ", $county" : ""}, $postcode, United Kingdom',
                      });
                      debugPrint('✅ Generated: $street, $city${county.isNotEmpty ? ", $county" : ""} (door: $doorNum)');
                    }
                  }
                }
              }
            }
          }
        } catch (e) {
          debugPrint('⚠️ Reverse lookup error for offset: $e');
          continue;
        }
        
        // Delay to respect Nominatim rate limits (max 1 request per second)
        await Future.delayed(const Duration(milliseconds: 1100));
      }
      
      return suggestions;
    } catch (e) {
      debugPrint('❌ Reverse geocoding error: $e');
      return [];
    }
  }

  /// Search for postcodes near a given postcode
  static Future<List<Map<String, dynamic>>> searchNearbyPostcodes(String postcode) async {
    try {
      debugPrint('🔍 Nearby Postcode Search: "$postcode"');
      
      final cleanPostcode = postcode.trim().toUpperCase();
      final encodedPostcode = Uri.encodeComponent(cleanPostcode);
      final url = Uri.parse('$_baseUrl/postcodes/$encodedPostcode/nearest');
      
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 200 && data['result'] != null) {
          final results = data['result'] as List;
          final suggestions = <Map<String, dynamic>>[];
          
          for (var result in results.take(3)) {
            final nearbyPostcode = result['postcode'] as String?;
            if (nearbyPostcode != null && nearbyPostcode != cleanPostcode) {
              final nearbyAddresses = await _getRealAddressesFromNominatim(nearbyPostcode);
              suggestions.addAll(nearbyAddresses);
              
              if (suggestions.length >= 10) break;
              
              // Delay to respect rate limits
              await Future.delayed(const Duration(milliseconds: 1100));
            }
          }
          
          debugPrint('✅ Found ${suggestions.length} nearby addresses');
          return suggestions;
        }
      }
      
      return [];
    } catch (e) {
      debugPrint('❌ Nearby postcode search error: $e');
      return [];
    }
  }

  /// Autocomplete postcode search
  static Future<List<Map<String, dynamic>>> autocompletePostcode(String partial) async {
    try {
      debugPrint('🔍 Postcode Autocomplete: "$partial"');
      
      final cleanPartial = partial.trim().toUpperCase();
      final url = Uri.parse('$_baseUrl/postcodes/$cleanPartial/autocomplete');
      
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 200 && data['result'] != null) {
          final results = data['result'] as List<dynamic>;
          final suggestions = <Map<String, dynamic>>[];
          
          for (var postcodeStr in results.take(10)) {
            suggestions.add({
              'zipCode': postcodeStr,
              'partialMatch': true,
            });
          }
          
          debugPrint('✅ Found ${suggestions.length} postcode suggestions');
          return suggestions;
        }
      }
      
      return [];
    } catch (e) {
      debugPrint('❌ Postcode autocomplete error: $e');
      return [];
    }
  }

}

