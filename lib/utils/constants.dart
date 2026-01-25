import 'package:flutter/material.dart';

/// App-wide constants
class AppConstants {

  // Base Url
  static const String BASE_URL = "https://cal-intensity-achieved-neo.trycloudflare.com";

  // App Info
  static const String appName = 'MiddleWare';
  static const String appVersion = '1.0.0';

  // API Endpoints (Update these with your actual endpoints)
  static const String baseUrl = 'https://your-api-url.com/api';
  static const String loginEndpoint = 'login';
  static const String registerEndpoint = 'register';
  static const String logoutEndpoint = 'logout';

  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userIdKey = 'user_id';
  static const String userTypeKey = 'user_type';
  static const String isLoggedInKey = 'is_logged_in';

  // User Types
  static const String userTypeUser = 'user';
  static const String userTypeProvider = 'provider';

  // Timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration shortDelay = Duration(milliseconds: 300);
  static const Duration mediumDelay = Duration(milliseconds: 500);
  static const Duration longDelay = Duration(seconds: 1);

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
}

/// App Colors
class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryDark = Color(0xFF5548C8);
  static const Color primaryLight = Color(0xFF9D97FF);

  // Secondary Colors
  static const Color secondary = Color(0xFFFF6584);
  static const Color secondaryDark = Color(0xFFE5415E);
  static const Color secondaryLight = Color(0xFFFF8FA3);

  // Neutral Colors
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color greyLight = Color(0xFFE0E0E0);
  static const Color greyDark = Color(0xFF616161);

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);

  // Background Colors
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color scaffold = Color(0xFFFAFAFA);
}

/// Text Styles
class AppTextStyles {
  // Headings
  static const TextStyle h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );

  static const TextStyle h4 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );

  // Body Text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.black,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.black,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.grey,
  );

  // Button Text
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  // Caption
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.grey,
  );
}

/// App Spacing
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

/// Border Radius
class AppRadius {
  static const double sm = 4.0;
  static const double md = 8.0;
  static const double lg = 12.0;
  static const double xl = 16.0;
  static const double xxl = 24.0;
  static const double circular = 999.0;
}

/// App Durations
class AppDurations {
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
}
