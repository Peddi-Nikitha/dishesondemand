/// Delivery boy model
class DeliveryBoyModel {
  final String uid;
  final String email;
  final String? name;
  final String? phone;
  final String? photoUrl;
  final String role; // 'delivery_boy'
  final String status; // 'active', 'inactive', 'pending'
  final String? vehicleType;
  final String? vehicleNumber;
  final Map<String, String>? documents; // {license: url, vehicleRegistration: url, insurance: url}
  final Map<String, double>? currentLocation; // {lat: double, lng: double}
  final DateTime? locationUpdatedAt;
  final bool isAvailable;
  final int totalDeliveries;
  final double totalEarnings;
  final double rating;
  final DateTime createdAt;
  final DateTime updatedAt;

  DeliveryBoyModel({
    required this.uid,
    required this.email,
    this.name,
    this.phone,
    this.photoUrl,
    required this.role,
    this.status = 'pending',
    this.vehicleType,
    this.vehicleNumber,
    this.documents,
    this.currentLocation,
    this.locationUpdatedAt,
    this.isAvailable = false,
    this.totalDeliveries = 0,
    this.totalEarnings = 0.0,
    this.rating = 0.0,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'phone': phone,
      'photoUrl': photoUrl,
      'role': role,
      'status': status,
      'vehicleType': vehicleType,
      'vehicleNumber': vehicleNumber,
      'documents': documents,
      'currentLocation': currentLocation,
      'locationUpdatedAt': locationUpdatedAt?.toIso8601String(),
      'isAvailable': isAvailable,
      'totalDeliveries': totalDeliveries,
      'totalEarnings': totalEarnings,
      'rating': rating,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory DeliveryBoyModel.fromFirestore(Map<String, dynamic> data, String id) {
    return DeliveryBoyModel(
      uid: id,
      email: data['email'] ?? '',
      name: data['name'],
      phone: data['phone'],
      photoUrl: data['photoUrl'],
      role: data['role'] ?? 'delivery_boy',
      status: data['status'] ?? 'pending',
      vehicleType: data['vehicleType'],
      vehicleNumber: data['vehicleNumber'],
      documents: data['documents'] != null
          ? Map<String, String>.from(data['documents'])
          : null,
      currentLocation: data['currentLocation'] != null
          ? Map<String, double>.from(data['currentLocation'])
          : null,
      locationUpdatedAt: data['locationUpdatedAt'] != null
          ? DateTime.parse(data['locationUpdatedAt'])
          : null,
      isAvailable: data['isAvailable'] ?? false,
      totalDeliveries: data['totalDeliveries'] ?? 0,
      totalEarnings: (data['totalEarnings'] ?? 0.0).toDouble(),
      rating: (data['rating'] ?? 0.0).toDouble(),
      createdAt: DateTime.parse(
          data['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(
          data['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  DeliveryBoyModel copyWith({
    String? name,
    String? phone,
    String? photoUrl,
    String? status,
    String? vehicleType,
    String? vehicleNumber,
    Map<String, String>? documents,
    Map<String, double>? currentLocation,
    bool? isAvailable,
    int? totalDeliveries,
    double? totalEarnings,
    double? rating,
  }) {
    return DeliveryBoyModel(
      uid: uid,
      email: email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role,
      status: status ?? this.status,
      vehicleType: vehicleType ?? this.vehicleType,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      documents: documents ?? this.documents,
      currentLocation: currentLocation ?? this.currentLocation,
      locationUpdatedAt: currentLocation != null ? DateTime.now() : locationUpdatedAt,
      isAvailable: isAvailable ?? this.isAvailable,
      totalDeliveries: totalDeliveries ?? this.totalDeliveries,
      totalEarnings: totalEarnings ?? this.totalEarnings,
      rating: rating ?? this.rating,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}

