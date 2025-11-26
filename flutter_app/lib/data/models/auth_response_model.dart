import '../../domain/entities/auth_response_entity.dart';
import 'user_model.dart';

class AuthResponseModel extends AuthResponseEntity {
  const AuthResponseModel({
    required super.accessToken,
    required super.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json['access_token'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'user': (user as UserModel).toJson(),
    };
  }
}
