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

    final textColor = switch (currentStatus) {
      ExpiryStatus.expired => const Color(0xFF3A0B08),
      ExpiryStatus.today => const Color(0xFF3A0B08),
      ExpiryStatus.soon => const Color(0xFF4A3300),
      ExpiryStatus.fresh => AppColors.forestGreen,
    };

    final backgroundColor = switch (currentStatus) {
      ExpiryStatus.expired => const Color(0xFFF7C9C5),
      ExpiryStatus.today => const Color(0xFFF7C9C5),
      ExpiryStatus.soon => const Color(0xFFFFF3D8),
      ExpiryStatus.fresh => AppColors.mintGreen,
    };

    return Container(
      width: currentStatus == ExpiryStatus.expired ? 78 : 58,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: textColor, width: 1.4),
      ),
      child: Text(
        label,
        style: TextStyle(color: textColor, fontWeight: FontWeight.w900),
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
