import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../features/smoking/presentation/providers/smoking_provider.dart';

// Provide the current active tab index to children widgets
final activeTabProvider = StateProvider<int>((ref) => 0);

class ScaffoldWithNavBar extends ConsumerWidget {
  const ScaffoldWithNavBar({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentIndex = navigationShell.currentIndex;
    final smokingProfile = ref.watch(smokingProvider);
    
    // Determine if we should show a Floating Action Button at the shell level.
    Widget? fab;
    if (currentIndex == 3 && smokingProfile.isInRecovery) {
      fab = FloatingActionButton.extended(
        key: const ValueKey('smoking_fab'),
        onPressed: () => context.push('/smoking/craving-log'),
        icon: const Icon(Icons.warning_amber_rounded),
        label: const Text('ক্র্যাভিং হচ্ছে? সাহায্য নিন'),
        backgroundColor: theme.colorScheme.secondary,
        foregroundColor: theme.colorScheme.onSecondary,
      );
    }

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        backgroundColor: theme.colorScheme.surface,
        indicatorColor: theme.colorScheme.primaryContainer,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: theme.colorScheme.onSurfaceVariant),
            selectedIcon: Icon(Icons.home, color: theme.colorScheme.primary),
            label: 'nav.home'.tr(),
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline, color: theme.colorScheme.onSurfaceVariant),
            selectedIcon: Icon(Icons.favorite, color: theme.colorScheme.primary),
            label: 'nav.predict'.tr(),
          ),
          NavigationDestination(
            icon: Icon(Icons.mosque_outlined, color: theme.colorScheme.onSurfaceVariant),
            selectedIcon: Icon(Icons.mosque, color: theme.colorScheme.primary),
            label: 'nav.spiritual'.tr(),
          ),
          NavigationDestination(
            icon: Icon(Icons.smoke_free_outlined, color: theme.colorScheme.onSurfaceVariant),
            selectedIcon: Icon(Icons.smoke_free, color: theme.colorScheme.primary),
            label: 'nav.smoking'.tr(),
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline, color: theme.colorScheme.onSurfaceVariant),
            selectedIcon: Icon(Icons.person, color: theme.colorScheme.primary),
            label: 'nav.profile'.tr(),
          ),
        ],
        onDestinationSelected: (index) {
          // Update the provider so children can react to tab visibility
          ref.read(activeTabProvider.notifier).state = index;
          
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
      ),
      floatingActionButton: fab,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
