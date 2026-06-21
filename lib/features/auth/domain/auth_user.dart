class AuthUser {
  const AuthUser({
    required this.fullName,
    required this.userId,
    required this.password,
    required this.phone,
    required this.school,
    required this.grade,
  });

  final String fullName;
  final String userId;
  final String password;
  final String phone;
  final String school;
  final String grade;

  AuthUser copyWith({
    String? fullName,
    String? userId,
    String? password,
    String? phone,
    String? school,
    String? grade,
  }) {
    return AuthUser(
      fullName: fullName ?? this.fullName,
      userId: userId ?? this.userId,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      school: school ?? this.school,
      grade: grade ?? this.grade,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'fullName': fullName,
      'userId': userId,
      'password': password,
      'phone': phone,
      'school': school,
      'grade': grade,
    };
  }

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      fullName: json['fullName'] as String? ?? '',
      userId: (json['userId'] ?? json['email']) as String? ?? '',
      password: json['password'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      school: json['school'] as String? ?? '',
      grade: json['grade'] as String? ?? '',
    );
  }
}
