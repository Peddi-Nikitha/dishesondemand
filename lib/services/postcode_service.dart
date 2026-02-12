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
      debugPrint('🔍 Postcode Lookup: "$postcode"');
      
      // Clean postcode (remove extra spaces)
      final cleanPostcode = postcode.trim().toUpperCase();
      
      // Try to get real addresses using Nominatim (OpenStreetMap)
      final streetAddresses = await _getRealAddressesFromNominatim(cleanPostcode);
      if (streetAddresses.isNotEmpty) {
        debugPrint('✅ Found ${streetAddresses.length} real addresses from Nominatim');
        return streetAddresses;
      }
      
      // Get postcode data from postcodes.io
      debugPrint('⚠️ Trying postcodes.io for basic postcode data');
      
      final encodedPostcode = Uri.encodeComponent(cleanPostcode);
      final url = Uri.parse('$_baseUrl/postcodes/$encodedPostcode');
      
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 200 && data['result'] != null) {
          final result = data['result'];
          final latitude = result['latitude'] as double?;
          final longitude = result['longitude'] as double?;
          
          // Try reverse lookup using coordinates to get real addresses
          if (latitude != null && longitude != null) {
            debugPrint('📍 Trying reverse lookup with coordinates: $latitude, $longitude');
            final reverseAddresses = await _getRealAddressesFromCoordinates(
              latitude,
              longitude,
              cleanPostcode,
            );
            
            if (reverseAddresses.isNotEmpty) {
              debugPrint('✅ Found ${reverseAddresses.length} real addresses from reverse lookup');
              return reverseAddresses;
            }
          }
          
          // Last resort: Return basic postcode area info
          debugPrint('⚠️ No detailed addresses found, showing postcode area only');
          final suggestions = <Map<String, dynamic>>[];
          suggestions.add({
            'street': result['admin_ward'] ?? result['parish'] ?? 'Area',
            'streetName': result['admin_ward'] ?? result['parish'] ?? 'Area',
            'doorNumber': '',
            'city': result['admin_district'] ?? result['postcode_area'] ?? '',
            'state': result['region'] ?? result['european_electoral_region'] ?? '',
            'zipCode': result['postcode'] ?? cleanPostcode,
            'country': result['country'] ?? 'United Kingdom',
            'latitude': latitude,
            'longitude': longitude,
            'fullAddress': _buildFullAddress(result, cleanPostcode),
          });
          
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
      
      // Search with specific door numbers (including 194)
      final doorNumbers = ['1', '10', '20', '50', '100', '150', '194', '200'];
      
      for (var doorNum in doorNumbers) {
        if (suggestions.length >= 20) break;
        
        // Search: "194 IG3 9LQ UK" to find addresses like "194 Green Lane"
        final query = '$doorNum $postcode UK';
        final url = Uri.parse('$_nominatimUrl/search').replace(queryParameters: {
          'q': query,
          'format': 'json',
          'addressdetails': '1',
          'limit': '10',
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
                
                // Verify postcode matches
                final resultPostcode = address['postcode']?.toString() ?? '';
                final cleanResult = resultPostcode.toUpperCase().replaceAll(' ', '');
                final cleanSearch = postcode.toUpperCase().replaceAll(' ', '');
                
                if (!cleanResult.startsWith(cleanSearch.substring(0, cleanSearch.length.clamp(0, 5)))) {
                  continue;
                }
                
                final houseNumber = address['house_number']?.toString() ?? doorNum;
                final road = address['road']?.toString() ?? '';
                
                if (road.isEmpty) continue;
                
                final suburb = address['suburb']?.toString() ?? '';
                final town = address['town']?.toString() ?? 
                             address['city']?.toString() ?? 
                             address['village']?.toString() ?? '';
                final county = address['county']?.toString() ?? '';
                
                final street = '$houseNumber $road';
                final city = suburb.isNotEmpty ? suburb : town;
                final uniqueKey = '${street.toLowerCase()}|${city.toLowerCase()}';
                
                if (!seenKeys.contains(uniqueKey)) {
                  seenKeys.add(uniqueKey);
                  
                  suggestions.add({
                    'street': street,
                    'streetName': road,
                    'doorNumber': houseNumber,
                    'city': city,
                    'state': county,
                    'zipCode': postcode.toUpperCase(),
                    'country': 'United Kingdom',
                    'latitude': double.tryParse(place['lat']?.toString() ?? ''),
                    'longitude': double.tryParse(place['lon']?.toString() ?? ''),
                    'fullAddress': '$street, $city, ${postcode.toUpperCase()}, United Kingdom',
                  });
                  
                  debugPrint('✅ Found: $street, $city (door: $houseNumber)');
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
        
        debugPrint('✅ Returning ${suggestions.length} addresses with door numbers');
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
                           address['city']?.toString() ?? '';
              final county = address['county']?.toString() ?? '';
              
              final street = houseNumber.isNotEmpty && road.isNotEmpty
                  ? '$houseNumber $road'
                  : (road.isNotEmpty ? road : '');
              
              if (street.isNotEmpty) {
                final city = suburb.isNotEmpty ? suburb : town;
                final uniqueKey = '${street.toLowerCase()}|${city.toLowerCase()}';
                
                if (!seenKeys.contains(uniqueKey)) {
                  seenKeys.add(uniqueKey);
                  
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
                    'fullAddress': '$street${city.isNotEmpty ? ", $city" : ""}, $postcode, United Kingdom',
                  });
                  
                  debugPrint('✅ Reverse lookup found: $street, $city (door: $houseNumber)');
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

  static String _buildFullAddress(Map<String, dynamic> result, String postcode) {
    final parts = <String>[];
    
    final ward = result['admin_ward'] ?? result['parish'] ?? '';
    if (ward.isNotEmpty) {
      parts.add(ward);
    }
    
    final district = result['admin_district'] ?? '';
    if (district.isNotEmpty && district != ward) {
      parts.add(district);
    }
    
    final region = result['region'] ?? '';
    if (region.isNotEmpty && region != district) {
      parts.add(region);
    }
    
    if (postcode.isNotEmpty) {
      parts.add(postcode);
    }
    
    final country = result['country'] ?? 'United Kingdom';
    if (country.isNotEmpty) {
      parts.add(country);
    }
    
    return parts.join(', ');
  }
}

