import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geocoding/geocoding.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_theme.dart';
import '../../utils/theme_helper.dart';
import '../../providers/auth_provider.dart';
import '../../models/user_model.dart';
import '../../services/location_service.dart';

/// Add/Edit Delivery Address screen with form validation and Firestore integration
class AddAddressScreen extends StatefulWidget {
  final AddressModel? address; // If provided, edit mode; otherwise, add mode

  const AddAddressScreen({
    super.key,
    this.address,
  });

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _labelController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipCodeController = TextEditingController();
  final _countryController = TextEditingController();
  bool _isDefault = false;
  bool _isLoading = false;
  bool _isAutoFilling = false;
  Timer? _zipCodeDebounceTimer;
  List<Map<String, dynamic>> _addressSuggestions = [];
  
  // Unified address search field
  final _unifiedAddressController = TextEditingController();
  final FocusNode _unifiedAddressFocusNode = FocusNode();
  final LayerLink _unifiedAddressLayerLink = LayerLink();
  Timer? _unifiedAddressDebounceTimer;
  List<Map<String, dynamic>> _unifiedAddressSuggestions = [];
  OverlayEntry? _unifiedAddressOverlay;
  bool _isSearchingUnifiedAddress = false;
  
  // Autocomplete for street and city
  Timer? _streetDebounceTimer;
  Timer? _cityDebounceTimer;
  List<Map<String, dynamic>> _streetSuggestions = [];
  List<Map<String, dynamic>> _citySuggestions = [];
  final LayerLink _streetLayerLink = LayerLink();
  final LayerLink _cityLayerLink = LayerLink();
  OverlayEntry? _streetOverlay;
  OverlayEntry? _cityOverlay;
  final FocusNode _streetFocusNode = FocusNode();
  final FocusNode _cityFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // If editing, populate fields
    if (widget.address != null) {
      _labelController.text = widget.address!.label;
      _streetController.text = widget.address!.street;
      _cityController.text = widget.address!.city;
      _stateController.text = widget.address!.state;
      _zipCodeController.text = widget.address!.zipCode;
      _countryController.text = widget.address!.country;
      _isDefault = widget.address!.isDefault;
    } else {
      // Default country
      _countryController.text = 'United Kingdom';
    }
    
    // Add listener to zip code controller for auto-fill
    _zipCodeController.addListener(_onZipCodeChanged);
    
    // Add listener for unified address search
    _unifiedAddressController.addListener(_onUnifiedAddressChanged);
    _unifiedAddressFocusNode.addListener(() {
      if (!_unifiedAddressFocusNode.hasFocus) {
        _hideUnifiedAddressSuggestions();
      }
    });
    
    // Add listeners for street and city autocomplete
    _streetController.addListener(_onStreetChanged);
    _cityController.addListener(_onCityChanged);
    
    // Add focus listeners to hide suggestions when field loses focus
    _streetFocusNode.addListener(() {
      if (!_streetFocusNode.hasFocus) {
        _hideStreetSuggestions();
      }
    });
    
    _cityFocusNode.addListener(() {
      if (!_cityFocusNode.hasFocus) {
        _hideCitySuggestions();
      }
    });
  }
  
  void _onUnifiedAddressChanged() {
    _unifiedAddressDebounceTimer?.cancel();
    final query = _unifiedAddressController.text.trim();
    
    if (query.length >= 3 && widget.address == null) {
      _unifiedAddressDebounceTimer = Timer(const Duration(milliseconds: 400), () {
        _searchUnifiedAddress(query);
      });
    } else {
      _hideUnifiedAddressSuggestions();
    }
  }
  
  Future<void> _searchUnifiedAddress(String query) async {
    if (query.length < 3) return;
    
    setState(() {
      _isSearchingUnifiedAddress = true;
    });
    
    try {
      debugPrint('🔍 Unified Address Search: "$query"');
      
      final country = _countryController.text.trim().isNotEmpty 
          ? _countryController.text.trim() 
          : 'United Kingdom';
      
      // Search with country for better results
      final searchQuery = '$query, $country';
      final locations = await locationFromAddress(searchQuery);
      
      if (locations.isEmpty || !mounted) {
        setState(() {
          _isSearchingUnifiedAddress = false;
        });
        return;
      }
      
      debugPrint('📍 Found ${locations.length} locations');
      
      final suggestions = <Map<String, dynamic>>[];
      final seenAddresses = <String>{};
      
      // Process up to 10 locations
      final locationsToProcess = locations.length > 10 ? 10 : locations.length;
      
      for (int i = 0; i < locationsToProcess; i++) {
        try {
          final addressDetails = await LocationService.reverseGeocode(
            locations[i].latitude,
            locations[i].longitude,
          );
          
          if (addressDetails != null) {
            final fullAddress = _buildFullAddressString(addressDetails);
            
            if (fullAddress.isNotEmpty && !seenAddresses.contains(fullAddress.toLowerCase())) {
              seenAddresses.add(fullAddress.toLowerCase());
              suggestions.add({
                'fullAddress': fullAddress,
                'doorNumber': addressDetails['doorNumber'] ?? '',
                'streetName': addressDetails['streetName'] ?? '',
                'street': addressDetails['street'] ?? '',
                'city': addressDetails['city'] ?? '',
                'state': addressDetails['state'] ?? '',
                'zipCode': addressDetails['zipCode'] ?? '',
                'country': addressDetails['country'] ?? country,
              });
              
              debugPrint('✅ Added: $fullAddress');
            }
          }
        } catch (e) {
          debugPrint('⚠️ Error processing location $i: $e');
          continue;
        }
      }
      
      if (mounted) {
        setState(() {
          _unifiedAddressSuggestions = suggestions.take(8).toList();
          _isSearchingUnifiedAddress = false;
        });
        
        if (suggestions.isNotEmpty) {
          _showUnifiedAddressSuggestions();
        } else {
          _hideUnifiedAddressSuggestions();
        }
      }
    } catch (e) {
      debugPrint('❌ Unified address search error: $e');
      if (mounted) {
        setState(() {
          _isSearchingUnifiedAddress = false;
        });
      }
    }
  }
  
  String _buildFullAddressString(Map<String, String> addressDetails) {
    final parts = <String>[];
    
    final street = addressDetails['street'] ?? '';
    if (street.isNotEmpty) {
      parts.add(street);
    }
    
    final city = addressDetails['city'] ?? '';
    if (city.isNotEmpty) {
      parts.add(city);
    }
    
    final state = addressDetails['state'] ?? '';
    if (state.isNotEmpty && state != city) {
      parts.add(state);
    }
    
    final zipCode = addressDetails['zipCode'] ?? '';
    if (zipCode.isNotEmpty) {
      parts.add(zipCode);
    }
    
    final country = addressDetails['country'] ?? '';
    if (country.isNotEmpty) {
      parts.add(country);
    }
    
    return parts.join(', ');
  }
  
  void _showUnifiedAddressSuggestions() {
    _hideUnifiedAddressSuggestions();
    
    _unifiedAddressOverlay = OverlayEntry(
      builder: (context) => Positioned(
        width: MediaQuery.of(context).size.width - (AppTheme.spacingM * 2),
        child: CompositedTransformFollower(
          link: _unifiedAddressLayerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 4),
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(AppTheme.radiusM),
            color: ThemeHelper.getSurfaceColor(context),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 320),
              decoration: BoxDecoration(
                color: ThemeHelper.getSurfaceColor(context),
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
                border: Border.all(
                  color: ThemeHelper.getBorderColor(context),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: _unifiedAddressSuggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = _unifiedAddressSuggestions[index];
                  return _buildUnifiedAddressSuggestionItem(suggestion);
                },
              ),
            ),
          ),
        ),
      ),
    );
    
    Overlay.of(context).insert(_unifiedAddressOverlay!);
  }
  
  Widget _buildUnifiedAddressSuggestionItem(Map<String, dynamic> suggestion) {
    final fullAddress = suggestion['fullAddress'] as String;
    final street = suggestion['street'] as String? ?? '';
    final city = suggestion['city'] as String? ?? '';
    final doorNumber = suggestion['doorNumber'] as String? ?? '';
    
    return InkWell(
      onTap: () {
        _selectUnifiedAddressSuggestion(suggestion);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingM,
          vertical: 12,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: ThemeHelper.getPrimaryColor(context).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: ThemeHelper.getPrimaryColor(context).withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: Icon(
                doorNumber.isNotEmpty ? Icons.home : Icons.location_on,
                color: ThemeHelper.getPrimaryColor(context),
                size: 22,
              ),
            ),
            const SizedBox(width: AppTheme.spacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    street.isNotEmpty ? street : fullAddress.split(',').first,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: ThemeHelper.getTextPrimaryColor(context),
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    city.isNotEmpty ? fullAddress : fullAddress.split(',').skip(1).join(',').trim(),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: ThemeHelper.getTextSecondaryColor(context),
                      fontSize: 12,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: ThemeHelper.getTextSecondaryColor(context).withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
  
  void _selectUnifiedAddressSuggestion(Map<String, dynamic> suggestion) {
    _hideUnifiedAddressSuggestions();
    
    setState(() {
      // Auto-fill all fields
      _streetController.text = suggestion['street'] as String? ?? '';
      _cityController.text = suggestion['city'] as String? ?? '';
      _stateController.text = suggestion['state'] as String? ?? '';
      _zipCodeController.text = suggestion['zipCode'] as String? ?? '';
      _countryController.text = suggestion['country'] as String? ?? 'United Kingdom';
      
      // Clear unified search field
      _unifiedAddressController.clear();
    });
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            const Expanded(
              child: Text('Address fields auto-filled! Review and adjust if needed.'),
            ),
          ],
        ),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  
  void _hideUnifiedAddressSuggestions() {
    _unifiedAddressOverlay?.remove();
    _unifiedAddressOverlay = null;
  }
  
  void _onStreetChanged() {
    _streetDebounceTimer?.cancel();
    final street = _streetController.text.trim();
    
    // Only trigger autocomplete if text doesn't start with a number (to allow manual door number entry)
    if (street.length >= 3 && widget.address == null && !RegExp(r'^\d+\s').hasMatch(street)) {
      _streetDebounceTimer = Timer(const Duration(milliseconds: 500), () {
        _searchStreetSuggestions(street);
      });
    } else {
      _hideStreetSuggestions();
    }
  }
  
  void _onCityChanged() {
    _cityDebounceTimer?.cancel();
    final city = _cityController.text.trim();
    
    if (city.length >= 2 && widget.address == null) {
      _cityDebounceTimer = Timer(const Duration(milliseconds: 500), () {
        _searchCitySuggestions(city);
      });
    } else {
      _hideCitySuggestions();
    }
  }
  
  Future<void> _searchStreetSuggestions(String query) async {
    if (query.length < 3) return;
    
    try {
      final country = _countryController.text.trim().isNotEmpty 
          ? _countryController.text.trim() 
          : 'United Kingdom';
      
      final city = _cityController.text.trim();
      final queryLower = query.toLowerCase();
      
      // Try multiple search query formats for better results
      final searchQueries = <String>[];
      
      // 1. With city if available (most specific)
      if (city.isNotEmpty) {
        searchQueries.add('$query, $city, $country');
        searchQueries.add('$query Street, $city, $country');
        searchQueries.add('$query Road, $city, $country');
        searchQueries.add('$query Lane, $city, $country');
        searchQueries.add('$query Avenue, $city, $country');
      }
      
      // 2. With country only
      searchQueries.add('$query, $country');
      searchQueries.add('$query Street, $country');
      searchQueries.add('$query Road, $country');
      searchQueries.add('$query Lane, $country');
      searchQueries.add('$query Avenue, $country');
      
      // 3. Try specific addresses with common door numbers (limited to get some examples)
      final commonNumbers = [1, 10, 20, 50, 100];
      for (final num in commonNumbers) {
        if (city.isNotEmpty) {
          searchQueries.add('$num $query, $city, $country');
        } else {
          searchQueries.add('$num $query, $country');
        }
      }
      
      await _performStreetSearch(searchQueries, queryLower);
    } catch (e) {
      debugPrint('❌ Error searching street suggestions: $e');
    }
  }
  
  Future<void> _performStreetSearch(List<String> searchQueries, String queryLower) async {
    if (!mounted) return;
    
    final suggestions = <Map<String, dynamic>>[];
    final seenStreets = <String>{}; // To avoid duplicates
    
    try {
      // Try each search query until we get enough results
      for (int queryIndex = 0; queryIndex < searchQueries.length; queryIndex++) {
        if (suggestions.length >= 15) break; // Increased limit to get more results with door numbers
        
        final searchQuery = searchQueries[queryIndex];
        
        // Add small delay between queries to avoid rate limiting
        if (queryIndex > 0) {
          await Future.delayed(const Duration(milliseconds: 200));
        }
        
        try {
          debugPrint('🔍 Searching: $searchQuery');
          final locations = await locationFromAddress(searchQuery);
          
          if (locations.isEmpty) continue;
          
          debugPrint('📍 Found ${locations.length} locations for "$searchQuery"');
          
          // Process up to 15 locations per query to get more addresses with door numbers
          final locationsToProcess = locations.length > 15 ? 15 : locations.length;
          
          for (int i = 0; i < locationsToProcess; i++) {
            if (suggestions.length >= 15) break; // Increased limit to get more results
            
            try {
              final addressDetails = await LocationService.reverseGeocode(
                locations[i].latitude,
                locations[i].longitude,
              );
              
              if (addressDetails != null) {
                final street = addressDetails['street'] ?? '';
                final doorNumber = addressDetails['doorNumber'] ?? '';
                final streetName = addressDetails['streetName'] ?? '';
                final streetLower = street.toLowerCase();
                
                // Log raw placemark data to debug what we're getting
                debugPrint('📊 Raw address data:');
                debugPrint('   Full: $street');
                debugPrint('   Door: $doorNumber');
                debugPrint('   Street: $streetName');
                debugPrint('   City: ${addressDetails['city']}');
                debugPrint('   Zip: ${addressDetails['zipCode']}');
                
                // Check if street matches the query
                // Allow partial matches and common variations
                final queryWords = queryLower.split(' ').where((w) => w.isNotEmpty && !RegExp(r'^\d+$').hasMatch(w)).toList();
                final streetWords = streetLower.split(' ').where((w) => w.isNotEmpty && !RegExp(r'^\d+$').hasMatch(w)).toList();
                
                // Match if all query words (excluding numbers) appear in street
                final matches = queryWords.isEmpty || queryWords.every((word) => 
                  streetWords.any((streetWord) => streetWord.contains(word) || word.contains(streetWord))
                );
                
                // Only include if:
                // 1. Street is not empty
                // 2. Street matches the search query (flexible matching)
                // 3. We haven't seen this exact street+city combo before (allow different door numbers)
                final uniqueKey = doorNumber.isNotEmpty 
                    ? '$streetLower|${addressDetails['city']?.toLowerCase() ?? ''}|$doorNumber'
                    : '$streetLower|${addressDetails['city']?.toLowerCase() ?? ''}';
                    
                if (street.isNotEmpty && 
                    matches &&
                    !seenStreets.contains(uniqueKey)) {
                  
                  seenStreets.add(uniqueKey);
                  suggestions.add({
                    'street': street,
                    'doorNumber': doorNumber,
                    'streetName': streetName.isNotEmpty ? streetName : street,
                    'city': addressDetails['city'] ?? '',
                    'state': addressDetails['state'] ?? '',
                    'country': addressDetails['country'] ?? '',
                    'zipCode': addressDetails['zipCode'] ?? '',
                  });
                  
                  if (doorNumber.isNotEmpty) {
                    debugPrint('✅ Found match WITH door number: $street');
                  } else {
                    debugPrint('✅ Found match (no door number): $street');
                  }
                }
              }
            } catch (e) {
              debugPrint('⚠️ Error reverse geocoding location $i: $e');
              continue;
            }
          }
        } catch (e) {
          debugPrint('⚠️ Error with query "$searchQuery": $e');
          continue; // Try next query format
        }
      }
      
      // Sort suggestions: prioritize those with door numbers, then limit to 8 for display
      suggestions.sort((a, b) {
        final aHasDoor = (a['doorNumber'] as String? ?? '').isNotEmpty;
        final bHasDoor = (b['doorNumber'] as String? ?? '').isNotEmpty;
        if (aHasDoor && !bHasDoor) return -1;
        if (!aHasDoor && bHasDoor) return 1;
        return 0; // Keep original order if both have or don't have door numbers
      });
      
      // Limit to 8 suggestions for display (increased to show more addresses with door numbers)
      final finalSuggestions = suggestions.take(8).toList();
      
      if (mounted && finalSuggestions.isNotEmpty) {
        setState(() {
          _streetSuggestions = finalSuggestions;
        });
        _showStreetSuggestions();
        debugPrint('✅ Showing ${finalSuggestions.length} street suggestions');
      } else if (mounted) {
        debugPrint('❌ No matching street suggestions found for query');
        _hideStreetSuggestions();
      }
    } catch (e) {
      debugPrint('❌ Street search error: $e');
      if (mounted) {
        _hideStreetSuggestions();
      }
    }
  }
  
  Future<void> _searchCitySuggestions(String query) async {
    if (query.length < 2) return;
    
    try {
      final country = _countryController.text.trim().isNotEmpty 
          ? _countryController.text.trim() 
          : 'United Kingdom';
      
      final searchQuery = '$query, $country';
      final locations = await locationFromAddress(searchQuery);
      if (locations.isEmpty || !mounted) return;
      
      final citySet = <String>{};
      final suggestions = <Map<String, dynamic>>[];
      
      for (final location in locations.take(10)) {
        try {
          final addressDetails = await LocationService.reverseGeocode(
            location.latitude,
            location.longitude,
          );
          
          if (addressDetails != null) {
            final city = addressDetails['city'] ?? '';
            final state = addressDetails['state'] ?? '';
            
            if (city.isNotEmpty && !citySet.contains(city.toLowerCase())) {
              citySet.add(city.toLowerCase());
              suggestions.add({
                'city': city,
                'state': state,
                'country': addressDetails['country'] ?? country,
              });
              
              if (suggestions.length >= 5) break;
            }
          }
        } catch (e) {
          continue;
        }
      }
      
      if (mounted && suggestions.isNotEmpty) {
        setState(() {
          _citySuggestions = suggestions;
        });
        _showCitySuggestions();
      }
    } catch (e) {
      debugPrint('⚠️ City search error: $e');
    }
  }
  
  void _showStreetSuggestions() {
    _hideStreetSuggestions();
    
    _streetOverlay = OverlayEntry(
      builder: (context) => Positioned(
        width: MediaQuery.of(context).size.width - (AppTheme.spacingM * 2),
        child: CompositedTransformFollower(
          link: _streetLayerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 4),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(AppTheme.radiusM),
            color: ThemeHelper.getSurfaceColor(context),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 320), // Increased to show more suggestions with door numbers
              decoration: BoxDecoration(
                color: ThemeHelper.getSurfaceColor(context),
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
                border: Border.all(
                  color: ThemeHelper.getBorderColor(context),
                  width: 1,
                ),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 4),
                itemCount: _streetSuggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = _streetSuggestions[index];
                  return _buildStreetSuggestionItem(suggestion);
                },
              ),
            ),
          ),
        ),
      ),
    );
    
    Overlay.of(context).insert(_streetOverlay!);
  }
  
  void _showCitySuggestions() {
    _hideCitySuggestions();
    
    _cityOverlay = OverlayEntry(
      builder: (context) => Positioned(
        width: MediaQuery.of(context).size.width - (AppTheme.spacingM * 2),
        child: CompositedTransformFollower(
          link: _cityLayerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 4),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(AppTheme.radiusM),
            color: ThemeHelper.getSurfaceColor(context),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                color: ThemeHelper.getSurfaceColor(context),
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
                border: Border.all(
                  color: ThemeHelper.getBorderColor(context),
                  width: 1,
                ),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 4),
                itemCount: _citySuggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = _citySuggestions[index];
                  return _buildCitySuggestionItem(suggestion);
                },
              ),
            ),
          ),
        ),
      ),
    );
    
    Overlay.of(context).insert(_cityOverlay!);
  }
  
  Widget _buildStreetSuggestionItem(Map<String, dynamic> suggestion) {
    final street = suggestion['street'] as String;
    final doorNumber = suggestion['doorNumber'] as String? ?? '';
    final city = suggestion['city'] as String;
    final state = suggestion['state'] as String;
    final zipCode = suggestion['zipCode'] as String? ?? '';
    
    // Build display text
    String primaryText = street;
    String? secondaryText = city.isNotEmpty ? city + (state.isNotEmpty ? ', $state' : '') : null;
    
    // Add hint about manual entry if no door number
    if (doorNumber.isEmpty && city.isNotEmpty) {
      secondaryText = '$secondaryText${zipCode.isNotEmpty ? ' $zipCode' : ''}';
    }
    
    return InkWell(
      onTap: () {
        _selectStreetSuggestion(suggestion);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingM,
          vertical: 10,
        ),
        child: Row(
          children: [
            // Door number badge if available, otherwise street icon
            if (doorNumber.isNotEmpty)
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: ThemeHelper.getPrimaryColor(context).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: ThemeHelper.getPrimaryColor(context).withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    doorNumber,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: ThemeHelper.getPrimaryColor(context),
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              )
            else
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: ThemeHelper.getTextSecondaryColor(context).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.location_on_outlined,
                  size: 20,
                  color: ThemeHelper.getTextSecondaryColor(context),
                ),
              ),
            const SizedBox(width: AppTheme.spacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    primaryText,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: ThemeHelper.getTextPrimaryColor(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (secondaryText != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Text(
                        secondaryText,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: ThemeHelper.getTextSecondaryColor(context),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  // Hint for manual entry
                  if (doorNumber.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        'Tap to select, then add door number',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: ThemeHelper.getTextSecondaryColor(context).withValues(alpha: 0.7),
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildCitySuggestionItem(Map<String, dynamic> suggestion) {
    final city = suggestion['city'] as String;
    final state = suggestion['state'] as String;
    final country = suggestion['country'] as String;
    
    return InkWell(
      onTap: () {
        _selectCitySuggestion(suggestion);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingM,
          vertical: AppTheme.spacingS,
        ),
        child: Row(
          children: [
            Icon(
              Icons.location_city_outlined,
              size: 20,
              color: ThemeHelper.getTextSecondaryColor(context),
            ),
            const SizedBox(width: AppTheme.spacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    city,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: ThemeHelper.getTextPrimaryColor(context),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (state.isNotEmpty || country.isNotEmpty)
                    Text(
                      state.isNotEmpty 
                          ? '$state, $country'
                          : country,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: ThemeHelper.getTextSecondaryColor(context),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void _selectStreetSuggestion(Map<String, dynamic> suggestion) {
    _hideStreetSuggestions();
    
    setState(() {
      _streetController.text = suggestion['street'] as String? ?? '';
      if (_cityController.text.isEmpty && suggestion['city']?.isNotEmpty == true) {
        _cityController.text = suggestion['city'] as String;
      }
      if (_stateController.text.isEmpty && suggestion['state']?.isNotEmpty == true) {
        _stateController.text = suggestion['state'] as String;
      }
      if (_zipCodeController.text.isEmpty && suggestion['zipCode']?.isNotEmpty == true) {
        _zipCodeController.text = suggestion['zipCode'] as String;
      }
      if (_countryController.text.isEmpty && suggestion['country']?.isNotEmpty == true) {
        _countryController.text = suggestion['country'] as String;
      }
    });
  }
  
  void _selectCitySuggestion(Map<String, dynamic> suggestion) {
    _hideCitySuggestions();
    
    setState(() {
      _cityController.text = suggestion['city'] as String? ?? '';
      if (_stateController.text.isEmpty && suggestion['state']?.isNotEmpty == true) {
        _stateController.text = suggestion['state'] as String;
      }
      if (_countryController.text.isEmpty && suggestion['country']?.isNotEmpty == true) {
        _countryController.text = suggestion['country'] as String;
      }
    });
  }
  
  void _hideStreetSuggestions() {
    _streetOverlay?.remove();
    _streetOverlay = null;
  }
  
  void _hideCitySuggestions() {
    _cityOverlay?.remove();
    _cityOverlay = null;
  }
  
  void _onZipCodeChanged() {
    // Cancel previous timer
    _zipCodeDebounceTimer?.cancel();
    
    final zipCode = _zipCodeController.text.trim();
    
    // Only auto-fill if:
    // 1. Not in edit mode (editing existing address)
    // 2. Zip code has minimum length (5 characters for most countries)
    // 3. Not already auto-filling
    if (widget.address == null && 
        zipCode.length >= 5 && 
        !_isAutoFilling) {
      
      // Debounce: Wait 1 second after user stops typing
      _zipCodeDebounceTimer = Timer(const Duration(seconds: 1), () {
        _autoFillAddressFromZipCode(zipCode);
      });
    }
  }
  
  Future<void> _autoFillAddressFromZipCode(String zipCode) async {
    if (_isAutoFilling || zipCode.isEmpty) return;
    
    setState(() {
      _isAutoFilling = true;
      _addressSuggestions = [];
    });
    
    try {
      final country = _countryController.text.trim().isNotEmpty 
          ? _countryController.text.trim() 
          : 'United Kingdom';
      
      // Try to get location from postal code
      // Format: "postal code, country" (e.g., "SW1A 1AA, United Kingdom")
      final addressQuery = '$zipCode, $country';
      
      debugPrint('🔍 Searching for addresses with zip code: $zipCode');
      
      List<Location> locations;
      try {
        locations = await locationFromAddress(addressQuery);
      } catch (e) {
        // If that fails, try with just the zip code
        debugPrint('⚠️ First attempt failed, trying zip code only: $e');
        try {
          locations = await locationFromAddress(zipCode);
        } catch (e2) {
          debugPrint('❌ Could not find location for zip code: $e2');
          setState(() {
            _isAutoFilling = false;
          });
          return;
        }
      }
      
      if (locations.isEmpty) {
        debugPrint('❌ No locations found for zip code: $zipCode');
        setState(() {
          _isAutoFilling = false;
        });
        return;
      }
      
      debugPrint('✅ Found ${locations.length} location(s) for zip code');
      
      // Get address details for all locations (up to 5)
      final suggestions = <Map<String, dynamic>>[];
      final maxSuggestions = locations.length > 5 ? 5 : locations.length;
      
      for (int i = 0; i < maxSuggestions; i++) {
        final location = locations[i];
        try {
          final addressDetails = await LocationService.reverseGeocode(
            location.latitude,
            location.longitude,
          );
          
          if (addressDetails != null) {
            suggestions.add({
              'street': addressDetails['street'] ?? '',
              'city': addressDetails['city'] ?? '',
              'state': addressDetails['state'] ?? '',
              'country': addressDetails['country'] ?? country,
              'zipCode': zipCode,
              'latitude': location.latitude,
              'longitude': location.longitude,
              'fullAddress': _formatFullAddress(addressDetails, zipCode),
            });
          }
        } catch (e) {
          debugPrint('⚠️ Error getting address details for location $i: $e');
        }
      }
      
      if (mounted) {
        setState(() {
          _addressSuggestions = suggestions;
          _isAutoFilling = false;
        });
        
        if (suggestions.isNotEmpty) {
          // Show address suggestions bottom sheet
          _showAddressSuggestions();
        } else {
          debugPrint('❌ No address suggestions found');
        }
      }
    } catch (e) {
      debugPrint('❌ Error searching addresses: $e');
      setState(() {
        _isAutoFilling = false;
        _addressSuggestions = [];
      });
    }
  }
  
  String _formatFullAddress(Map<String, String> address, String zipCode) {
    final parts = <String>[];
    if (address['street']?.isNotEmpty == true) {
      parts.add(address['street']!);
    }
    if (address['city']?.isNotEmpty == true) {
      parts.add(address['city']!);
    }
    if (address['state']?.isNotEmpty == true) {
      parts.add(address['state']!);
    }
    if (zipCode.isNotEmpty) {
      parts.add(zipCode);
    }
    if (address['country']?.isNotEmpty == true) {
      parts.add(address['country']!);
    }
    return parts.join(', ');
  }
  
  void _showAddressSuggestions() {
    if (_addressSuggestions.isEmpty) return;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.6,
        ),
        decoration: BoxDecoration(
          color: ThemeHelper.getBackgroundColor(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: ThemeHelper.getTextSecondaryColor(context),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingL),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: ThemeHelper.getPrimaryColor(context),
                  ),
                  const SizedBox(width: AppTheme.spacingM),
                  Expanded(
                    child: Text(
                      'Select Address',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: ThemeHelper.getTextPrimaryColor(context),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      color: ThemeHelper.getTextSecondaryColor(context),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            // Address suggestions list
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _addressSuggestions.length,
                padding: const EdgeInsets.all(AppTheme.spacingM),
                itemBuilder: (context, index) {
                  final suggestion = _addressSuggestions[index];
                  return _buildAddressSuggestionItem(suggestion, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildAddressSuggestionItem(Map<String, dynamic> suggestion, int index) {
    final fullAddress = suggestion['fullAddress'] as String;
    final street = suggestion['street'] as String;
    
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        _selectAddressSuggestion(suggestion);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: AppTheme.spacingM),
        padding: const EdgeInsets.all(AppTheme.spacingM),
        decoration: BoxDecoration(
          color: ThemeHelper.getSurfaceColor(context),
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
          border: Border.all(
            color: ThemeHelper.getBorderColor(context),
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: ThemeHelper.getPrimaryColor(context).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.home_outlined,
                color: ThemeHelper.getPrimaryColor(context),
                size: 20,
              ),
            ),
            const SizedBox(width: AppTheme.spacingM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (street.isNotEmpty)
                    Text(
                      street,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: ThemeHelper.getTextPrimaryColor(context),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  if (street.isNotEmpty) const SizedBox(height: 4),
                  Text(
                    fullAddress,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: ThemeHelper.getTextSecondaryColor(context),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: ThemeHelper.getTextSecondaryColor(context),
            ),
          ],
        ),
      ),
    );
  }
  
  void _selectAddressSuggestion(Map<String, dynamic> suggestion) {
    setState(() {
      // Auto-fill all fields from selected suggestion
      if (_streetController.text.isEmpty) {
        _streetController.text = suggestion['street'] as String? ?? '';
      }
      if (_cityController.text.isEmpty) {
        _cityController.text = suggestion['city'] as String? ?? '';
      }
      if (_stateController.text.isEmpty) {
        _stateController.text = suggestion['state'] as String? ?? '';
      }
      if (_countryController.text.isEmpty || _countryController.text == 'United Kingdom') {
        _countryController.text = suggestion['country'] as String? ?? 'United Kingdom';
      }
      // Zip code is already filled by user
    });
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Address fields auto-filled'),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _zipCodeDebounceTimer?.cancel();
    _streetDebounceTimer?.cancel();
    _cityDebounceTimer?.cancel();
    _unifiedAddressDebounceTimer?.cancel();
    _zipCodeController.removeListener(_onZipCodeChanged);
    _streetController.removeListener(_onStreetChanged);
    _cityController.removeListener(_onCityChanged);
    _unifiedAddressController.removeListener(_onUnifiedAddressChanged);
    _hideStreetSuggestions();
    _hideCitySuggestions();
    _hideUnifiedAddressSuggestions();
    _streetFocusNode.dispose();
    _cityFocusNode.dispose();
    _unifiedAddressFocusNode.dispose();
    _labelController.dispose();
    _unifiedAddressController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Hide suggestions when tapping outside
        _hideStreetSuggestions();
        _hideCitySuggestions();
        _hideUnifiedAddressSuggestions();
        // Unfocus fields
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: ThemeHelper.getBackgroundColor(context),
        body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppTheme.spacingM),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Label Field
                      _buildTextField(
                        controller: _labelController,
                        label: 'Address Label',
                        hint: 'e.g., Home, Office, Work',
                        icon: Icons.label_outline,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter an address label';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppTheme.spacingL),
                      
                      // ============================================
                      // UNIFIED ADDRESS SEARCH FIELD
                      // ============================================
                      CompositedTransformTarget(
                        link: _unifiedAddressLayerLink,
                        child: Container(
                          decoration: BoxDecoration(
                            color: ThemeHelper.getPrimaryColor(context).withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(AppTheme.radiusM),
                            border: Border.all(
                              color: ThemeHelper.getPrimaryColor(context).withValues(alpha: 0.2),
                              width: 1.5,
                            ),
                          ),
                          child: TextFormField(
                            controller: _unifiedAddressController,
                            focusNode: _unifiedAddressFocusNode,
                            decoration: InputDecoration(
                              labelText: '🔍 Search Full Address',
                              hintText: 'Type any part of your address...',
                              prefixIcon: Icon(
                                Icons.search,
                                color: ThemeHelper.getPrimaryColor(context),
                              ),
                              suffixIcon: _isSearchingUnifiedAddress
                                  ? const Padding(
                                      padding: EdgeInsets.all(12.0),
                                      child: SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                                        ),
                                      ),
                                    )
                                  : _unifiedAddressController.text.isNotEmpty
                                      ? IconButton(
                                          icon: const Icon(Icons.clear),
                                          onPressed: () {
                                            _unifiedAddressController.clear();
                                            _hideUnifiedAddressSuggestions();
                                          },
                                        )
                                      : null,
                              filled: true,
                              fillColor: Colors.transparent,
                              labelStyle: AppTextStyles.labelMedium.copyWith(
                                color: ThemeHelper.getPrimaryColor(context),
                                fontWeight: FontWeight.w600,
                              ),
                              hintStyle: AppTextStyles.bodyMedium.copyWith(
                                color: ThemeHelper.getTextSecondaryColor(context).withValues(alpha: 0.6),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(AppTheme.radiusM),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(AppTheme.radiusM),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(AppTheme.radiusM),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: ThemeHelper.getTextPrimaryColor(context),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Helper text
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 14,
                              color: ThemeHelper.getTextSecondaryColor(context),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Search for your full address, then review auto-filled fields below',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: ThemeHelper.getTextSecondaryColor(context),
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingL),
                      
                      // Divider
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: ThemeHelper.getBorderColor(context),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'OR ENTER MANUALLY',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: ThemeHelper.getTextSecondaryColor(context),
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: ThemeHelper.getBorderColor(context),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppTheme.spacingL),
                      // ============================================
                      
                      // Street Address Field with autocomplete
                      CompositedTransformTarget(
                        link: _streetLayerLink,
                        child: _buildTextField(
                          controller: _streetController,
                          label: 'Street Address',
                          hint: 'Start typing street name...',
                          icon: Icons.location_on_outlined,
                          focusNode: _streetFocusNode,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter street address';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingL),
                      // City Field with autocomplete
                      CompositedTransformTarget(
                        link: _cityLayerLink,
                        child: _buildTextField(
                          controller: _cityController,
                          label: 'City',
                          hint: 'Start typing city name...',
                          icon: Icons.location_city_outlined,
                          focusNode: _cityFocusNode,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter city';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingL),
                      // State Field
                      _buildTextField(
                        controller: _stateController,
                        label: 'State/Province',
                        hint: 'e.g., New York',
                        icon: Icons.map_outlined,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter state/province';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppTheme.spacingL),
                      // Zip Code Field
                      _buildTextField(
                        controller: _zipCodeController,
                        label: 'Zip/Postal Code',
                        hint: 'e.g., SW1A 1AA (auto-fills address)',
                        icon: Icons.pin_outlined,
                        keyboardType: TextInputType.text, // Changed to text to support alphanumeric postcodes
                        suffixIcon: _isAutoFilling
                            ? const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                                  ),
                                ),
                              )
                            : null,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter zip/postal code';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppTheme.spacingL),
                      // Country Field
                      _buildTextField(
                        controller: _countryController,
                        label: 'Country',
                        hint: 'e.g., United Kingdom',
                        icon: Icons.public_outlined,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter country';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppTheme.spacingL),
                      // Set as Default Checkbox
                      _buildDefaultCheckbox(),
                      const SizedBox(height: AppTheme.spacingXL),
                    ],
                  ),
                ),
              ),
            ),
            // Save Button
            _buildSaveButton(),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: ThemeHelper.getBackgroundColor(context),
      ),
      child: Row(
        children: [
          // Back Button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: ThemeHelper.getSurfaceColor(context),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_back,
                color: ThemeHelper.getTextPrimaryColor(context),
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacingM),
          // Title
          Text(
            widget.address == null ? 'Add New Address' : 'Edit Address',
            style: AppTextStyles.titleLarge.copyWith(
              color: ThemeHelper.getTextPrimaryColor(context),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    Widget? suffixIcon,
    FocusNode? focusNode,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(
          icon,
          color: ThemeHelper.getTextSecondaryColor(context),
        ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: ThemeHelper.getSurfaceColor(context),
        labelStyle: AppTextStyles.labelMedium.copyWith(
          color: ThemeHelper.getTextSecondaryColor(context),
        ),
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: ThemeHelper.getTextSecondaryColor(context).withValues(alpha: 0.6),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
          borderSide: BorderSide(
            color: ThemeHelper.getBorderColor(context),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
          borderSide: BorderSide(
            color: ThemeHelper.getBorderColor(context),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
          borderSide: const BorderSide(
            color: AppColors.error,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingM,
          vertical: AppTheme.spacingM,
        ),
      ),
      style: AppTextStyles.bodyLarge.copyWith(
        color: ThemeHelper.getTextPrimaryColor(context),
      ),
    );
  }

  Widget _buildDefaultCheckbox() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final hasDefaultAddress = authProvider.userModel?.addresses
            .any((addr) => addr.isDefault) ?? false;

        return GestureDetector(
          onTap: () {
            setState(() {
              _isDefault = !_isDefault;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            decoration: BoxDecoration(
              color: ThemeHelper.getSurfaceColor(context),
              borderRadius: BorderRadius.circular(AppTheme.radiusM),
              border: Border.all(
                color: ThemeHelper.getBorderColor(context),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _isDefault
                          ? AppColors.primary
                          : ThemeHelper.getTextSecondaryColor(context),
                      width: 2,
                    ),
                    color: _isDefault
                        ? AppColors.primary
                        : Colors.transparent,
                  ),
                  child: _isDefault
                      ? const Icon(
                          Icons.check,
                          size: 16,
                          color: AppColors.textOnPrimary,
                        )
                      : null,
                ),
                const SizedBox(width: AppTheme.spacingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Set as default address',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: ThemeHelper.getTextPrimaryColor(context),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (hasDefaultAddress && !_isDefault)
                        Text(
                          'Another address is currently set as default',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: ThemeHelper.getTextSecondaryColor(context),
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSaveButton() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: ThemeHelper.getBackgroundColor(context),
        boxShadow: [
          BoxShadow(
            color: ThemeHelper.isDarkMode(context)
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeHelper.getPrimaryColor(context),
              foregroundColor: AppColors.textOnPrimary,
              disabledBackgroundColor: ThemeHelper.getTextSecondaryColor(context),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
              ),
              elevation: 0,
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.textOnPrimary),
                    ),
                  )
                : Text(
                    'Save Address',
                    style: AppTextStyles.buttonLarge.copyWith(
                      color: AppColors.textOnPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Try to capture current GPS coordinates for this address so that
      // delivery partners can see and navigate to the exact location.
      Map<String, double>? coordinates = widget.address?.coordinates;
      final position = await LocationService.getCurrentPosition();
      if (position != null) {
        coordinates = {
          'lat': position.latitude,
          'lng': position.longitude,
        };
      }

      final address = AddressModel(
        id: widget.address?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        label: _labelController.text.trim(),
        street: _streetController.text.trim(),
        city: _cityController.text.trim(),
        state: _stateController.text.trim(),
        zipCode: _zipCodeController.text.trim(),
        country: _countryController.text.trim(),
        isDefault: _isDefault,
        coordinates: coordinates,
      );

      if (widget.address == null) {
        // Add new address
        await authProvider.addAddress(address);
      } else {
        // Update existing address
        await authProvider.updateAddress(address);
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.address == null
                  ? 'Address added successfully'
                  : 'Address updated successfully',
            ),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving address: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}

