import 'package:mini_chat/domain/auth/entities/user_entity.dart';

class UserModel extends UserEntity {
  final String? token;

  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      token: json['token'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'token': token,
    };
  }
}
