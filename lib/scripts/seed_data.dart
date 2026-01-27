import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../firebase_options.dart';
import '../models/user_model.dart';
import '../models/order_model.dart';
import '../models/delivery_boy_model.dart';
import '../models/admin_model.dart';
import '../models/restaurant_settings_model.dart';
import '../utils/constants.dart';

/// Script to seed Firestore database with dummy data
/// Default password for all seed accounts: password123
/// 
/// To run this script:
///   flutter run -d chrome lib/scripts/seed_data.dart
///   OR
///   dart run lib/scripts/seed_data.dart
Future<void> main() async {
  print('🚀 Initializing Firebase...');
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('   ✓ Firebase initialized successfully');
  } catch (e) {
    // Firebase might already be initialized
    if (e.toString().contains('already been initialized')) {
      print('   ℹ️  Firebase already initialized');
    } else {
      print('   ⚠️  Firebase initialization error: $e');
      print('   💡 Make sure Firebase is properly configured in firebase_options.dart');
      rethrow; // Re-throw if it's a different error
    }
  }
  
  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  
  print('📦 Starting data seeding...\n');
  print('🔑 Default password for all accounts: password123\n');

  try {
    // 1. Seed Categories
    print('1️⃣  Seeding Categories...');
    await _seedCategories(firestore);
    
    // 2. Seed Products
    print('2️⃣  Seeding Products...');
    await _seedProducts(firestore);
    
    // 3. Seed Users (with Firebase Auth)
    print('3️⃣  Seeding Users (Firebase Auth + Firestore)...');
    await _seedUsers(firestore, auth);
    
    // 4. Seed Delivery Boys (with Firebase Auth)
    print('4️⃣  Seeding Delivery Boys (Firebase Auth + Firestore)...');
    await _seedDeliveryBoys(firestore, auth);
    
    // 5. Seed Admins (with Firebase Auth)
    print('5️⃣  Seeding Admins (Firebase Auth + Firestore)...');
    await _seedAdmins(firestore, auth);
    
    // 6. Seed Orders
    print('6️⃣  Seeding Orders...');
    await _seedOrders(firestore);
    
    // 7. Seed Restaurant Settings
    print('7️⃣  Seeding Restaurant Settings...');
    await _seedRestaurantSettings(firestore);
    
    print('\n✅ Data seeding completed successfully!');
    print('\n📋 Login Credentials:');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('👤 ADMIN:');
    print('   Email: admin@restaurant.com');
    print('   Password: password123');
    print('\n👥 USERS:');
    print('   Email: younes@example.com | Password: password123');
    print('   Email: ahmad@example.com | Password: password123');
    print('   Email: tarek@example.com | Password: password123');
    print('   Email: waled@example.com | Password: password123');
    print('   Email: mohamed@example.com | Password: password123');
    print('   Email: eyad@example.com | Password: password123');
    print('\n🚚 DELIVERY BOYS:');
    print('   Email: ahmed.driver@example.com | Password: password123');
    print('   Email: mohamed.driver@example.com | Password: password123');
    print('   Email: omar.driver@example.com | Password: password123');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  } catch (e, stackTrace) {
    print('\n❌ Error seeding data: $e');
    print('\n📋 Stack trace:');
    print(stackTrace);
    print('\n💡 Troubleshooting tips:');
    print('   1. Make sure Firebase is properly configured');
    print('   2. Check your firebase_options.dart file');
    print('   3. Ensure Firebase Authentication is enabled in Firebase Console');
    print('   4. Verify Firestore is enabled in Firebase Console');
  }
}

Future<void> _seedCategories(FirebaseFirestore firestore) async {
  final categories = [
    {'name': 'Starters', 'displayOrder': 1},
    {'name': 'Breakfast', 'displayOrder': 2},
    {'name': 'Lunch', 'displayOrder': 3},
    {'name': 'Supp', 'displayOrder': 4},
    {'name': 'Desserts', 'displayOrder': 5},
    {'name': 'Beverages', 'displayOrder': 6},
  ];

  for (var category in categories) {
    await firestore.collection(AppConstants.categoriesCollection).add({
      'name': category['name'],
      'displayOrder': category['displayOrder'],
      'isActive': true,
    });
    print('   ✓ Added category: ${category['name']}');
  }
}

Future<void> _seedProducts(FirebaseFirestore firestore) async {
  final products = [
    // Starters
    {'name': 'Schezwan Egg', 'category': 'Starters', 'price': 24.00, 'quantity': '1 plate', 'image': 'https://images.unsplash.com/photo-1610832958506-aa56368176cf?w=400&h=400&fit=crop'},
    {'name': 'Spring Rolls', 'category': 'Starters', 'price': 12.00, 'quantity': '6 pieces', 'image': 'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=400&h=400&fit=crop'},
    {'name': 'Chicken Wings', 'category': 'Starters', 'price': 18.00, 'quantity': '8 pieces', 'image': 'https://images.unsplash.com/photo-1527477396000-e27137b2a8c3?w=400&h=400&fit=crop'},
    {'name': 'Bruschetta', 'category': 'Starters', 'price': 10.00, 'quantity': '4 pieces', 'image': 'https://images.unsplash.com/photo-1572441713132-51c75654db73?w=400&h=400&fit=crop'},
    
    // Breakfast
    {'name': 'Pancakes', 'category': 'Breakfast', 'price': 15.00, 'quantity': '3 pieces', 'image': 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=400&h=400&fit=crop'},
    {'name': 'French Toast', 'category': 'Breakfast', 'price': 14.00, 'quantity': '2 slices', 'image': 'https://images.unsplash.com/photo-1484723091739-30a097e8f929?w=400&h=400&fit=crop'},
    {'name': 'Eggs Benedict', 'category': 'Breakfast', 'price': 18.00, 'quantity': '2 pieces', 'image': 'https://images.unsplash.com/photo-1588168333986-5078d3ae3976?w=400&h=400&fit=crop'},
    {'name': 'Waffles', 'category': 'Breakfast', 'price': 16.00, 'quantity': '2 pieces', 'image': 'https://images.unsplash.com/photo-1562376552-0d160a2f238d?w=400&h=400&fit=crop'},
    {'name': 'Avocado Toast', 'category': 'Breakfast', 'price': 11.00, 'quantity': '2 slices', 'image': 'https://images.unsplash.com/photo-1541519227354-08fa5d50c44d?w=400&h=400&fit=crop'},
    
    // Lunch
    {'name': 'Caesar Salad', 'category': 'Lunch', 'price': 16.00, 'quantity': '1 bowl', 'image': 'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=400&h=400&fit=crop'},
    {'name': 'Grilled Chicken', 'category': 'Lunch', 'price': 22.00, 'quantity': '1 plate', 'image': 'https://images.unsplash.com/photo-1532550907401-a78c000e25fb?w=400&h=400&fit=crop'},
    {'name': 'Beef Burger', 'category': 'Lunch', 'price': 20.00, 'quantity': '1 burger', 'image': 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400&h=400&fit=crop'},
    {'name': 'Fish & Chips', 'category': 'Lunch', 'price': 19.00, 'quantity': '1 plate', 'image': 'https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=400&h=400&fit=crop'},
    {'name': 'Pasta Carbonara', 'category': 'Lunch', 'price': 18.00, 'quantity': '1 plate', 'image': 'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=400&h=400&fit=crop'},
    
    // Supp (Dinner)
    {'name': 'Steak Dinner', 'category': 'Supp', 'price': 32.00, 'quantity': '1 plate', 'image': 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=400&h=400&fit=crop'},
    {'name': 'Salmon Fillet', 'category': 'Supp', 'price': 28.00, 'quantity': '1 plate', 'image': 'https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=400&h=400&fit=crop'},
    {'name': 'Lamb Chops', 'category': 'Supp', 'price': 30.00, 'quantity': '4 pieces', 'image': 'https://images.unsplash.com/photo-1604503468506-a8da13d82791?w=400&h=400&fit=crop'},
    {'name': 'Ribeye Steak', 'category': 'Supp', 'price': 35.00, 'quantity': '1 piece', 'image': 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=400&h=400&fit=crop'},
    
    // Desserts
    {'name': 'Chocolate Cake', 'category': 'Desserts', 'price': 12.00, 'quantity': '1 slice', 'image': 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=400&h=400&fit=crop'},
    {'name': 'Cheesecake', 'category': 'Desserts', 'price': 13.00, 'quantity': '1 slice', 'image': 'https://images.unsplash.com/photo-1524351199676-942e0d5d8ff3?w=400&h=400&fit=crop'},
    {'name': 'Ice Cream', 'category': 'Desserts', 'price': 8.00, 'quantity': '2 scoops', 'image': 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=400&h=400&fit=crop'},
    {'name': 'Tiramisu', 'category': 'Desserts', 'price': 14.00, 'quantity': '1 piece', 'image': 'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=400&h=400&fit=crop'},
    
    // Beverages
    {'name': 'Fresh Orange Juice', 'category': 'Beverages', 'price': 6.00, 'quantity': '250ml', 'image': 'https://images.unsplash.com/photo-1610832958506-aa56368176cf?w=400&h=400&fit=crop'},
    {'name': 'Coffee', 'category': 'Beverages', 'price': 5.00, 'quantity': '1 cup', 'image': 'https://images.unsplash.com/photo-1517487881594-2787fef5ebf7?w=400&h=400&fit=crop'},
    {'name': 'Iced Tea', 'category': 'Beverages', 'price': 4.00, 'quantity': '300ml', 'image': 'https://images.unsplash.com/photo-1556679343-c7306c1976b5?w=400&h=400&fit=crop'},
    {'name': 'Smoothie', 'category': 'Beverages', 'price': 7.00, 'quantity': '350ml', 'image': 'https://images.unsplash.com/photo-1505252585461-04c3a695d0a5?w=400&h=400&fit=crop'},
    {'name': 'Lemonade', 'category': 'Beverages', 'price': 5.00, 'quantity': '300ml', 'image': 'https://images.unsplash.com/photo-1523677011783-c91d1bbe2fdc?w=400&h=400&fit=crop'},
  ];

  final now = DateTime.now();
  for (var product in products) {
    await firestore.collection(AppConstants.productsCollection).add({
      'name': product['name'],
      'category': product['category'],
      'imageUrl': product['image'],
      'quantity': product['quantity'],
      'currentPrice': product['price'],
      'originalPrice': null,
      'rating': 4.5,
      'description': 'Delicious ${product['name']}',
      'isVeg': product['category'] == 'Beverages' || product['name'].toString().toLowerCase().contains('salad'),
      'isNonVeg': !(product['category'] == 'Beverages' || product['name'].toString().toLowerCase().contains('salad')),
      'isAvailable': true,
      'createdAt': now.toIso8601String(),
      'updatedAt': now.toIso8601String(),
    });
    print('   ✓ Added product: ${product['name']}');
  }
}

Future<void> _seedUsers(FirebaseFirestore firestore, FirebaseAuth auth) async {
  const defaultPassword = 'password123';
  final users = [
    {'name': 'Younes Ashour', 'email': 'younes@example.com', 'phone': '+2 01090229396'},
    {'name': 'Ahmad', 'email': 'ahmad@example.com', 'phone': '+2 01012345678'},
    {'name': 'Tarek', 'email': 'tarek@example.com', 'phone': '+2 01023456789'},
    {'name': 'Waled', 'email': 'waled@example.com', 'phone': '+2 01034567890'},
    {'name': 'Mohamed', 'email': 'mohamed@example.com', 'phone': '+2 01045678901'},
    {'name': 'Eyad', 'email': 'eyad@example.com', 'phone': '+2 01056789012'},
  ];

  final now = DateTime.now();
  for (var user in users) {
    try {
      // Create Firebase Auth account
      UserCredential? credential;
      try {
        credential = await auth.createUserWithEmailAndPassword(
          email: user['email']!,
          password: defaultPassword,
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          // User already exists, sign in to get the user
          credential = await auth.signInWithEmailAndPassword(
            email: user['email']!,
            password: defaultPassword,
          );
        } else {
          rethrow;
        }
      }

      final uid = credential.user!.uid;
      
      final userModel = UserModel(
        uid: uid,
        email: user['email']!,
        name: user['name'],
        phone: user['phone'],
        role: AppConstants.roleUser,
        createdAt: now,
        updatedAt: now,
      );
      
      await firestore.collection(AppConstants.usersCollection).doc(uid).set(userModel.toFirestore());
      
      // Sign out to avoid authentication state issues
      await auth.signOut();
      
      print('   ✓ Added user: ${user['name']} (${user['email']})');
    } on FirebaseAuthException catch (e) {
      print('   ⚠️  Failed to create user ${user['email']}: ${e.code} - ${e.message}');
    } catch (e) {
      print('   ⚠️  Failed to create user ${user['email']}: $e');
    }
  }
}

Future<void> _seedDeliveryBoys(FirebaseFirestore firestore, FirebaseAuth auth) async {
  const defaultPassword = 'password123';
  final deliveryBoys = [
    {'name': 'Ahmed Ali', 'email': 'ahmed.driver@example.com', 'phone': '+2 01011111111', 'status': 'active'},
    {'name': 'Mohamed Hassan', 'email': 'mohamed.driver@example.com', 'phone': '+2 01022222222', 'status': 'active'},
    {'name': 'Omar Ibrahim', 'email': 'omar.driver@example.com', 'phone': '+2 01033333333', 'status': 'pending'},
  ];

  final now = DateTime.now();
  for (var driver in deliveryBoys) {
    try {
      // Create Firebase Auth account
      UserCredential? credential;
      try {
        credential = await auth.createUserWithEmailAndPassword(
          email: driver['email']!,
          password: defaultPassword,
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          // User already exists, sign in to get the user
          credential = await auth.signInWithEmailAndPassword(
            email: driver['email']!,
            password: defaultPassword,
          );
        } else {
          rethrow;
        }
      }

      final uid = credential.user!.uid;
      
      final deliveryBoyModel = DeliveryBoyModel(
        uid: uid,
        email: driver['email']!,
        name: driver['name'],
        phone: driver['phone'],
        role: AppConstants.roleDeliveryBoy,
        status: driver['status']!,
        vehicleType: 'motorcycle',
        vehicleNumber: 'ABC-${driver['phone']!.substring(driver['phone']!.length - 3)}',
        isAvailable: driver['status'] == 'active',
        totalDeliveries: driver['status'] == 'active' ? 50 : 0,
        totalEarnings: driver['status'] == 'active' ? 1500.0 : 0.0,
        rating: driver['status'] == 'active' ? 4.8 : 0.0,
        createdAt: now,
        updatedAt: now,
      );
      
      await firestore.collection(AppConstants.deliveryBoysCollection).doc(uid).set(deliveryBoyModel.toFirestore());
      
      // Sign out to avoid authentication state issues
      await auth.signOut();
      
      print('   ✓ Added delivery boy: ${driver['name']} (${driver['email']})');
    } on FirebaseAuthException catch (e) {
      print('   ⚠️  Failed to create delivery boy ${driver['email']}: ${e.code} - ${e.message}');
    } catch (e) {
      print('   ⚠️  Failed to create delivery boy ${driver['email']}: $e');
    }
  }
}

Future<void> _seedAdmins(FirebaseFirestore firestore, FirebaseAuth auth) async {
  const defaultPassword = 'password123';
  final adminData = {
    'email': 'admin@restaurant.com',
    'name': 'Admin User',
  };

  try {
    // Create Firebase Auth account
    UserCredential? credential;
    try {
      credential = await auth.createUserWithEmailAndPassword(
        email: adminData['email']!,
        password: defaultPassword,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        // User already exists, sign in to get the user
        credential = await auth.signInWithEmailAndPassword(
          email: adminData['email']!,
          password: defaultPassword,
        );
      } else {
        rethrow;
      }
    }

    final uid = credential.user!.uid;
    
    final admin = AdminModel(
      uid: uid,
      email: adminData['email']!,
      name: adminData['name'],
      role: AppConstants.roleAdmin,
      permissions: ['all'],
      createdAt: DateTime.now(),
    );
    
    await firestore.collection(AppConstants.adminsCollection).doc(uid).set(admin.toFirestore());
    
    // Sign out to avoid authentication state issues
    await auth.signOut();
    
    print('   ✓ Added admin: ${admin.name} (${admin.email})');
  } on FirebaseAuthException catch (e) {
    print('   ⚠️  Failed to create admin ${adminData['email']}: ${e.code} - ${e.message}');
  } catch (e) {
    print('   ⚠️  Failed to create admin ${adminData['email']}: $e');
  }
}

Future<void> _seedOrders(FirebaseFirestore firestore) async {
  // Get some users and products first
  final usersSnapshot = await firestore.collection(AppConstants.usersCollection).limit(3).get();
  final productsSnapshot = await firestore.collection(AppConstants.productsCollection).limit(5).get();
  
  if (usersSnapshot.docs.isEmpty || productsSnapshot.docs.isEmpty) {
    print('   ⚠️  No users or products found. Skipping orders.');
    return;
  }

  final users = usersSnapshot.docs;
  final products = productsSnapshot.docs;
  final now = DateTime.now();

  final statuses = [
    AppConstants.orderStatusPending,
    AppConstants.orderStatusConfirmed,
    AppConstants.orderStatusPreparing,
    AppConstants.orderStatusReady,
    AppConstants.orderStatusAssigned,
    AppConstants.orderStatusDelivered,
  ];

  for (int i = 0; i < 10; i++) {
    final user = users[i % users.length];
    final product1 = products[i % products.length];
    final product2 = products[(i + 1) % products.length];
    
    final subtotal = (product1.data()['currentPrice'] as num).toDouble() + 
                     (product2.data()['currentPrice'] as num).toDouble();
    final deliveryFee = 5.0;
    final discount = 0.0;
    final total = subtotal + deliveryFee - discount;
    
    final orderDate = now.subtract(Duration(days: i, hours: i));
    final status = statuses[i % statuses.length];
    
    final order = OrderModel(
      id: 'order_${DateTime.now().millisecondsSinceEpoch}_$i',
      userId: user.id,
      orderNumber: '#${458719 + i}',
      items: [
        OrderItemModel(
          productId: product1.id,
          productName: product1.data()['name'] as String,
          quantity: 2,
          price: (product1.data()['currentPrice'] as num).toDouble(),
          imageUrl: product1.data()['imageUrl'] as String,
        ),
        OrderItemModel(
          productId: product2.id,
          productName: product2.data()['name'] as String,
          quantity: 1,
          price: (product2.data()['currentPrice'] as num).toDouble(),
          imageUrl: product2.data()['imageUrl'] as String,
        ),
      ],
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      discount: discount,
      total: total,
      status: status,
      deliveryAddress: AddressModel(
        id: 'addr_$i',
        label: 'Home',
        street: '${100 + i} Main Street',
        city: 'New Cairo',
        state: 'Cairo',
        zipCode: '12345',
        country: 'Egypt',
        isDefault: true,
        coordinates: {'lat': 30.0444, 'lng': 31.2357},
      ),
      paymentMethod: PaymentMethodModel(
        id: 'pm_$i',
        type: i % 2 == 0 ? 'card' : 'cash',
        last4: i % 2 == 0 ? '1234' : null,
        brand: i % 2 == 0 ? 'visa' : null,
        isDefault: true,
      ),
      createdAt: orderDate,
      updatedAt: orderDate,
    );
    
    await firestore.collection(AppConstants.ordersCollection).doc(order.id).set(order.toFirestore());
    print('   ✓ Added order: ${order.orderNumber}');
  }
}

Future<void> _seedRestaurantSettings(FirebaseFirestore firestore) async {
  final settings = RestaurantSettingsModel(
    name: 'Restaurant OX',
    phone: '+2 01090229396',
    email: 'foxf.com@gmail.com',
    address: 'New Cairo - Egypt',
    currency: '\$',
    generalDiscount: 0.0,
    deliveryEnabled: true,
    orderReservationEnabled: true,
    updatedAt: DateTime.now(),
  );
  
  await firestore.collection(AppConstants.restaurantCollection).doc(AppConstants.settingsDocument).set(settings.toFirestore());
  print('   ✓ Added restaurant settings');
}


