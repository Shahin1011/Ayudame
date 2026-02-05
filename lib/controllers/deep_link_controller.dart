import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:middle_ware/core/routes/app_routes.dart';

class DeepLinkController extends GetxController {
  late AppLinks _appLinks;

  @override
  void onInit() {
    super.onInit();
    _initDeepLinks();
  }

  Future<void> _initDeepLinks() async {
    _appLinks = AppLinks();

    // Check initial link if app was started by a deep link
    try {
      final Uri? initialUri = await _appLinks.getInitialLink();
      debugPrint('🔗 Initial URI: $initialUri');
      if (initialUri != null) {
        _handleDeepLink(initialUri);
      } else {
        debugPrint('⚠️ No initial deep link found');
      }
    } catch (e) {
      debugPrint('❌ Error getting initial URI: $e');
    }

    // Listen for new deep links while app is running
    _appLinks.uriLinkStream.listen((Uri? uri) {
      debugPrint('🔗 Deep link stream received: $uri');
      if (uri != null) {
        _handleDeepLink(uri);
      }
    }, onError: (err) {
      debugPrint('❌ Error listening to deep links: $err');
    });
  }

  void _handleDeepLink(Uri uri) {
    debugPrint('📱 Handling deep link: $uri');
    debugPrint('   - Scheme: ${uri.scheme}');
    debugPrint('   - Host: ${uri.host}');
    debugPrint('   - Path: ${uri.path}');
    debugPrint('   - Query params: ${uri.queryParameters}');

    // Check path for payment success
    // Example: ayudame://payment/success?session_id=123
    if (uri.path.contains('payment/success')) {
      final String? sessionId = uri.queryParameters['session_id'];
      debugPrint('✅ Payment success detected! Session ID: $sessionId');

      // Small delay to ensure app is fully initialized
      Future.delayed(const Duration(milliseconds: 300), () {
        Get.toNamed(
            AppRoutes.paymentSuccess,
            parameters: sessionId != null ? {'session_id': sessionId} : {}
        );
      });
    }

    // Check path for payment cancel
    // Example: ayudame://payment/cancel
    else if (uri.path.contains('payment/cancel')) {
      debugPrint('❌ Payment cancelled');

      Future.delayed(const Duration(milliseconds: 300), () {
        Get.snackbar(
          'Payment Cancelled',
          'You have cancelled the payment process.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      });
    }
    else {
      debugPrint('⚠️ Unknown deep link path: ${uri.path}');
    }
  }
}