import 'package:get/get.dart';
import 'package:middle_ware/views/provider/auth/ProviderForgotPasswordScreen.dart';
import 'package:middle_ware/views/provider/auth/providerVerificationCodeScreen.dart';

// Common/Shared Views
import '../../views/business/Activities/ActivitiesPage.dart';
import '../../views/business/auth/BusinessForgotPasswordScreen.dart';
import '../../views/business/auth/BusinessResetPasswordScreen.dart';
import '../../views/business/auth/BusinessLoginScreen.dart';
import '../../views/business/auth/BusinessSignUpScreen.dart';
import '../../views/business/auth/BusinessVerificationCodeScreen.dart';
import '../../views/business/home/BusinessNotificationPage.dart';
import '../../views/business/profile/BusinessProfile.dart';
import '../../views/business/profile/BusinessTermsConditionScreen.dart';
import '../../views/business/profile/PrivacyPolicyScreen.dart';
import '../../views/event_manager/auth/auth/EventForgotPasswordScreen.dart';
import '../../views/event_manager/auth/auth/EventLoginScreen.dart';
import '../../views/event_manager/auth/auth/EventSignUpScreen.dart';
import '../../views/event_manager/auth/auth/EventVerificationCodeScreen.dart';
import '../../views/event_manager/auth/auth/EventResetPasswordScreen.dart';
import '../../views/event_manager/event/CreateEventPage.dart';
import '../../views/event_manager/profile/EventProfile.dart';
import '../../views/onboarding/LocationAccessScreen.dart';
import '../../views/onboarding/UserProviderSelectionScreen.dart';
import '../../views/onboarding/WelcomeScreen.dart';
import '../../views/onboarding/onboardinglanguage_screen.dart';
import '../../views/onboarding/splash_screen.dart';

// Business Feature Views

import '../../views/business/employee/BusinessEmployeeScreen.dart'; // Import EmployeeDetailsScreen

// Event Manager Feature Views

import '../../views/event_manager/home/EditEventPage.dart';
import '../../views/provider/profile/ProviderPortfolioPage.dart';
import '../../widgets/bottom_navb.dart';
import '../../widgets/bottom_nave.dart';
// Event Manager Feature Views mappings removed as they are imported above directly

// Provider Feature Views
import '../../views/provider/auth/LoginProviderScreen.dart';
import '../../views/provider/auth/SignUpProviderScreen.dart';
import '../../views/provider/home/CreateServiceProvider.dart';
import '../../views/provider/home/HomeProviderScreen.dart';
import '../../views/provider/orders/OrderProvider.dart';
import '../../views/provider/profile/BankAcountAddScreen.dart';
import '../../views/provider/profile/ProviderProfilePage.dart';
import '../../views/provider/profile/providerBankPayoutView.dart';
import '../../views/provider/profile/provider_AddBankInfo.dart';
import '../../views/provider/settings/PaymentHistoryDetailPage.dart';
import '../../views/provider/settings/PaymentHistoryPage.dart';

// User Feature Views
import '../../views/user/UserNotificationPage.dart';
import '../../views/user/auth/ForgotPasswordScreen.dart';
import '../../views/user/auth/LoginScreen.dart';
import '../../views/user/auth/SignUpScreen.dart';
import '../../views/user/auth/VerificationCodeScreen.dart';
import '../../views/user/home/CategoriesPage.dart';
import '../../views/user/home/ChatScreen.dart';
import '../../views/user/home/HomeScreen.dart';
import '../../views/user/home/ProviderDetailsScreen.dart';
import '../../views/user/home/ProvidersScreen.dart';
import '../../views/user/orders/AppointmentScreen.dart';
import '../../views/user/orders/BookingPaidScreen.dart';
import '../../views/user/orders/BookingScreen.dart';
import '../../views/user/orders/OrderDetailsScreen.dart';
import '../../views/user/orders/OrderHistoryScreen.dart';
import '../../views/user/orders/PaymentScreen.dart';
import '../../views/user/profile/EditProfileScreen.dart';
import '../../views/user/profile/ProfilePage.dart';
import '../../views/user/profile/WishlistScreen.dart';

class AppRoutes {
  // ============================================
  // COMMON & ONBOARDING ROUTES
  // ============================================
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String welcome = '/welcome';
  static const String userTypeSelection = '/user-type-selection';
  static const String location = '/location';
  static const String terms = '/terms';
  static const String privacy = '/privacy';
  static const String notifications = '/notifications';

  // ============================================
  // USER ROUTES
  // ============================================
  static const String userlogin = '/user_login';
  static const String userregister = '/user_register';
  static const String userforgotPassword = '/user_forgot-password';
  static const String userotp = '/user_otp';
  static const String userNotification = "/user_notification";

  static const String userHome = '/user-home';
  static const String userProfile = '/user-profile';
  static const String userEditProfile = '/user-edit-profile';
  static const String userCategories = '/user-categories';
  static const String userProviders = '/ProvidersScreen';
  static const String userProviderDetails = '/ProviderDetailsScreen';
  static const String userAppointment = '/user-appointment';
  static const String userBooking = '/user-booking';
  static const String userBookingPaid = '/user-booking-paid';
  static const String userOrderHistory = '/user-order-history';
  static const String userOrderDetails = '/user-order-details';
  static const String userWishlist = '/user-wishlist';
  static const String userChat = '/user-chat';
  static const String userPayment = '/user-payment';

  // ============================================
  // PROVIDER ROUTES
  // ============================================
  static const String providerLogin = '/provider-login';
  static const String providerRegister = '/SignUpProviderScreen';
  static const String providerForgotPass = '/ProviderForgotPasswordScreen';
  static const String providerOtp = '/providerVerificationCodeScreen';
  static const String providerHome = '/provider-home';
  static const String providerProfile = '/ProviderProfilePage';
  static const String providerCreateService = '/CreateServiceProvider';
  static const String providerOrders = '/OrderProvider';
  static const String providerPortfolio = '/provider-portfolio';
  static const String providerAddPortfolio = '/provider-add-portfolio';
  static const String providerBankAdd = '/provider-bank-add';
  static const String providerBankInfo = '/provider-bank-info';
  static const String providerPayout = '/provider-payout';
  static const String providerPaymentHistory = '/provider-payment-history';
  static const String providerPaymentDetails = '/provider-payment-details';

  // ============================================
  // BUSINESS OWNER ROUTES
  // ============================================
  static const String businessHome = '/BusinessHomePageScreen';
  static const String businessLogin = '/BusinessLoginScreen';
  static const String businessRegister = '/BusinessSignUpScreen';
  static const String businessOtp = '/BusinessVerificationCodeScreen';
  static const String businessForgotPass = '/BusinessForgotPasswordScreen';
  static const String businessResetPassword = '/BusinessResetPasswordScreen';
  static const String businessEmployee = '/BusinessEmployeeScreen';
  static const String businessOrders = '/business-orders';
  static const String businessActivity = '/ActivitiesPage';

  static const String businessProfile = '/BusinessProfile';

  // ============================================
  // EVENT MANAGER ROUTES
  // ============================================
  static const String eventLogin = '/EventLoginScreen';
  static const String eventRegister = '/EventSignUpScreen';
  static const String eventForgotPass = '/EventForgotPasswordScreen';
  static const String eventOtp = '/EventVerificationCodeScreen';
  static const String eventResetPassword = '/EventResetPasswordScreen';
  static const String eventHome = '/EventHomeScreen';
  static const String eventCreate = '/EventListScreen';
  static const String eventEdit = '/EditEventPage';
  static const String eventProfile = '/EventProfile';

  // ============================================
  // GET PAGES DEFINITION
  // ============================================
  static List<GetPage> pages = [
    // Common
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: onboarding, page: () => const OnboardingScreen()),
    GetPage(name: welcome, page: () => const WelcomeScreen()),
    GetPage(
      name: userTypeSelection,
      page: () => const UserProviderSelectionScreen(),
    ),
    GetPage(name: location, page: () => const LocationAccessScreen()),
    GetPage(name: terms, page: () => const BusinessTermsConditionScreen()),
    GetPage(name: privacy, page: () => const BusinessPrivacyPolicyScreen()),
    GetPage(name: notifications, page: () => const BusinessNotificationPage()),

    // User Auth & Features
    GetPage(name: userlogin, page: () => const LoginScreen()),
    GetPage(name: userregister, page: () => const SignUpScreen()),
    GetPage(name: userforgotPassword, page: () => const ForgotPasswordScreen()),
    GetPage(name: userotp, page: () => const VerificationCodeScreen()),
    GetPage(name: userHome, page: () => const HomePage()),
    GetPage(name: userProfile, page: () => const ProfilePage()),
    GetPage(name: userEditProfile, page: () => const EditProfileScreen()),
    GetPage(name: userCategories, page: () => const CategoriesPage()),

    GetPage(name: userNotification, page: () => const userNotificationPage()),
    GetPage(name: userProviders, page: () => const ProvidersScreen()),
    GetPage(
      name: userProviderDetails,
      page: () => const ProviderDetailsScreen(),
    ),
    GetPage(name: userAppointment, page: () => const AppointmentScreen()),
    GetPage(name: userBooking, page: () => const BookingScreen()),
    GetPage(name: userBookingPaid, page: () => const BookingPaidScreen()),
    GetPage(
      name: userOrderHistory,
      page: () => const OrderHistoryProviderScreen(),
    ),
    // GetPage(name: userOrderDetails, page: () => const OrderHistoryProviderScreen()),
    GetPage(name: userWishlist, page: () => const WishlistScreen()),
    GetPage(name: userChat, page: () => const ChatScreen()),
    GetPage(name: userPayment, page: () => const PaymentScreen()),

    // Provider Auth & Features
    GetPage(name: providerLogin, page: () => const LoginProviderScreen()),
    GetPage(name: providerRegister, page: () => const SignUpProviderScreen()),
    GetPage(
      name: providerForgotPass,
      page: () => ProviderForgotPasswordScreen(),
    ),
    GetPage(
      name: providerOtp,
      page: () => const ProviderVerificationCodeScreen(),
    ),

    GetPage(name: providerHome, page: () => const HomeProviderScreen()),
    GetPage(name: providerProfile, page: () => ProviderProfilePage()),
    GetPage(name: providerCreateService, page: () => CreateServicePage()),
    GetPage(name: providerOrders, page: () => OrderHistoryProviderScreen()),
    GetPage(name: providerPortfolio, page: () => const PortfolioListScreen()),
    GetPage(name: providerAddPortfolio, page: () => const AddPortfolioScreen()),
    GetPage(
      name: providerBankAdd,
      page: () => const ProviderBankInformationScreen(),
    ),
    GetPage(
      name: providerBankInfo,
      page: () => const providerBankAddInformationPage(),
    ),
    GetPage(
      name: providerPayout,
      page: () => const providerBankInformationPayoutScreen(),
    ),
    GetPage(
      name: providerPaymentHistory,
      page: () => const PaymentHistoryPage(),
    ),
    GetPage(
      name: providerPaymentDetails,
      page: () => const PaymentHistoryDetailPage(),
    ),

    // Business
    GetPage(name: businessHome, page: () => const BottomNavScreen()),
    GetPage(name: businessLogin, page: () => const BusinessLoginScreen()),
    GetPage(name: businessRegister, page: () => const BusinessSignUpScreen()),
    GetPage(
      name: businessOtp,
      page: () => const BusinessVerificationCodeScreen(),
    ),
    GetPage(
      name: businessForgotPass,
      page: () => BusinessForgotPasswordScreen(),
    ),
    GetPage(
      name: businessResetPassword,
      page: () => BusinessResetPasswordScreen(),
    ),
    GetPage(
      name: businessEmployee,
      page: () => const EmployeeDetailsScreen(),
    ), // Verify import
    GetPage(
      name: businessOrders,
      page: () => const OrderHistoryProviderScreen(),
    ), // Reuse provider orders for now
    GetPage(name: businessProfile, page: () => const Businessprofile()),
    GetPage(name: businessActivity, page: () => const ActivitiesPage()),

    // Event Manager
    GetPage(name: eventLogin, page: () => const EventLoginScreen()),
    GetPage(name: eventRegister, page: () => const EventSignUpScreen()),
    GetPage(
      name: eventForgotPass,
      page: () => const EventForgotPasswordScreen(),
    ),
    GetPage(name: eventOtp, page: () => const EventVerificationCodeScreen()),
    GetPage(
      name: eventResetPassword,
      page: () => const EventResetPasswordScreen(),
    ),
    GetPage(name: eventHome, page: () => const BottomNavEScreen()),
    GetPage(name: eventCreate, page: () => const CreateEventPage()),
    GetPage(name: eventEdit, page: () => const EditEventPage()),
    GetPage(name: eventProfile, page: () => const EventProfilePage()),
  ];
}
