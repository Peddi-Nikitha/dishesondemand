/// Product model for menu items
class ProductModel {
  final String id;
  final String name;
  final String category;
  final String imageUrl;
  final String quantity;
  final double currentPrice;
  final double? originalPrice;
  final double rating;
  final String description;
  final bool isVeg;
  final bool isNonVeg;
  final bool isAvailable;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.quantity,
    required this.currentPrice,
    this.originalPrice,
    this.rating = 4.5,
    this.description = '',
    this.isVeg = false,
    this.isNonVeg = false,
    this.isAvailable = true,
    required this.createdAt,
    required this.updatedAt,
  });

  String get formattedCurrentPrice => '£${currentPrice.toStringAsFixed(2)}';
  String get formattedOriginalPrice =>
      originalPrice != null ? '£${originalPrice!.toStringAsFixed(2)}' : '';

  // Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'category': category,
      'imageUrl': imageUrl,
      'quantity': quantity,
      'currentPrice': currentPrice,
      'originalPrice': originalPrice,
      'rating': rating,
      'description': description,
      'isVeg': isVeg,
      'isNonVeg': isNonVeg,
      'isAvailable': isAvailable,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create from Firestore document
  factory ProductModel.fromFirestore(Map<String, dynamic> data, String id) {
    return ProductModel(
      id: id,
      name: data['name'] ?? '',
      category: data['category'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      quantity: data['quantity'] ?? '',
      currentPrice: (data['currentPrice'] ?? 0.0).toDouble(),
      originalPrice: data['originalPrice'] != null
          ? (data['originalPrice'] as num).toDouble()
          : null,
      rating: (data['rating'] ?? 4.5).toDouble(),
      description: data['description'] ?? '',
      isVeg: data['isVeg'] ?? false,
      isNonVeg: data['isNonVeg'] ?? false,
      isAvailable: data['isAvailable'] ?? true,
      createdAt: DateTime.parse(
          data['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(
          data['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  ProductModel copyWith({
    String? name,
    String? category,
    String? imageUrl,
    String? quantity,
    double? currentPrice,
    double? originalPrice,
    double? rating,
    String? description,
    bool? isVeg,
    bool? isNonVeg,
    bool? isAvailable,
  }) {
    return ProductModel(
      id: id,
      name: name ?? this.name,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
      currentPrice: currentPrice ?? this.currentPrice,
      originalPrice: originalPrice ?? this.originalPrice,
      rating: rating ?? this.rating,
      description: description ?? this.description,
      isVeg: isVeg ?? this.isVeg,
      isNonVeg: isNonVeg ?? this.isNonVeg,
      isAvailable: isAvailable ?? this.isAvailable,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}

/// Category model
class CategoryModel {
  final String id;
  final String name;
  final String? imageUrl;
  final int displayOrder;
  final bool isActive;

  CategoryModel({
    required this.id,
    required this.name,
    this.imageUrl,
    this.displayOrder = 0,
    this.isActive = true,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'displayOrder': displayOrder,
      'isActive': isActive,
    };
  }

  factory CategoryModel.fromFirestore(Map<String, dynamic> data, String id) {
    return CategoryModel(
      id: id,
      name: data['name'] ?? '',
      imageUrl: data['imageUrl'],
      displayOrder: data['displayOrder'] ?? 0,
      isActive: data['isActive'] ?? true,
    );
  }

  CategoryModel copyWith({
    String? id,
    String? name,
    String? imageUrl,
    int? displayOrder,
    bool? isActive,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      displayOrder: displayOrder ?? this.displayOrder,
      isActive: isActive ?? this.isActive,
    );
  }
}

