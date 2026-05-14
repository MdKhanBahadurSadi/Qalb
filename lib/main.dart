import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/constants/app_constants.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/onboarding/presentation/providers/theme_provider.dart';
import 'shared/services/notification_service.dart';
import 'firebase_options.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    // Firebase initialization
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: true);
    } catch (e) {
      debugPrint('Firebase initialization failed: $e');
    }

    // Hive init
    await Hive.initFlutter();
    await _openHiveBoxes();

    // Localization
    await EasyLocalization.ensureInitialized();

    // Notifications
    await NotificationService.initialize();

    // Portrait only
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    runApp(
      EasyLocalization(
        supportedLocales: const [Locale('bn')],
        path: 'assets/translations',
        fallbackLocale: const Locale('bn'),
        child: const ProviderScope(child: QalbApp()),
      ),
    );
  } catch (e, stackTrace) {
    debugPrint('Fatal error during startup: $e');
    debugPrint('Stacktrace: $stackTrace');
    // Even if something fails, try to run a simple error app
    runApp(MaterialApp(home: Scaffold(body: Center(child: Text('Error starting app: $e')))));
  }
}

Future<void> _openHiveBoxes() async {
  try {
    await Hive.openBox(AppConstants.hiveSettingsBox);
    await Hive.openBox(AppConstants.hiveHealthBox);
    await Hive.openBox(AppConstants.hiveSmokingBox);
    await Hive.openBox(AppConstants.hiveDhikrBox);
  } catch (e) {
    debugPrint('Hive Box Error: $e');
  }
}

class QalbApp extends ConsumerWidget {
  const QalbApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeProvider);
    
    return MaterialApp.router(
      title: 'Qalb',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
    );
  }
}
