import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.email,
    required this.name,
    this.avatar,
    this.phone,
    this.isEmailVerified = false,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String email;
  final String name;
  final String? avatar;
  final String? phone;
  final bool isEmailVerified;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        avatar,
        phone,
        isEmailVerified,
        createdAt,
        updatedAt,
      ];

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? avatar,
    String? phone,
    bool? isEmailVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      phone: phone ?? this.phone,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, email: $email, name: $name, avatar: $avatar, phone: $phone, isEmailVerified: $isEmailVerified, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}