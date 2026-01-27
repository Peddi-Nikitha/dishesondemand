/// Restaurant settings model
class RestaurantSettingsModel {
  final String name;
  final String phone;
  final String email;
  final String address;
  final String? logoUrl;
  final String currency;
  final double generalDiscount;
  final bool deliveryEnabled;
  final bool orderReservationEnabled;
  final Map<String, String>? socialMedia; // {facebook: url, twitter: url, tiktok: url, youtube: url}
  final DateTime updatedAt;

  RestaurantSettingsModel({
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    this.logoUrl,
    this.currency = '\$',
    this.generalDiscount = 0.0,
    this.deliveryEnabled = false,
    this.orderReservationEnabled = false,
    this.socialMedia,
    required this.updatedAt,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      'logoUrl': logoUrl,
      'currency': currency,
      'generalDiscount': generalDiscount,
      'deliveryEnabled': deliveryEnabled,
      'orderReservationEnabled': orderReservationEnabled,
      'socialMedia': socialMedia,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory RestaurantSettingsModel.fromFirestore(Map<String, dynamic> data) {
    return RestaurantSettingsModel(
      name: data['name'] ?? 'Restaurant',
      phone: data['phone'] ?? '',
      email: data['email'] ?? '',
      address: data['address'] ?? '',
      logoUrl: data['logoUrl'],
      currency: data['currency'] ?? '\$',
      generalDiscount: (data['generalDiscount'] ?? 0.0).toDouble(),
      deliveryEnabled: data['deliveryEnabled'] ?? false,
      orderReservationEnabled: data['orderReservationEnabled'] ?? false,
      socialMedia: data['socialMedia'] != null
          ? Map<String, String>.from(data['socialMedia'])
          : null,
      updatedAt: DateTime.parse(
          data['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  RestaurantSettingsModel copyWith({
    String? name,
    String? phone,
    String? email,
    String? address,
    String? logoUrl,
    String? currency,
    double? generalDiscount,
    bool? deliveryEnabled,
    bool? orderReservationEnabled,
    Map<String, String>? socialMedia,
  }) {
    return RestaurantSettingsModel(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      logoUrl: logoUrl ?? this.logoUrl,
      currency: currency ?? this.currency,
      generalDiscount: generalDiscount ?? this.generalDiscount,
      deliveryEnabled: deliveryEnabled ?? this.deliveryEnabled,
      orderReservationEnabled: orderReservationEnabled ?? this.orderReservationEnabled,
      socialMedia: socialMedia ?? this.socialMedia,
      updatedAt: DateTime.now(),
    );
  }
}

