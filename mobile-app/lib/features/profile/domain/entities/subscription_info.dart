import 'package:equatable/equatable.dart';

enum SubscriptionStatus {
  active,
  expired,
  cancelled,
  pending,
  trial,
}

enum SubscriptionPlan {
  free,
  basic,
  premium,
  enterprise,
}

class SubscriptionInfo extends Equatable {
  const SubscriptionInfo({
    required this.status,
    required this.plan,
    this.expiresAt,
    this.autoRenew = false,
    this.trialEndsAt,
    this.features = const [],
    this.maxExams,
    this.maxOfflineDownloads,
  });

  final SubscriptionStatus status;
  final SubscriptionPlan plan;
  final DateTime? expiresAt;
  final bool autoRenew;
  final DateTime? trialEndsAt;
  final List<String> features;
  final int? maxExams;
  final int? maxOfflineDownloads;

  @override
  List<Object?> get props => [
        status,
        plan,
        expiresAt,
        autoRenew,
        trialEndsAt,
        features,
        maxExams,
        maxOfflineDownloads,
      ];

  /// Checks if subscription is currently active
  bool isActive() {
    if (status != SubscriptionStatus.active && status != SubscriptionStatus.trial) {
      return false;
    }
    
    final now = DateTime.now();
    if (expiresAt != null && now.isAfter(expiresAt!)) {
      return false;
    }
    
    if (status == SubscriptionStatus.trial && trialEndsAt != null && now.isAfter(trialEndsAt!)) {
      return false;
    }
    
    return true;
  }

  /// Checks if user has premium features
  bool isPremium() {
    return isActive() && (plan == SubscriptionPlan.premium || plan == SubscriptionPlan.enterprise);
  }

  /// Checks if subscription is in trial period
  bool isTrial() {
    return status == SubscriptionStatus.trial && isActive();
  }

  /// Gets days until expiry
  int getDaysUntilExpiry() {
    if (expiresAt == null) return -1;
    
    final now = DateTime.now();
    final difference = expiresAt!.difference(now);
    return difference.inDays;
  }

  /// Checks if subscription is expiring soon (within 7 days)
  bool isExpiringSoon() {
    final daysUntilExpiry = getDaysUntilExpiry();
    return daysUntilExpiry >= 0 && daysUntilExpiry <= 7;
  }

  /// Gets subscription display name
  String getDisplayName() {
    switch (plan) {
      case SubscriptionPlan.free:
        return 'Free';
      case SubscriptionPlan.basic:
        return 'Basic';
      case SubscriptionPlan.premium:
        return 'Premium';
      case SubscriptionPlan.enterprise:
        return 'Enterprise';
    }
  }

  /// Gets subscription status display text
  String getStatusDisplayText() {
    switch (status) {
      case SubscriptionStatus.active:
        return 'Active';
      case SubscriptionStatus.expired:
        return 'Expired';
      case SubscriptionStatus.cancelled:
        return 'Cancelled';
      case SubscriptionStatus.pending:
        return 'Pending';
      case SubscriptionStatus.trial:
        return 'Trial';
    }
  }

  /// Checks if user has access to a specific feature
  bool hasFeature(String feature) {
    return features.contains(feature);
  }

  SubscriptionInfo copyWith({
    SubscriptionStatus? status,
    SubscriptionPlan? plan,
    DateTime? expiresAt,
    bool? autoRenew,
    DateTime? trialEndsAt,
    List<String>? features,
    int? maxExams,
    int? maxOfflineDownloads,
  }) {
    return SubscriptionInfo(
      status: status ?? this.status,
      plan: plan ?? this.plan,
      expiresAt: expiresAt ?? this.expiresAt,
      autoRenew: autoRenew ?? this.autoRenew,
      trialEndsAt: trialEndsAt ?? this.trialEndsAt,
      features: features ?? this.features,
      maxExams: maxExams ?? this.maxExams,
      maxOfflineDownloads: maxOfflineDownloads ?? this.maxOfflineDownloads,
    );
  }

  @override
  String toString() {
    return 'SubscriptionInfo(status: $status, plan: $plan, expiresAt: $expiresAt, autoRenew: $autoRenew, trialEndsAt: $trialEndsAt, features: $features, maxExams: $maxExams, maxOfflineDownloads: $maxOfflineDownloads)';
  }
}