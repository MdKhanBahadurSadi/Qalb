import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/prayer_time.dart';

class PrayerCard extends StatelessWidget {
  final PrayerTime prayer;
  final bool isCurrent;

  const PrayerCard({
    super.key, 
    required this.prayer,
    this.isCurrent = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Current or Next prayer will have a different look
    final bool isSpecial = prayer.isNext || isCurrent;
    final String formattedTime = DateFormat('hh:mm a').format(prayer.time);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: isSpecial ? colorScheme.primary : colorScheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.kRadiusLg),
        boxShadow: [
          if (isSpecial)
            BoxShadow(
              color: colorScheme.primary.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
        ],
        border: Border.all(
          color: isSpecial ? Colors.transparent : colorScheme.outlineVariant,
          width: 0.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSpecial 
                  ? colorScheme.onPrimary.withValues(alpha: 0.2) 
                  : colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Text(
              prayer.icon, 
              style: const TextStyle(fontSize: 22),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  prayer.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isSpecial ? colorScheme.onPrimary : colorScheme.onSurface,
                  ),
                ),
                Text(
                  prayer.arabicName,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isSpecial 
                        ? colorScheme.onPrimary.withValues(alpha: 0.7) 
                        : colorScheme.onSurfaceVariant,
                    fontFamily: 'serif',
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formattedTime,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isSpecial ? colorScheme.onPrimary : colorScheme.primary,
                ),
              ),
              if (isCurrent)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: isSpecial ? colorScheme.onPrimary : colorScheme.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'চলমান',
                    style: TextStyle(
                      color: isSpecial ? colorScheme.primary : colorScheme.onPrimary, 
                      fontSize: 10, 
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
