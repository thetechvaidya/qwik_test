// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionInfoModel _$SubscriptionInfoModelFromJson(
        Map<String, dynamic> json) =>
    SubscriptionInfoModel(
      status: $enumDecode(_$SubscriptionStatusEnumMap, json['status']),
      plan: $enumDecode(_$SubscriptionPlanEnumMap, json['plan']),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      autoRenew: json['autoRenew'] as bool? ?? false,
      trialEndsAt: json['trialEndsAt'] == null
          ? null
          : DateTime.parse(json['trialEndsAt'] as String),
      features: (json['features'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      maxExams: (json['maxExams'] as num?)?.toInt(),
      maxOfflineDownloads: (json['maxOfflineDownloads'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SubscriptionInfoModelToJson(
        SubscriptionInfoModel instance) =>
    <String, dynamic>{
      'status': _$SubscriptionStatusEnumMap[instance.status]!,
      'plan': _$SubscriptionPlanEnumMap[instance.plan]!,
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'autoRenew': instance.autoRenew,
      'trialEndsAt': instance.trialEndsAt?.toIso8601String(),
      'features': instance.features,
      'maxExams': instance.maxExams,
      'maxOfflineDownloads': instance.maxOfflineDownloads,
    };

const _$SubscriptionStatusEnumMap = {
  SubscriptionStatus.active: 'active',
  SubscriptionStatus.expired: 'expired',
  SubscriptionStatus.cancelled: 'cancelled',
  SubscriptionStatus.pending: 'pending',
  SubscriptionStatus.trial: 'trial',
};

const _$SubscriptionPlanEnumMap = {
  SubscriptionPlan.free: 'free',
  SubscriptionPlan.basic: 'basic',
  SubscriptionPlan.premium: 'premium',
  SubscriptionPlan.enterprise: 'enterprise',
};
