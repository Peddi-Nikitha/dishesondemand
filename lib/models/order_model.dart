
import 'user_model.dart';

/// Order model
class OrderModel {
  final String id;
  final String userId;
  final String orderNumber;
  final List<OrderItemModel> items;
  final double subtotal;
  final double deliveryFee;
  final double discount;
  final double total;
  final String status; // 'pending', 'confirmed', 'preparing', 'ready', 'assigned', 'picked_up', 'in_transit', 'delivered', 'cancelled'
  final AddressModel deliveryAddress;
  final PaymentMethodModel paymentMethod;
  final String? deliveryBoyId;
  final DateTime? assignedAt;
  final DateTime? pickedUpAt;
  final DateTime? deliveredAt;
  final Map<String, double>? deliveryBoyLocation; // {lat: double, lng: double}
  final DateTime createdAt;
  final DateTime updatedAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.orderNumber,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.discount,
    required this.total,
    required this.status,
    required this.deliveryAddress,
    required this.paymentMethod,
    this.deliveryBoyId,
    this.assignedAt,
    this.pickedUpAt,
    this.deliveredAt,
    this.deliveryBoyLocation,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'orderNumber': orderNumber,
      'items': items.map((item) => item.toMap()).toList(),
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'discount': discount,
      'total': total,
      'status': status,
      'deliveryAddress': deliveryAddress.toMap(),
      'paymentMethod': paymentMethod.toMap(),
      'deliveryBoyId': deliveryBoyId,
      'assignedAt': assignedAt?.toIso8601String(),
      'pickedUpAt': pickedUpAt?.toIso8601String(),
      'deliveredAt': deliveredAt?.toIso8601String(),
      'deliveryBoyLocation': deliveryBoyLocation,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory OrderModel.fromFirestore(Map<String, dynamic> data, String id) {
    return OrderModel(
      id: id,
      userId: data['userId'] ?? '',
      orderNumber: data['orderNumber'] ?? '',
      items: (data['items'] as List<dynamic>?)
              ?.map((item) => OrderItemModel.fromMap(item as Map<String, dynamic>))
              .toList() ??
          [],
      subtotal: (data['subtotal'] ?? 0.0).toDouble(),
      deliveryFee: (data['deliveryFee'] ?? 0.0).toDouble(),
      discount: (data['discount'] ?? 0.0).toDouble(),
      total: (data['total'] ?? 0.0).toDouble(),
      status: data['status'] ?? 'pending',
      deliveryAddress: AddressModel.fromMap(
          data['deliveryAddress'] as Map<String, dynamic>),
      paymentMethod: PaymentMethodModel.fromMap(
          data['paymentMethod'] as Map<String, dynamic>),
      deliveryBoyId: data['deliveryBoyId'],
      assignedAt: data['assignedAt'] != null
          ? DateTime.parse(data['assignedAt'])
          : null,
      pickedUpAt: data['pickedUpAt'] != null
          ? DateTime.parse(data['pickedUpAt'])
          : null,
      deliveredAt: data['deliveredAt'] != null
          ? DateTime.parse(data['deliveredAt'])
          : null,
      deliveryBoyLocation: data['deliveryBoyLocation'] != null
          ? Map<String, double>.from(data['deliveryBoyLocation'])
          : null,
      createdAt: DateTime.parse(
          data['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(
          data['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  OrderModel copyWith({
    String? status,
    String? deliveryBoyId,
    DateTime? assignedAt,
    DateTime? pickedUpAt,
    DateTime? deliveredAt,
    Map<String, double>? deliveryBoyLocation,
  }) {
    return OrderModel(
      id: id,
      userId: userId,
      orderNumber: orderNumber,
      items: items,
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      discount: discount,
      total: total,
      status: status ?? this.status,
      deliveryAddress: deliveryAddress,
      paymentMethod: paymentMethod,
      deliveryBoyId: deliveryBoyId ?? this.deliveryBoyId,
      assignedAt: assignedAt ?? this.assignedAt,
      pickedUpAt: pickedUpAt ?? this.pickedUpAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      deliveryBoyLocation: deliveryBoyLocation ?? this.deliveryBoyLocation,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }
}

/// Order item model
class OrderItemModel {
  final String productId;
  final String productName;
  final int quantity;
  final double price;
  final String imageUrl;

  OrderItemModel({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'price': price,
      'imageUrl': imageUrl,
    };
  }

  factory OrderItemModel.fromMap(Map<String, dynamic> map) {
    return OrderItemModel(
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      quantity: map['quantity'] ?? 1,
      price: (map['price'] ?? 0.0).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
    );
  }
}


