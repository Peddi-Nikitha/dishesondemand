import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

/// Simple wrapper around geolocator to handle permissions and position streams.
class LocationService {
  static Future<bool> ensurePermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  static Future<Position?> getCurrentPosition() async {
    final ok = await ensurePermission();
    if (!ok) return null;

    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  static Stream<Position> getPositionStream() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 25, // meters
      ),
    );
  }

  /// Reverse geocode coordinates to get address information
  static Future<Map<String, String>?> reverseGeocode(
    double latitude,
    double longitude,
  ) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isEmpty) return null;

      final place = placemarks.first;
      final doorNumber = place.subThoroughfare ?? '';
      final streetName = place.thoroughfare ?? place.street ?? '';
      
      return {
        'doorNumber': doorNumber,
        'streetName': streetName,
        'street': _formatStreet(place),
        'city': place.locality ?? place.subAdministrativeArea ?? '',
        'state': place.administrativeArea ?? '',
        'zipCode': place.postalCode ?? '',
        'country': place.country ?? '',
      };
    } catch (e) {
      return null;
    }
  }

  /// Format street address from placemark
  static String _formatStreet(Placemark place) {
    final parts = <String>[];
    
    // Add door number first if available
    if (place.subThoroughfare != null && place.subThoroughfare!.isNotEmpty) {
      parts.add(place.subThoroughfare!);
    }
    
    // Add street name
    if (place.thoroughfare != null && place.thoroughfare!.isNotEmpty) {
      parts.add(place.thoroughfare!);
    } else if (place.street != null && place.street!.isNotEmpty) {
      parts.add(place.street!);
    }
    
    return parts.join(' ');
  }
}


