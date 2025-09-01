import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'register_request_model.g.dart';

@JsonSerializable()
class RegisterRequestModel extends Equatable {
  const RegisterRequestModel({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    this.deviceName,
  });

  final String name;
  final String email;
  final String password;
  @JsonKey(name: 'password_confirmation')
  final String passwordConfirmation;
  @JsonKey(name: 'device_name')
  final String? deviceName;

  factory RegisterRequestModel.fromJson(Map<String, dynamic> json) => _$RegisterRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterRequestModelToJson(this);

  @override
  List<Object?> get props => [name, email, password, passwordConfirmation, deviceName];

  @override
  String toString() => 'RegisterRequestModel(name: $name, email: $email, password: [HIDDEN], passwordConfirmation: [HIDDEN], deviceName: $deviceName)';
}