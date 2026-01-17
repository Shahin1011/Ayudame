import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_colors.dart';
import 'services/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize GetX dependencies
  _initDependencies();

  if (kDebugMode) {
    final token = await StorageService.getToken();
    debugPrint('FULL TOKEN: $token');
  }

  runApp(const MyApp());
}

/// Initialize all GetX controllers and dependencies
void _initDependencies() {
  // Auth Controller
  // Get.lazyPut<AuthController>(() => AuthController(), fenix: true);

  // TODO: Add more controllers here as you create them
  // User Controllers
  // Get.lazyPut<UserHomeController>(() => UserHomeController(), fenix: true);

  // Provider Controllers
  // Get.lazyPut<ProviderHomeController>(() => ProviderHomeController(), fenix: true);

  // Business Controllers
  // Get.lazyPut<BusinessHomeController>(() => BusinessHomeController(), fenix: true);

  // Event Manager Controllers
  // Get.lazyPut<EventManagerHomeController>(() => EventManagerHomeController(), fenix: true);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'MiddleWare App',
          debugShowCheckedModeBanner: false,

          // Initial route
          initialRoute: AppRoutes.splash,

          // GetX routes
          getPages: AppRoutes.pages,

          // Default transitions
          defaultTransition: Transition.rightToLeft,
          transitionDuration: const Duration(milliseconds: 300),

          // Theme
          theme: ThemeData(
            fontFamily: GoogleFonts.inter().fontFamily,
            textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
            primaryColor: AppColors.primary,
            scaffoldBackgroundColor: AppColors.scaffold,
            useMaterial3: true,

            // AppBar Theme
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
            ),

            // Card Theme
            cardTheme: const CardThemeData(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),

            // Input Decoration Theme
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
            ),

            // Elevated Button Theme
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            // Text Button Theme
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),

            // Color Scheme
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primary,
              primary: AppColors.primary,
              secondary: AppColors.secondary,
              error: AppColors.error,
              surface: AppColors.surface,
            ),
          ),

          // Locale settings
          locale: const Locale('en', 'US'),
          fallbackLocale: const Locale('en', 'US'),
        );
      },
    );
  }
}
