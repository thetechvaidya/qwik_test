import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';
import 'user_model.dart';
import 'auth_token_model.dart';

part 'auth_response_model.g.dart';

@JsonSerializable()
class AuthResponseModel extends Equatable {
  const AuthResponseModel({
    required this.user,
    required this.token,
    this.message,
  });

  final UserModel user;
  final AuthTokenModel token;
  final String? message;

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    // Handle different response structures from the API
    if (json.containsKey('data')) {
      final data = json['data'] as Map<String, dynamic>;
      return AuthResponseModel(
        user: UserModel.fromJson(data['user'] as Map<String, dynamic>),
        token: AuthTokenModel.fromJson(data['token'] as Map<String, dynamic>),
        message: json['message'] as String?,
      );
    } else {
      return _$AuthResponseModelFromJson(json);
    }
  }

  Map<String, dynamic> toJson() => _$AuthResponseModelToJson(this);

  @override
  List<Object?> get props => [user, token, message];

  @override
  String toString() => 'AuthResponseModel(user: $user, token: ${token.toString()}, message: $message)';
}