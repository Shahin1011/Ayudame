import 'package:flutter/material.dart';
import 'package:middle_ware/screens/BusinessHomePageScreen.dart';
import 'package:middle_ware/screens/CreateEventPage.dart';
import 'package:middle_ware/screens/EditEventPage.dart';
import 'package:middle_ware/screens/EventDetailPage.dart';
import 'package:middle_ware/screens/EventListScreen.dart';
import 'package:middle_ware/screens/OrderProvider.dart';
import 'package:middle_ware/screens/PrivacyPolicyScreen.dart';
import 'package:middle_ware/screens/TermsConditionScreen.dart';
import 'package:middle_ware/screens/order/OrderDetailsScreen.dart';
import 'package:middle_ware/screens/portfolio/AddPortfolioScreen.dart';
import 'screens/onboarding/splash_screen.dart';
import 'screens/onboarding/onboardinglanguage_screen.dart';
import 'screens/onboarding/WelcomeScreen.dart';
import 'screens/onboarding/UserProviderSelectionScreen.dart';

import 'screens/LocationAccessScreen.dart';

import 'screens/Auth/LoginScreen.dart';
import 'screens/Auth/SignUpScreen.dart';
import 'screens/Auth/ForgotPasswordScreen.dart';
import 'screens/Auth/VerificationCodeScreen.dart';
import 'screens/Auth/SignUpProviderScreen.dart';
import 'screens/Auth/profile/ProfilePage.dart';


import 'screens/Auth/profile/EditProfileScreen.dart';

import 'screens/Help/HelpSupportScreen.dart';
import 'screens/ContractUsScreen.dart';
import 'screens/Faq/FaqScreen.dart';
import 'screens/WishlistScreen.dart';
import 'screens/order/OrderHistoryScreen.dart';
import 'screens/ProvidersScreen.dart';
import 'screens/ProviderDetailsScreen.dart';
import 'screens/AppointmentScreen.dart';
import 'screens/BookingScreen.dart';
import 'screens/BookingPaidScreen.dart';
import 'screens/Chat/ChatScreen.dart';
import 'screens/Auth/profile/ProviderProfileScreen.dart';
import 'screens/Payment/PaymentScreen.dart';
import 'screens/HomeScreen.dart';
import 'screens/CategoriesPage.dart';
import 'screens/notification/NotificationPage.dart';
import 'screens/HomeProviderScreen.dart';
import 'screens/CreateServiceProvider.dart';
import 'screens/Auth/LoginProviderScreen.dart';
import 'screens/Auth/profile/Provider/ProviderProfilePage.dart';
import 'screens/portfolio/ProviderPortfolioPage.dart';
import 'screens/BankAcountAddScreen.dart';
import 'screens/AddBankInfo.dart';
import 'screens/BankPayoutView.dart';
import 'screens/PaymentHistoryPage.dart';
import 'screens/PaymentHistoryDetailPage.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'middware App',
      debugShowCheckedModeBanner: false,
      //initialRoute: '/splash',
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),

        '/profile': (context) => const ProfilePage(),
        '/notifications': (context) => const NotificationPage(),
        '/profile/edit': (context) => const EditProfileScreen(),
        '/forgotpassword': (context) => const ForgotPasswordScreen(),
        '/otp': (context) => const VerificationCodeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const SignUpScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/location': (context) => const LocationAccessScreen(),
        '/userorprovider': (context) => const UserProviderSelectionScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/home': (context) => const HomePage(),
        '/categories': (context) => const CategoriesPage(),
        '/help': (context) => const HelpSupportScreen(),
        '/contact': (context) => const ContractUsScreen(),
        '/faq': (context) => const FaqScreen(),
        '/wishlist': (context) => const WishlistScreen(),
        '/order': (context) => const OrderHistoryScreen(),
        '/order/details': (context) => const OrderDetailsScreen(),

        '/service': (context) => const ProvidersScreen(),
        '/service/detail': (context) => const ProviderDetailsScreen(),
        '/appoinment': (context) => const AppointmentScreen(),
        '/booking': (context) => const BookingScreen(),
        '/booking/paid': (context) => const BookingPaidScreen(),
        '/chat': (context) => const ChatScreen(),
         '/service/profile': (context) => const ProviderProfileScreen(),
        '/payment': (context) => const PaymentScreen(),
        //ProviederRoutes: '/',


        '/provider/register': (context) => const SignUpProviderScreen(),
        '/provider/login': (context) => const LoginProviderScreen(),
        '/provider/home': (context) => const HomeProviderScreen(),
        '/provider/create': (context) => const CreateServicePage(),
        '/provider/profile': (context) => const ProviderProfilePage(),
        '/provider/portfolio': (context) => const PortfolioPage(),
        '/provider/portfolio/edit': (context) => const AddPortfolioScreen(),
        '/provider/order': (context) => const OrderHistoryProviderScreen(),
        '/provider/bank/add': (context) => const BankAddInformationPage(),
        '/provider/bank/info': (context) => const BankInformationScreen(),
        '/provider/payout': (context) => const BankInformationPayoutScreen(),
        '/provider/payment/history': (context) => const PaymentHistoryPage(),
        '/provider/payment/detail': (context) => const PaymentHistoryDetailPage(),
        '/terms': (context) => const TermsConditionScreen(),
        '/privacy': (context) => const PrivacyPolicyScreen(),


        '/Businesshome': (context) => const BusinessHomePageScreen(),




        '/homeevent': (context) => const EventListScreen(),
        '/eventedit': (context) => const EditEventPage(),
        '/eventcreate': (context) => const CreateEventPage(),
      },
    );
  }
}



