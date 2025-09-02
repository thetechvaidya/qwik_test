import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/subscription_info.dart';

part 'subscription_info_model.g.dart';

@JsonSerializable()
class SubscriptionInfoModel extends SubscriptionInfo {
  const SubscriptionInfoModel({
    required super.status,
    required super.plan,
    super.expiresAt,
    super.autoRenew = false,
    super.trialEndsAt,
    super.features = const [],
    super.maxExams,
    super.maxOfflineDownloads,
  });

  factory SubscriptionInfoModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$SubscriptionInfoModelFromJson(json);
    } catch (e) {
      // Provide fallback values if JSON parsing fails
      return const SubscriptionInfoModel(
        status: SubscriptionStatus.expired,
        plan: SubscriptionPlan.free,
      );
    }
  }

  Map<String, dynamic> toJson() => _$SubscriptionInfoModelToJson(this);

  factory SubscriptionInfoModel.fromEntity(SubscriptionInfo subscription) {
    return SubscriptionInfoModel(
      status: subscription.status,
      plan: subscription.plan,
      expiresAt: subscription.expiresAt,
      autoRenew: subscription.autoRenew,
      trialEndsAt: subscription.trialEndsAt,
      features: subscription.features,
      maxExams: subscription.maxExams,
      maxOfflineDownloads: subscription.maxOfflineDownloads,
    );
  }

  SubscriptionInfo toEntity() {
    return SubscriptionInfo(
      status: status,
      plan: plan,
      expiresAt: expiresAt,
      autoRenew: autoRenew,
      trialEndsAt: trialEndsAt,
      features: features,
      maxExams: maxExams,
      maxOfflineDownloads: maxOfflineDownloads,
    );
  }

  /// Create subscription model from string values (for API compatibility)
  factory SubscriptionInfoModel.fromStrings({
    required String status,
    required String plan,
    String? expiresAt,
    bool autoRenew = false,
    String? trialEndsAt,
    List<String> features = const [],
    int? maxExams,
    int? maxOfflineDownloads,
  }) {
    return SubscriptionInfoModel(
      status: _parseSubscriptionStatus(status),
      plan: _parseSubscriptionPlan(plan),
      expiresAt: expiresAt != null ? DateTime.tryParse(expiresAt) : null,
      autoRenew: autoRenew,
      trialEndsAt: trialEndsAt != null ? DateTime.tryParse(trialEndsAt) : null,
      features: features,
      maxExams: maxExams,
      maxOfflineDownloads: maxOfflineDownloads,
    );
  }

  /// Parse subscription status from string
  static SubscriptionStatus _parseSubscriptionStatus(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return SubscriptionStatus.active;
      case 'expired':
        return SubscriptionStatus.expired;
      case 'cancelled':
        return SubscriptionStatus.cancelled;
      case 'pending':
        return SubscriptionStatus.pending;
      case 'trial':
        return SubscriptionStatus.trial;
      default:
        return SubscriptionStatus.expired;
    }
  }

  /// Parse subscription plan from string
  static SubscriptionPlan _parseSubscriptionPlan(String plan) {
    switch (plan.toLowerCase()) {
      case 'free':
        return SubscriptionPlan.free;
      case 'basic':
        return SubscriptionPlan.basic;
      case 'premium':
        return SubscriptionPlan.premium;
      case 'enterprise':
        return SubscriptionPlan.enterprise;
      default:
        return SubscriptionPlan.free;
    }
  }

  /// Create a free subscription model
  factory SubscriptionInfoModel.free() {
    return const SubscriptionInfoModel(
      status: SubscriptionStatus.active,
      plan: SubscriptionPlan.free,
      features: ['basic_exams', 'limited_offline'],
      maxExams: 5,
      maxOfflineDownloads: 2,
    );
  }

  /// Create a trial subscription model
  factory SubscriptionInfoModel.trial({DateTime? trialEndsAt}) {
    return SubscriptionInfoModel(
      status: SubscriptionStatus.trial,
      plan: SubscriptionPlan.premium,
      trialEndsAt: trialEndsAt ?? DateTime.now().add(const Duration(days: 7)),
      features: ['unlimited_exams', 'offline_mode', 'analytics', 'certificates'],
      maxExams: null, // unlimited
      maxOfflineDownloads: 50,
    );
  }
}