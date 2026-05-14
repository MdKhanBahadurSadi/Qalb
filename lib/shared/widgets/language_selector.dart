import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qalb/features/auth/presentation/providers/settings_provider.dart';

class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(languageProvider);
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'ভাষা নির্বাচন করুন',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildLanguageTile(context, theme, ref, 'বাংলা', 'bn', currentLocale),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildLanguageTile(
    BuildContext context, 
    ThemeData theme,
    WidgetRef ref, 
    String label, 
    String code, 
    Locale current
  ) {
    final isSelected = current.languageCode == code;
    return ListTile(
      title: Text(
        label, 
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface,
        ),
      ),
      trailing: isSelected 
          ? Icon(Icons.check_circle, color: theme.colorScheme.primary) 
          : null,
      onTap: () {
        context.setLocale(Locale(code));
        ref.read(languageProvider.notifier).setLanguage(code);
        Navigator.pop(context);
      },
    );
  }
}
