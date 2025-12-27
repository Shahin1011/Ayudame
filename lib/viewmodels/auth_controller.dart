// import 'package:get/get.dart';
// import '../models/user_model.dart';
// import '../repositories/user_repository.dart';
//
// /// ViewModel for Authentication using GetX
// /// Handles all authentication-related business logic and state
// class AuthController extends GetxController {
//   final UserRepository _userRepository;
//
//   AuthController({UserRepository? userRepository})
//     : _userRepository = userRepository ?? UserRepository();
//
//   // Observable state variables using GetX
//   final Rx<UserModel?> _currentUser = Rx<UserModel?>(null);
//   final RxBool _isLoading = false.obs;
//   final RxString _errorMessage = ''.obs;
//   final RxBool _isAuthenticated = false.obs;
//
//   // Getters
//   UserModel? get currentUser => _currentUser.value;
//   bool get isLoading => _isLoading.value;
//   String get errorMessage => _errorMessage.value;
//   bool get isAuthenticated => _isAuthenticated.value;
//
//   /// Set loading state
//   void _setLoading(bool value) {
//     _isLoading.value = value;
//   }
//
//   /// Set error message
//   void _setError(String message) {
//     _errorMessage.value = message;
//   }
//
//   /// Clear error
//   void clearError() {
//     _errorMessage.value = '';
//   }
//
//   /// Login user
//   Future<bool> login({required String email, required String password}) async {
//     try {
//       _setLoading(true);
//       clearError();
//
//       _currentUser.value = await _userRepository.login(
//         email: email,
//         password: password,
//       );
//
//       _isAuthenticated.value = true;
//       _setLoading(false);
//
//       return true;
//     } catch (e) {
//       _setError(e.toString());
//       _setLoading(false);
//       return false;
//     }
//   }
//
//   /// Register new user
//   Future<bool> register({
//     required String name,
//     required String email,
//     required String password,
//     String? phone,
//   }) async {
//     try {
//       _setLoading(true);
//       clearError();
//
//       _currentUser.value = await _userRepository.register(
//         name: name,
//         email: email,
//         password: password,
//         phone: phone,
//       );
//
//       _isAuthenticated.value = true;
//       _setLoading(false);
//
//       return true;
//     } catch (e) {
//       _setError(e.toString());
//       _setLoading(false);
//       return false;
//     }
//   }
//
//   /// Logout user
//   Future<void> logout() async {
//     try {
//       _setLoading(true);
//       await _userRepository.logout();
//
//       _currentUser.value = null;
//       _isAuthenticated.value = false;
//       _setLoading(false);
//     } catch (e) {
//       _setError(e.toString());
//       _setLoading(false);
//     }
//   }
//
//   /// Forgot password
//   Future<bool> forgotPassword(String email) async {
//     try {
//       _setLoading(true);
//       clearError();
//
//       await _userRepository.forgotPassword(email);
//
//       _setLoading(false);
//       return true;
//     } catch (e) {
//       _setError(e.toString());
//       _setLoading(false);
//       return false;
//     }
//   }
//
//   /// Verify OTP
//   Future<bool> verifyOTP({required String email, required String otp}) async {
//     try {
//       _setLoading(true);
//       clearError();
//
//       final isVerified = await _userRepository.verifyOTP(
//         email: email,
//         otp: otp,
//       );
//
//       _setLoading(false);
//       return isVerified;
//     } catch (e) {
//       _setError(e.toString());
//       _setLoading(false);
//       return false;
//     }
//   }
//
//   /// Reset password
//   Future<bool> resetPassword({
//     required String email,
//     required String otp,
//     required String newPassword,
//   }) async {
//     try {
//       _setLoading(true);
//       clearError();
//
//       await _userRepository.resetPassword(
//         email: email,
//         otp: otp,
//         newPassword: newPassword,
//       );
//
//       _setLoading(false);
//       return true;
//     } catch (e) {
//       _setError(e.toString());
//       _setLoading(false);
//       return false;
//     }
//   }
//
//   /// Update user profile
//   Future<bool> updateProfile({
//     String? name,
//     String? email,
//     String? phone,
//     String? profileImage,
//   }) async {
//     if (_currentUser.value == null) {
//       _setError('No user logged in');
//       return false;
//     }
//
//     try {
//       _setLoading(true);
//       clearError();
//
//       _currentUser.value = await _userRepository.updateUserProfile(
//         userId: _currentUser.value!.id!,
//         name: name,
//         email: email,
//         phone: phone,
//         profileImage: profileImage,
//       );
//
//       _setLoading(false);
//       return true;
//     } catch (e) {
//       _setError(e.toString());
//       _setLoading(false);
//       return false;
//     }
//   }
//
//   /// Load user profile
//   Future<void> loadUserProfile(String userId) async {
//     try {
//       _setLoading(true);
//       clearError();
//
//       _currentUser.value = await _userRepository.getUserProfile(userId);
//       _isAuthenticated.value = true;
//
//       _setLoading(false);
//     } catch (e) {
//       _setError(e.toString());
//       _setLoading(false);
//     }
//   }
//
//   @override
//   void onInit() {
//     super.onInit();
//     // Initialize controller - check if user is already logged in
//     // You can load user from local storage here
//   }
//
//   @override
//   void onClose() {
//     // Clean up resources
//     super.onClose();
//   }
// }
