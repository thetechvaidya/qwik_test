import 'package:json_annotation/json_annotation.dart';
import 'package:equatable/equatable.dart';

part 'login_request_model.g.dart';

@JsonSerializable()
class LoginRequestModel extends Equatable {
  const LoginRequestModel({
    required this.email,
    required this.password,
    this.deviceName,
  });

  final String email;
  final String password;
  @JsonKey(name: 'device_name')
  final String? deviceName;

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) => _$LoginRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestModelToJson(this);

  @override
  List<Object?> get props => [email, password, deviceName];

  @override
  String toString() => 'LoginRequestModel(email: $email, password: [HIDDEN], deviceName: $deviceName)';
}