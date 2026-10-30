class UserModel {
  final String id;
  final String name;
  final String email;
  final String role; // 'admin' | 'faculty' | 'student'
  final String avatar;
  final String phone;
  final bool isActive;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.avatar = '',
    this.phone = '',
    this.isActive = true,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'student',
      avatar: json['avatar'] ??
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=250&q=80',
      phone: json['phone'] ?? '',
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'avatar': avatar,
      'phone': phone,
      'isActive': isActive,
    };
  }
}

