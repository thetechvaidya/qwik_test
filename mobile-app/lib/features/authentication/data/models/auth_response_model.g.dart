// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthResponseModel _$AuthResponseModelFromJson(Map<String, dynamic> json) =>
    AuthResponseModel(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      token: AuthTokenModel.fromJson(json['token'] as Map<String, dynamic>),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$AuthResponseModelToJson(AuthResponseModel instance) =>
    <String, dynamic>{
      'user': instance.user,
      'token': instance.token,
      'message': instance.message,
    };
