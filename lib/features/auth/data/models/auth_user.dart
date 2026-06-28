class AuthUser {
  const AuthUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.sport,
    required this.age,
    required this.weight,
    required this.height,
  });

  final String id;
  final String name;
  final String email;
  final String role;
  final String sport;
  final int age;
  final double weight;
  final double height;

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      role: (json['role'] ?? 'athlete').toString(),
      sport: (json['sport'] ?? '').toString(),
      age: _toInt(json['age']),
      weight: _toDouble(json['weight']),
      height: _toDouble(json['height']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'sport': sport,
      'age': age,
      'weight': weight,
      'height': height,
    };
  }

  static int _toInt(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double _toDouble(Object? value) {
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }
}
