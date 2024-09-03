import 'dart:convert';

class LoginResponse {
  final String token;
  final String session_key;
  final int user;
  final List<int> groups;

  LoginResponse({
    required this.token,
    required this.session_key,
    required this.user,
    required this.groups,
  });

  // Factory constructor para crear un LoginResponse desde un JSON
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] as String,
      session_key: json['session_key'] as String,
      user: json['user'] as int,
      groups: List<int>.from(json['groups'] as List<dynamic>),
    );
  }

  // Método para convertir un LoginResponse en JSON
  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'session_key': session_key,
      'user': user,
      'groups': groups,
    };
  }
}
