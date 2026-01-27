/// Admin model
class AdminModel {
  final String uid;
  final String email;
  final String? name;
  final String role; // 'admin'
  final List<String> permissions; // ['all'] or specific permissions
  final DateTime createdAt;

  AdminModel({
    required this.uid,
    required this.email,
    this.name,
    required this.role,
    this.permissions = const ['all'],
    required this.createdAt,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'role': role,
      'permissions': permissions,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory AdminModel.fromFirestore(Map<String, dynamic> data, String id) {
    return AdminModel(
      uid: id,
      email: data['email'] ?? '',
      name: data['name'],
      role: data['role'] ?? 'admin',
      permissions: (data['permissions'] as List<dynamic>?)?.cast<String>() ?? ['all'],
      createdAt: DateTime.parse(
          data['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}

