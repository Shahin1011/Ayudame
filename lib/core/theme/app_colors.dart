import 'package:flutter/material.dart';

/// App Colors - Centralized color management
class AppColors {
  // ============================================
  // PRIMARY COLORS
  // ============================================
  static const Color mainAppColor = Color(0xFF1C5941);
  static const Color bgColor = Color(0xFFF3F8F4);
  static const Color red = Color(0xFFEA5C5C);
  static const Color green = Color(0xFF09B500);
  static const Color dark = Color(0xFF1F1D1D);
  static const Color grey = Color(0xFF525252);
  static const Color purple = Color(0xFF9C41EF);
  static const Color percent = Color(0xFF29C98A24);

  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryDark = Color(0xFF5548C8);
  static const Color primaryLight = Color(0xFF9D97FF);

  // ============================================
  // SECONDARY COLORS
  // ============================================

  static const Color secondary = Color(0xFFFF6584);
  static const Color secondaryDark = Color(0xFFE5415E);
  static const Color secondaryLight = Color(0xFFFF8FA3);

  // ============================================
  // NEUTRAL COLORS
  // ============================================

  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);

  static const Color greyLight = Color(0xFFE0E0E0);
  static const Color greyDark = Color(0xFF616161);
  static const Color greyExtraLight = Color(0xFFF5F5F5);

  // ============================================
  // STATUS COLORS
  // ============================================

  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFF81C784);
  static const Color successDark = Color(0xFF388E3C);

  static const Color error = Color(0xFFF44336);
  static const Color errorLight = Color(0xFFE57373);
  static const Color errorDark = Color(0xFFD32F2F);

  static const Color warning = Color(0xFFFF9800);
  static const Color warningLight = Color(0xFFFFB74D);
  static const Color warningDark = Color(0xFFF57C00);

  static const Color info = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFF64B5F6);
  static const Color infoDark = Color(0xFF1976D2);

  // ============================================
  // BACKGROUND COLORS
  // ============================================

  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color scaffold = Color(0xFFFAFAFA);
  static const Color card = Color(0xFFFFFFFF);

  // ============================================
  // USER TYPE SPECIFIC COLORS
  // ============================================

  /// User Colors
  static const Color userPrimary = Color(0xFF6C63FF);
  static const Color userAccent = Color(0xFF9D97FF);
  static const Color userBackground = Color(0xFFF8F7FF);

  /// Provider Colors
  static const Color providerPrimary = Color(0xFF00BCD4);
  static const Color providerAccent = Color(0xFF4DD0E1);
  static const Color providerBackground = Color(0xFFF0FCFF);

  /// Business Owner Colors
  static const Color businessPrimary = Color(0xFFFF9800);
  static const Color businessAccent = Color(0xFFFFB74D);
  static const Color businessBackground = Color(0xFFFFF8F0);

  /// Event Manager Colors
  static const Color eventPrimary = Color(0xFF9C27B0);
  static const Color eventAccent = Color(0xFFBA68C8);
  static const Color eventBackground = Color(0xFFFCF4FF);

  // ============================================
  // TEXT COLORS
  // ============================================

  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);
  static const Color textDisabled = Color(0xFF9E9E9E);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ============================================
  // BORDER COLORS
  // ============================================

  static const Color border = Color(0xFFE0E0E0);
  static const Color borderLight = Color(0xFFEEEEEE);
  static const Color borderDark = Color(0xFFBDBDBD);

  // ============================================
  // SHADOW COLORS
  // ============================================

  static const Color shadow = Color(0x1A000000);
  static const Color shadowLight = Color(0x0D000000);
  static const Color shadowDark = Color(0x33000000);

  // ============================================
  // GRADIENT COLORS
  // ============================================

  /// Primary Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// User Gradient
  static const LinearGradient userGradient = LinearGradient(
    colors: [userPrimary, userAccent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Provider Gradient
  static const LinearGradient providerGradient = LinearGradient(
    colors: [providerPrimary, providerAccent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Business Gradient
  static const LinearGradient businessGradient = LinearGradient(
    colors: [businessPrimary, businessAccent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Event Gradient
  static const LinearGradient eventGradient = LinearGradient(
    colors: [eventPrimary, eventAccent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ============================================
  // SOCIAL MEDIA COLORS
  // ============================================

  static const Color facebook = Color(0xFF1877F2);
  static const Color google = Color(0xFFDB4437);
  static const Color twitter = Color(0xFF1DA1F2);
  static const Color linkedin = Color(0xFF0A66C2);
  static const Color whatsapp = Color(0xFF25D366);

  // ============================================
  // HELPER METHODS
  // ============================================

  /// Get color by user type
  static Color getPrimaryByUserType(String userType) {
    switch (userType.toLowerCase()) {
      case 'user':
        return userPrimary;
      case 'provider':
        return providerPrimary;
      case 'business':
      case 'business_owner':
        return businessPrimary;
      case 'event':
      case 'event_manager':
        return eventPrimary;
      default:
        return primary;
    }
  }

  /// Get gradient by user type
  static LinearGradient getGradientByUserType(String userType) {
    switch (userType.toLowerCase()) {
      case 'user':
        return userGradient;
      case 'provider':
        return providerGradient;
      case 'business':
      case 'business_owner':
        return businessGradient;
      case 'event':
      case 'event_manager':
        return eventGradient;
      default:
        return primaryGradient;
    }
  }

  /// Get background by user type
  static Color getBackgroundByUserType(String userType) {
    switch (userType.toLowerCase()) {
      case 'user':
        return userBackground;
      case 'provider':
        return providerBackground;
      case 'business':
      case 'business_owner':
        return businessBackground;
      case 'event':
      case 'event_manager':
        return eventBackground;
      default:
        return background;
    }
  }
}
