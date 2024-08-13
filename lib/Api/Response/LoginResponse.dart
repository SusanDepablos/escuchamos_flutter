import 'dart:convert';

class LoginResponse {
  final String token;
  final int user;
  final List<int> groups;

  LoginResponse({
    required this.token,
    required this.user,
    required this.groups,
  });

  // Factory constructor para crear un LoginResponse desde un JSON
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] as String,
      user: json['user'] as int,
      groups: List<int>.from(json['groups'] as List<dynamic>),
    );
  }

  // Método para convertir un LoginResponse en JSON
  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user': user,
      'groups': groups,
    };
  }
}
