import 'package:flutter/material.dart';

import '../models/ingredient.dart';
import '../theme/app_colors.dart';

class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.days,
    this.status,
  });

  final int days;
  final ExpiryStatus? status;

  @override
  Widget build(BuildContext context) {
    final currentStatus = status ?? _statusFromDays(days);
    final label = switch (currentStatus) {
      ExpiryStatus.expired => 'Expired',
      ExpiryStatus.today => 'Today',
      ExpiryStatus.soon => '${days}d',
      ExpiryStatus.fresh => '${days}d',
    };

    final color = switch (currentStatus) {
      ExpiryStatus.expired => AppColors.danger,
      ExpiryStatus.today => AppColors.danger,
      ExpiryStatus.soon => AppColors.warning,
      ExpiryStatus.fresh => AppColors.forestGreen,
    };

    return Container(
      width: currentStatus == ExpiryStatus.expired ? 78 : 58,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.w800),
      ),
    );
  }

  ExpiryStatus _statusFromDays(int days) {
    if (days < 0) {
      return ExpiryStatus.expired;
    }
    if (days == 0) {
      return ExpiryStatus.today;
    }
    if (days <= 3) {
      return ExpiryStatus.soon;
    }
    return ExpiryStatus.fresh;
  }
}
