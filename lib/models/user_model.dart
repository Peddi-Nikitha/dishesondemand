/// User model for customers
class UserModel {
  final String uid;
  final String email;
  final String? name;
  final String? phone;
  final String? photoUrl;
  final String role; // 'user', 'delivery_boy', 'admin'
  final List<AddressModel> addresses;
  final List<PaymentMethodModel> paymentMethods;
  final List<String> favorites; // Product IDs
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.uid,
    required this.email,
    this.name,
    this.phone,
    this.photoUrl,
    required this.role,
    this.addresses = const [],
    this.paymentMethods = const [],
    this.favorites = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'phone': phone,
      'photoUrl': photoUrl,
      'role': role,
      'addresses': addresses.map((addr) => addr.toMap()).toList(),
      'paymentMethods': paymentMethods.map((pm) => pm.toMap()).toList(),
      'favorites': favorites,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create from Firestore document
  factory UserModel.fromFirestore(Map<String, dynamic> data, String id) {
    return UserModel(
      uid: id,
      email: data['email'] ?? '',
      name: data['name'],
      phone: data['phone'],
      photoUrl: data['photoUrl'],
      role: data['role'] ?? 'user',
      addresses: (data['addresses'] as List<dynamic>?)
              ?.map((addr) => AddressModel.fromMap(addr as Map<String, dynamic>))
              .toList() ??
          [],
      paymentMethods: (data['paymentMethods'] as List<dynamic>?)
              ?.map((pm) => PaymentMethodModel.fromMap(pm as Map<String, dynamic>))
              .toList() ??
          [],
      favorites: (data['favorites'] as List<dynamic>?)?.cast<String>() ?? [],
      createdAt: DateTime.parse(data['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(data['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  UserModel copyWith({
    String? name,
    String? phone,
    String? photoUrl,
    List<AddressModel>? addresses,
    List<PaymentMethodModel>? paymentMethods,
    List<String>? favorites,
  }) {
    return UserModel(
      uid: uid,
      email: email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role,
      addresses: addresses ?? this.addresses,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      favorites: favorites ?? this.favorites,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}

/// Address model
class AddressModel {
  final String id;
  final String label;
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final bool isDefault;
  final Map<String, double>? coordinates; // {lat: double, lng: double}

  AddressModel({
    required this.id,
    required this.label,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    this.isDefault = false,
    this.coordinates,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'label': label,
      'street': street,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'country': country,
      'isDefault': isDefault,
      'coordinates': coordinates,
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      id: map['id'] ?? '',
      label: map['label'] ?? '',
      street: map['street'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      zipCode: map['zipCode'] ?? '',
      country: map['country'] ?? '',
      isDefault: map['isDefault'] ?? false,
      coordinates: map['coordinates'] != null
          ? Map<String, double>.from(map['coordinates'])
          : null,
    );
  }
}

/// Payment method model
class PaymentMethodModel {
  final String id;
  final String type; // 'card', 'cash', 'wallet'
  final String? last4;
  final String? brand; // 'visa', 'mastercard', etc.
  final bool isDefault;

  PaymentMethodModel({
    required this.id,
    required this.type,
    this.last4,
    this.brand,
    this.isDefault = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'last4': last4,
      'brand': brand,
      'isDefault': isDefault,
    };
  }

  factory PaymentMethodModel.fromMap(Map<String, dynamic> map) {
    return PaymentMethodModel(
      id: map['id'] ?? '',
      type: map['type'] ?? 'cash',
      last4: map['last4'],
      brand: map['brand'],
      isDefault: map['isDefault'] ?? false,
    );
  }
}

