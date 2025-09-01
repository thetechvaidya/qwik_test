import 'package:equatable/equatable.dart';
import '../../../../core/utils/auth_utils.dart';

class AuthToken extends Equatable {
  const AuthToken({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
    this.issuedAt,
  });

  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int expiresIn; // in seconds
  final DateTime? issuedAt;

  @override
  List<Object?> get props => [
        accessToken,
        refreshToken,
        tokenType,
        expiresIn,
        issuedAt,
      ];

  /// Check if the access token is expired
  bool get isExpired {
    return AuthUtils.isTokenExpired(accessToken);
  }

  /// Check if the token will expire soon (within 5 minutes)
  bool get willExpireSoon {
    return AuthUtils.needsRefresh(accessToken, threshold: const Duration(minutes: 5));
  }

  AuthToken copyWith({
    String? accessToken,
    String? refreshToken,
    String? tokenType,
    int? expiresIn,
    DateTime? issuedAt,
  }) {
    return AuthToken(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      tokenType: tokenType ?? this.tokenType,
      expiresIn: expiresIn ?? this.expiresIn,
      issuedAt: issuedAt ?? this.issuedAt,
    );
  }

  @override
  String toString() {
    return 'AuthToken(accessToken: ${accessToken.substring(0, 10)}..., refreshToken: ${refreshToken.substring(0, 10)}..., tokenType: $tokenType, expiresIn: $expiresIn, issuedAt: $issuedAt)';
  }
}