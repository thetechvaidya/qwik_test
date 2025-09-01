import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/auth_token.dart';

part 'auth_token_model.g.dart';

@JsonSerializable()
class AuthTokenModel extends AuthToken {
  const AuthTokenModel({
    required super.accessToken,
    required super.refreshToken,
    required super.tokenType,
    required super.expiresIn,
    super.issuedAt,
  });

  factory AuthTokenModel.fromJson(Map<String, dynamic> json) => _$AuthTokenModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthTokenModelToJson(this);

  factory AuthTokenModel.fromEntity(AuthToken token) {
    return AuthTokenModel(
      accessToken: token.accessToken,
      refreshToken: token.refreshToken,
      tokenType: token.tokenType,
      expiresIn: token.expiresIn,
      issuedAt: token.issuedAt,
    );
  }

  AuthToken toEntity() {
    return AuthToken(
      accessToken: accessToken,
      refreshToken: refreshToken,
      tokenType: tokenType,
      expiresIn: expiresIn,
      issuedAt: issuedAt,
    );
  }

  /// Create token model with current timestamp as issuedAt
  factory AuthTokenModel.withCurrentTimestamp({
    required String accessToken,
    required String refreshToken,
    required String tokenType,
    required int expiresIn,
  }) {
    return AuthTokenModel(
      accessToken: accessToken,
      refreshToken: refreshToken,
      tokenType: tokenType,
      expiresIn: expiresIn,
      issuedAt: DateTime.now(),
    );
  }
}