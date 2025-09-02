import 'package:flutter/material.dart';

import '../../domain/entities/subscription_info.dart';

class SubscriptionCard extends StatelessWidget {
  const SubscriptionCard({
    Key? key,
    required this.subscription,
    this.isLoading = false,
    this.onUpgrade,
    this.onManage,
  }) : super(key: key);

  final SubscriptionInfo subscription;
  final bool isLoading;
  final VoidCallback? onUpgrade;
  final VoidCallback? onManage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (isLoading) {
      return Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Subscription',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Center(
                child: CircularProgressIndicator(),
              ),
            ],
          ),
        ),
      );
    }
    
    return Card(
      elevation: 2,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: _getSubscriptionGradient(),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Subscription',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  _buildSubscriptionBadge(context),
                ],
              ),
              const SizedBox(height: 16),
              _buildSubscriptionDetails(context),
              const SizedBox(height: 16),
              _buildSubscriptionActions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubscriptionBadge(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
        ),
      ),
      child: Text(
        subscription.planName.toUpperCase(),
        style: theme.textTheme.bodySmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSubscriptionDetails(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (subscription.isActive) ..[
          _buildDetailRow(
            context,
            icon: Icons.calendar_today,
            label: 'Expires',
            value: _formatDate(subscription.expiresAt!),
          ),
          const SizedBox(height: 8),
          _buildDetailRow(
            context,
            icon: Icons.autorenew,
            label: 'Auto Renewal',
            value: subscription.autoRenewal ? 'Enabled' : 'Disabled',
          ),
        ] else ..[
          _buildDetailRow(
            context,
            icon: Icons.info_outline,
            label: 'Status',
            value: 'Inactive',
          ),
        ],
        const SizedBox(height: 8),
        _buildDetailRow(
          context,
          icon: Icons.star,
          label: 'Features',
          value: '${subscription.features.length} included',
        ),
      ],
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.white.withOpacity(0.8),
        ),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.white.withOpacity(0.8),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSubscriptionActions(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        if (!subscription.isActive || subscription.planName.toLowerCase() == 'free') ..[
          Expanded(
            child: ElevatedButton(
              onPressed: onUpgrade,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: _getPrimaryColor(),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                subscription.isActive ? 'Upgrade' : 'Subscribe',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ] else ..[
          Expanded(
            child: OutlinedButton(
              onPressed: onManage,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Manage Subscription',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  LinearGradient _getSubscriptionGradient() {
    switch (subscription.planName.toLowerCase()) {
      case 'premium':
        return const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'pro':
        return const LinearGradient(
          colors: [Color(0xFF059669), Color(0xFF10B981)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'enterprise':
        return const LinearGradient(
          colors: [Color(0xFF1F2937), Color(0xFF374151)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default: // free
        return const LinearGradient(
          colors: [Color(0xFF6B7280), Color(0xFF9CA3AF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  Color _getPrimaryColor() {
    switch (subscription.planName.toLowerCase()) {
      case 'premium':
        return const Color(0xFF6366F1);
      case 'pro':
        return const Color(0xFF059669);
      case 'enterprise':
        return const Color(0xFF1F2937);
      default:
        return const Color(0xFF6B7280);
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} days';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes';
    } else {
      return 'Expired';
    }
  }
}