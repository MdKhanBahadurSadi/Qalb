import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:qalb/features/auth/presentation/providers/auth_provider.dart';
import 'package:qalb/features/auth/presentation/providers/settings_provider.dart';
import 'package:qalb/features/onboarding/presentation/providers/theme_provider.dart';
import 'package:qalb/shared/widgets/language_selector.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    final notificationsEnabled = ref.watch(notificationsEnabledProvider);
    final prayerNotifications = ref.watch(prayerNotificationsProvider);
    final themeMode = ref.watch(themeProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('প্রোফাইল'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildProfileHeader(theme, user),
            const SizedBox(height: 24),
            _buildHealthSummaryTile(context, theme),
            const SizedBox(height: 24),
            _buildSettingsSection(context, ref, theme, notificationsEnabled, prayerNotifications, themeMode),
            const SizedBox(height: 32),
            _buildLogoutButton(context, theme, ref),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(ThemeData theme, dynamic user) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Text(
            user?.name?.isNotEmpty == true 
                ? user!.name![0].toUpperCase() 
                : (user?.email?.isNotEmpty == true ? user!.email![0].toUpperCase() : 'U'),
            style: TextStyle(
              fontSize: 40, 
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          user?.name ?? 'ব্যবহারকারীর নাম',
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          user?.email ?? 'user@example.com',
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 8),
        Text(
          'সদস্য হয়েছেন: ${user != null ? DateFormat('dd MMMM, yyyy', 'bn').format(DateTime.now()) : '---'}',
          style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _buildHealthSummaryTile(BuildContext context, ThemeData theme) {
    return Card(
      elevation: 0,
      color: theme.colorScheme.primary.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.primary.withValues(alpha: 0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'স্বাস্থ্য সারাংশ', 
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () => context.push('/health-form'),
                  child: const Text('আপডেট করুন'),
                ),
              ],
            ),
            Divider(color: theme.colorScheme.outlineVariant),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem(theme, 'BMI', '২২.৫', 'স্বাভাবিক', Colors.green),
                _buildSummaryItem(theme, 'রিস্ক স্কোর', '১৫%', 'কম', Colors.green),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(ThemeData theme, String label, String value, String status, Color statusColor) {
    return Column(
      children: [
        Text(
          label, 
          style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
        Text(
          value, 
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            status, 
            style: TextStyle(fontSize: 10, color: statusColor, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection(
    BuildContext context, 
    WidgetRef ref, 
    ThemeData theme,
    bool notificationsEnabled, 
    bool prayerNotifications, 
    ThemeMode themeMode,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'সেটিংস', 
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildListTile(
          context,
          theme,
          icon: Icons.language,
          title: 'ভাষা',
          trailing: Text('বাংলা', style: theme.textTheme.bodyMedium),
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => const LanguageSelector(),
            );
          },
        ),
        _buildListTile(
          context,
          theme,
          icon: themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode,
          title: 'থিম',
          trailing: Text(
            themeMode == ThemeMode.dark ? 'ডার্ক' : (themeMode == ThemeMode.light ? 'লাইট' : 'সিস্টেম'),
            style: theme.textTheme.bodyMedium,
          ),
          onTap: () {
             // Cycle through themes: Light -> Dark -> System
             if (themeMode == ThemeMode.light) {
               ref.read(themeProvider.notifier).setTheme(ThemeMode.dark);
             } else if (themeMode == ThemeMode.dark) {
               ref.read(themeProvider.notifier).setTheme(ThemeMode.system);
             } else {
               ref.read(themeProvider.notifier).setTheme(ThemeMode.light);
             }
          },
        ),
        SwitchListTile(
          secondary: Icon(Icons.notifications_none, color: theme.colorScheme.primary),
          title: Text('নোটিফিকেশন', style: theme.textTheme.bodyLarge),
          value: notificationsEnabled,
          activeColor: theme.colorScheme.primary,
          onChanged: (val) => ref.read(notificationsEnabledProvider.notifier).toggle(),
        ),
        SwitchListTile(
          secondary: Icon(Icons.mosque_outlined, color: theme.colorScheme.primary),
          title: Text('নামাজের নোটিফিকেশন', style: theme.textTheme.bodyLarge),
          value: prayerNotifications,
          activeColor: theme.colorScheme.primary,
          onChanged: (val) => ref.read(prayerNotificationsProvider.notifier).toggle(),
        ),
        _buildListTile(
          context,
          theme,
          icon: Icons.bar_chart,
          title: 'আমার রিপোর্ট',
          onTap: () => context.push('/report'),
        ),
        _buildListTile(
          context,
          theme,
          icon: Icons.privacy_tip_outlined,
          title: 'গোপনীয়তা নীতি',
          onTap: () {},
        ),
        _buildListTile(
          context,
          theme,
          icon: Icons.info_outline,
          title: 'অ্যাপ সম্পর্কে',
          trailing: Text('v1.0.0', style: theme.textTheme.bodySmall),
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildListTile(
    BuildContext context, 
    ThemeData theme,
    {required IconData icon, required String title, Widget? trailing, required VoidCallback onTap}
  ) {
    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(title, style: theme.textTheme.bodyLarge),
      trailing: trailing ?? Icon(Icons.arrow_forward_ios, size: 14, color: theme.colorScheme.onSurfaceVariant),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton(BuildContext context, ThemeData theme, WidgetRef ref) {
    return OutlinedButton.icon(
      onPressed: () => _showLogoutDialog(context, theme, ref),
      icon: Icon(Icons.logout, color: theme.colorScheme.error),
      label: Text('লগআউট', style: TextStyle(color: theme.colorScheme.error)),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        side: BorderSide(color: theme.colorScheme.error),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, ThemeData theme, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        title: Text('লগআউট', style: theme.textTheme.titleLarge),
        content: Text('আপনি কি নিশ্চিত যে লগআউট করতে চান?', style: theme.textTheme.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('না', style: TextStyle(color: theme.colorScheme.primary)),
          ),
          TextButton(
            onPressed: () {
              ref.read(authNotifierProvider.notifier).signOut();
              Navigator.pop(context);
            },
            child: Text('হ্যাঁ', style: TextStyle(color: theme.colorScheme.error)),
          ),
        ],
      ),
    );
  }
}
