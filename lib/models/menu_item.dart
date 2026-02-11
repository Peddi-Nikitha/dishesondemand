/// Menu item data model for restaurant dishes
class MenuItem {
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

  const MenuItem({
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
  });

  String get formattedCurrentPrice => '£${currentPrice.toStringAsFixed(0)}';
  String get formattedOriginalPrice => originalPrice != null ? '£${originalPrice!.toStringAsFixed(0)}' : '';
}

/// Menu data organized by categories
class MenuData {
  // Main Course Items
  static final List<MenuItem> mainCourse = [
    MenuItem(
      id: 'mc1',
      name: 'Creamy Pasta',
      category: 'Main Course',
      imageUrl: 'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=400&h=400&fit=crop',
      quantity: '1 serving',
      currentPrice: 15,
      originalPrice: 18,
      rating: 4.5,
      description: 'Delicious creamy pasta with fresh ingredients and authentic Italian flavors. Perfectly cooked and seasoned to perfection.',
      isVeg: true,
    ),
    MenuItem(
      id: 'mc2',
      name: 'Mushroom Risotto',
      category: 'Main Course',
      imageUrl: 'https://images.unsplash.com/photo-1574894709920-11b28e7367e3?w=400&h=400&fit=crop',
      quantity: '1 serving',
      currentPrice: 16,
      originalPrice: 20,
      rating: 4.6,
      description: 'Creamy arborio rice cooked with fresh mushrooms, parmesan cheese, and white wine. A classic Italian comfort dish.',
      isVeg: true,
    ),
    MenuItem(
      id: 'mc3',
      name: 'Beef Lasagna',
      category: 'Main Course',
      imageUrl: 'https://images.unsplash.com/photo-1574894709920-11b28e7367e3?w=400&h=400&fit=crop',
      quantity: '1 serving',
      currentPrice: 18,
      originalPrice: 22,
      rating: 4.7,
      description: 'Layered pasta with rich meat sauce, creamy béchamel, and melted cheese. Baked to golden perfection.',
      isNonVeg: true,
    ),
    MenuItem(
      id: 'mc4',
      name: 'Margherita Pizza',
      category: 'Main Course',
      imageUrl: 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=400&h=400&fit=crop',
      quantity: '1 large',
      currentPrice: 20,
      originalPrice: 24,
      rating: 4.8,
      description: 'Classic Margherita pizza with fresh mozzarella, basil, and tomato sauce. Baked to perfection in our wood-fired oven.',
      isVeg: true,
    ),
    MenuItem(
      id: 'mc5',
      name: 'Classic Burger',
      category: 'Main Course',
      imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400&h=400&fit=crop',
      quantity: '1 piece',
      currentPrice: 12,
      originalPrice: 15,
      rating: 4.7,
      description: 'Juicy beef patty with fresh vegetables, special sauce, and a perfectly toasted bun. Served with crispy fries.',
      isNonVeg: true,
    ),
    MenuItem(
      id: 'mc6',
      name: 'Creamy Soup',
      category: 'Main Course',
      imageUrl: 'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=400&h=400&fit=crop',
      quantity: '1 bowl',
      currentPrice: 10,
      originalPrice: 12,
      rating: 4.5,
      description: 'Rich and creamy soup made with fresh ingredients, served hot with artisan bread. Perfect starter for any meal.',
      isVeg: true,
    ),
  ];

  // Non-Veg Items
  static final List<MenuItem> nonVeg = [
    MenuItem(
      id: 'nv1',
      name: 'Grilled Chicken',
      category: 'Non-Veg',
      imageUrl: 'https://images.unsplash.com/photo-1532550907401-a78c000e25fb?w=400&h=400&fit=crop',
      quantity: '1 serving',
      currentPrice: 18,
      originalPrice: 22,
      rating: 4.9,
      description: 'Tender grilled chicken breast marinated in herbs and spices, served with roasted vegetables and signature sauce. Perfectly cooked to juicy perfection.',
      isNonVeg: true,
    ),
    MenuItem(
      id: 'nv2',
      name: 'Premium Steak',
      category: 'Non-Veg',
      imageUrl: 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=400&h=400&fit=crop',
      quantity: '1 serving',
      currentPrice: 32,
      originalPrice: 38,
      rating: 4.8,
      description: 'Prime cut steak grilled to perfection, served with mashed potatoes, seasonal vegetables, and rich gravy. A premium dining experience.',
      isNonVeg: true,
    ),
    MenuItem(
      id: 'nv3',
      name: 'Lamb Chops',
      category: 'Non-Veg',
      imageUrl: 'https://images.unsplash.com/photo-1604503468506-a8da13d82791?w=400&h=400&fit=crop',
      quantity: '1 serving',
      currentPrice: 26,
      originalPrice: 30,
      rating: 4.7,
      description: 'Tender lamb chops marinated in Mediterranean herbs, grilled to perfection. Served with mint sauce and roasted vegetables.',
      isNonVeg: true,
    ),
    MenuItem(
      id: 'nv4',
      name: 'Grilled Salmon',
      category: 'Non-Veg',
      imageUrl: 'https://images.unsplash.com/photo-1467003909585-2f8a72700288?w=400&h=400&fit=crop',
      quantity: '1 serving',
      currentPrice: 24,
      originalPrice: 28,
      rating: 4.8,
      description: 'Fresh Atlantic salmon grilled with lemon and herbs, served with steamed vegetables and dill sauce. Healthy and delicious.',
      isNonVeg: true,
    ),
    MenuItem(
      id: 'nv5',
      name: 'Seafood Platter',
      category: 'Non-Veg',
      imageUrl: 'https://images.unsplash.com/photo-1559339352-11d035aa65de?w=400&h=400&fit=crop',
      quantity: '1 serving',
      currentPrice: 28,
      originalPrice: 35,
      rating: 4.7,
      description: 'Fresh selection of premium seafood including grilled fish, shrimp, and calamari. Served with lemon butter sauce and seasonal sides.',
      isNonVeg: true,
    ),
    MenuItem(
      id: 'nv6',
      name: 'BBQ Ribs',
      category: 'Non-Veg',
      imageUrl: 'https://images.unsplash.com/photo-1529692236671-f1f6cf9683ba?w=400&h=400&fit=crop',
      quantity: '1 serving',
      currentPrice: 22,
      originalPrice: 26,
      rating: 4.6,
      description: 'Tender pork ribs slow-cooked and glazed with our signature BBQ sauce. Served with coleslaw and fries.',
      isNonVeg: true,
    ),
  ];

  // Veg Items
  static final List<MenuItem> veg = [
    MenuItem(
      id: 'v1',
      name: 'Veg Pasta',
      category: 'Veg',
      imageUrl: 'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=400&h=400&fit=crop',
      quantity: '1 serving',
      currentPrice: 14,
      originalPrice: 17,
      rating: 4.5,
      description: 'Fresh pasta with seasonal vegetables, tomato sauce, and herbs. A vegetarian delight packed with flavor.',
      isVeg: true,
    ),
    MenuItem(
      id: 'v2',
      name: 'Veg Supreme Pizza',
      category: 'Veg',
      imageUrl: 'https://images.unsplash.com/photo-1574071318508-1cdbab80d002?w=400&h=400&fit=crop',
      quantity: '1 large',
      currentPrice: 18,
      originalPrice: 22,
      rating: 4.6,
      description: 'Loaded with fresh vegetables, bell peppers, mushrooms, olives, and cheese. A vegetarian favorite.',
      isVeg: true,
    ),
    MenuItem(
      id: 'v3',
      name: 'Vegetable Curry',
      category: 'Veg',
      imageUrl: 'https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=400&h=400&fit=crop',
      quantity: '1 serving',
      currentPrice: 13,
      originalPrice: 16,
      rating: 4.4,
      description: 'Mixed vegetables cooked in aromatic spices and coconut curry. Served with basmati rice and naan bread.',
      isVeg: true,
    ),
    MenuItem(
      id: 'v4',
      name: 'Veg Burger',
      category: 'Veg',
      imageUrl: 'https://images.unsplash.com/photo-1525059696034-4967a7290027?w=400&h=400&fit=crop',
      quantity: '1 piece',
      currentPrice: 11,
      originalPrice: 14,
      rating: 4.5,
      description: 'Delicious vegetable patty made with fresh vegetables and spices, served with fresh lettuce, tomato, and special sauce.',
      isVeg: true,
    ),
    MenuItem(
      id: 'v5',
      name: 'Veg Wrap',
      category: 'Veg',
      imageUrl: 'https://images.unsplash.com/photo-1626700051175-6818013e1d4f?w=400&h=400&fit=crop',
      quantity: '1 piece',
      currentPrice: 10,
      originalPrice: 12,
      rating: 4.4,
      description: 'Fresh tortilla wrap filled with grilled vegetables, hummus, and fresh herbs. A healthy and satisfying vegetarian option.',
      isVeg: true,
    ),
    MenuItem(
      id: 'v6',
      name: 'Paneer Tikka',
      category: 'Veg',
      imageUrl: 'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=400&h=400&fit=crop',
      quantity: '1 serving',
      currentPrice: 15,
      originalPrice: 18,
      rating: 4.7,
      description: 'Marinated cottage cheese cubes grilled to perfection with bell peppers and onions. Served with mint chutney.',
      isVeg: true,
    ),
  ];

  // Salad Items
  static final List<MenuItem> salads = [
    MenuItem(
      id: 's1',
      name: 'Caesar Salad',
      category: 'Salads',
      imageUrl: 'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=400&h=400&fit=crop',
      quantity: '1 serving',
      currentPrice: 12,
      originalPrice: 15,
      rating: 4.6,
      description: 'Fresh crisp romaine lettuce with homemade Caesar dressing, parmesan cheese, croutons, and grilled chicken. A classic favorite.',
      isNonVeg: true,
    ),
    MenuItem(
      id: 's2',
      name: 'Greek Salad',
      category: 'Salads',
      imageUrl: 'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=400&h=400&fit=crop',
      quantity: '1 serving',
      currentPrice: 11,
      originalPrice: 14,
      rating: 4.5,
      description: 'Fresh tomatoes, cucumbers, red onions, olives, and feta cheese with Greek dressing. A Mediterranean classic.',
      isVeg: true,
    ),
    MenuItem(
      id: 's3',
      name: 'Quinoa Salad',
      category: 'Salads',
      imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400&h=400&fit=crop',
      quantity: '1 serving',
      currentPrice: 13,
      originalPrice: 16,
      rating: 4.7,
      description: 'Nutritious quinoa mixed with fresh vegetables, herbs, and lemon vinaigrette. A healthy and satisfying option.',
      isVeg: true,
    ),
    MenuItem(
      id: 's4',
      name: 'Garden Salad',
      category: 'Salads',
      imageUrl: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400&h=400&fit=crop',
      quantity: '1 serving',
      currentPrice: 10,
      originalPrice: 13,
      rating: 4.5,
      description: 'Fresh mixed greens with seasonal vegetables, cherry tomatoes, cucumbers, and your choice of dressing. Light and refreshing.',
      isVeg: true,
    ),
    MenuItem(
      id: 's5',
      name: 'Fresh Fruit Salad',
      category: 'Salads',
      imageUrl: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400&h=400&fit=crop',
      quantity: '1 serving',
      currentPrice: 9,
      originalPrice: 12,
      rating: 4.6,
      description: 'Assortment of fresh seasonal fruits with a light honey-lime dressing. A healthy and refreshing dessert option.',
      isVeg: true,
    ),
    MenuItem(
      id: 's6',
      name: 'Caprese Salad',
      category: 'Salads',
      imageUrl: 'https://images.unsplash.com/photo-1572441713132-51c75654db73?w=400&h=400&fit=crop',
      quantity: '1 serving',
      currentPrice: 11,
      originalPrice: 14,
      rating: 4.6,
      description: 'Fresh mozzarella, ripe tomatoes, and basil drizzled with balsamic glaze. A simple yet elegant Italian classic.',
      isVeg: true,
    ),
  ];

  // Dessert Items
  static final List<MenuItem> desserts = [
    MenuItem(
      id: 'd1',
      name: 'Chocolate Cake',
      category: 'Desserts',
      imageUrl: 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=400&h=400&fit=crop',
      quantity: '1 slice',
      currentPrice: 8,
      originalPrice: 10,
      rating: 4.8,
      description: 'Rich and moist chocolate cake with creamy frosting. A decadent treat for chocolate lovers.',
      isVeg: true,
    ),
    MenuItem(
      id: 'd2',
      name: 'Tiramisu',
      category: 'Desserts',
      imageUrl: 'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=400&h=400&fit=crop',
      quantity: '1 serving',
      currentPrice: 9,
      originalPrice: 12,
      rating: 4.9,
      description: 'Classic Italian dessert with layers of coffee-soaked ladyfingers and mascarpone cream. Topped with cocoa powder.',
      isVeg: true,
    ),
    MenuItem(
      id: 'd3',
      name: 'New York Cheesecake',
      category: 'Desserts',
      imageUrl: 'https://images.unsplash.com/photo-1524351199676-942e0d5d8ff3?w=400&h=400&fit=crop',
      quantity: '1 slice',
      currentPrice: 10,
      originalPrice: 13,
      rating: 4.7,
      description: 'Creamy and rich cheesecake with a buttery graham cracker crust. Served with berry compote.',
      isVeg: true,
    ),
    MenuItem(
      id: 'd4',
      name: 'Ice Cream Sundae',
      category: 'Desserts',
      imageUrl: 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?w=400&h=400&fit=crop',
      quantity: '1 serving',
      currentPrice: 7,
      originalPrice: 9,
      rating: 4.6,
      description: 'Vanilla ice cream topped with chocolate sauce, whipped cream, nuts, and a cherry. A classic dessert favorite.',
      isVeg: true,
    ),
    MenuItem(
      id: 'd5',
      name: 'Chocolate Brownie',
      category: 'Desserts',
      imageUrl: 'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=400&h=400&fit=crop',
      quantity: '1 piece',
      currentPrice: 6,
      originalPrice: 8,
      rating: 4.7,
      description: 'Rich and fudgy chocolate brownie served warm with vanilla ice cream. A perfect ending to any meal.',
      isVeg: true,
    ),
    MenuItem(
      id: 'd6',
      name: 'Crème Brûlée',
      category: 'Desserts',
      imageUrl: 'https://images.unsplash.com/photo-1551024506-0bccd828d307?w=400&h=400&fit=crop',
      quantity: '1 serving',
      currentPrice: 9,
      originalPrice: 11,
      rating: 4.8,
      description: 'Classic French dessert with creamy vanilla custard and caramelized sugar top. Elegant and delicious.',
      isVeg: true,
    ),
  ];

  /// Get items by category name
  static List<MenuItem> getItemsByCategory(String category) {
    switch (category) {
      case 'Main Course':
        return mainCourse;
      case 'Non-Veg':
        return nonVeg;
      case 'Veg':
        return veg;
      case 'Salads':
        return salads;
      case 'Desserts':
        return desserts;
      default:
        return [];
    }
  }

  /// Get all items
  static List<MenuItem> get allItems => [
        ...mainCourse,
        ...nonVeg,
        ...veg,
        ...salads,
        ...desserts,
      ];
}

