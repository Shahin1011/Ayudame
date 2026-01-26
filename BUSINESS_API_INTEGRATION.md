# Business Role API Integration Guide

## Overview
এই গাইডে Business role এর জন্য API integration এর সম্পূর্ণ প্রক্রিয়া বর্ণনা করা হয়েছে।

## Files Created/Modified

### 1. Services
- **`lib/services/storage_service.dart`** - Local storage management (SharedPreferences)
- **`lib/services/api_service.dart`** - HTTP API calls handler
- **`lib/services/business_auth_service.dart`** - Business authentication API calls

### 2. Models
- **`lib/models/business_model.dart`** - Business user data model
- **`lib/models/business_auth_response.dart`** - API response models

### 3. ViewModels
- **`lib/viewmodels/business_auth_viewmodel.dart`** - Business auth state management

### 4. Views
- **`lib/views/business/auth/BusinessLoginScreen.dart`** - Updated with API integration

## Setup Instructions

### Step 1: Update API Base URL
`lib/services/api_service.dart` ফাইলে গিয়ে আপনার backend URL দিন:

```dart
class ApiService {
  // TODO: Replace with your actual backend URL
  static const String baseURL = 'YOUR_API_BASE_URL_HERE';
  ...
}
```

**Example:**
```dart
static const String baseURL = 'https://your-api.com';
```

### Step 2: Update API Endpoints (Optional)
যদি আপনার API endpoints ভিন্ন হয়, তাহলে `lib/services/business_auth_service.dart` এ update করুন:

```dart
// Current endpoints:
- Login: '/api/business/auth/login'
- Sign Up: '/api/business/auth/signup'
- Get Info: '/api/business/auth/me'
- Forgot Password: '/api/business/auth/forgot-password'
- Verify Code: '/api/business/auth/verify-code'
- Reset Password: '/api/business/auth/reset-password'
```

### Step 3: Add Required Dependencies
`pubspec.yaml` ফাইলে নিচের dependencies যোগ করুন (যদি না থাকে):

```yaml
dependencies:
  flutter:
    sdk: flutter
  get: ^4.6.6
  http: ^1.1.0
  shared_preferences: ^2.2.2
```

তারপর run করুন:
```bash
flutter pub get
```

### Step 4: Expected API Response Format

#### Login/Signup Response:
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "business": {
      "id": "123",
      "business_name": "My Business",
      "owner_name": "John Doe",
      "email": "john@business.com",
      "phone": "+1234567890",
      "address": "123 Main St",
      "business_type": "Restaurant",
      "is_verified": true
    }
  }
}
```

#### Error Response:
```json
{
  "success": false,
  "message": "Invalid credentials"
}
```

## Usage Examples

### Login
```dart
final authViewModel = Get.find<BusinessAuthViewModel>();

// Set email and password
authViewModel.emailController.text = "business@example.com";
authViewModel.passwordController.text = "password123";

// Call login
await authViewModel.login();
```

### Sign Up
```dart
final authViewModel = Get.find<BusinessAuthViewModel>();

authViewModel.businessNameController.text = "My Business";
authViewModel.ownerNameController.text = "John Doe";
authViewModel.emailController.text = "john@business.com";
authViewModel.phoneController.text = "+1234567890";
authViewModel.passwordController.text = "password123";

await authViewModel.signUp();
```

### Check Authentication Status
```dart
final authViewModel = Get.find<BusinessAuthViewModel>();

// Check if logged in
if (authViewModel.isLoggedIn.value) {
  print("User is logged in");
  print("Business: ${authViewModel.currentBusiness.value?.businessName}");
}
```

### Logout
```dart
final authViewModel = Get.find<BusinessAuthViewModel>();
await authViewModel.signOut();
```

## Features Implemented

### ✅ Business Login
- Email/Phone + Password authentication
- Remember me functionality
- Loading state with spinner
- Error handling with user-friendly messages
- Automatic navigation to business home on success

### ✅ Business Sign Up
- Business name, owner name, email, phone, password
- Optional: address, business type
- Validation for required fields
- Success/error feedback

### ✅ Forgot Password Flow
- Send verification code to email
- Verify code
- Reset password

### ✅ Session Management
- Token storage in SharedPreferences
- Auto-login on app restart
- User role management (business, provider, user, event_manager)
- Secure logout with data clearing

### ✅ API Features
- Automatic token injection in headers
- Request/Response logging for debugging
- Error handling
- Support for all HTTP methods (GET, POST, PUT, PATCH, DELETE)

## Testing

### 1. Test Login Flow
1. Open `BusinessLoginScreen`
2. Enter email and password
3. Click Login button
4. Check console for API logs
5. Verify navigation to business home

### 2. Check Console Logs
API calls এর সময় console এ এই logs দেখতে পাবেন:
```
🌐 POST Request to: https://your-api.com/api/business/auth/login
📦 Request Body: {"email":"test@example.com","password":"***"}
✅ Response Status: 200
📥 Response Body: {"success":true,...}
```

### 3. Debug Mode
যদি কোনো সমস্যা হয়, console logs check করুন:
- ❌ Network Error - Internet connection issue
- ❌ Invalid response format - API response format mismatch
- ❌ Login failed - Wrong credentials or API error

## Next Steps

### For Other Roles (Provider, User, Event Manager):
1. Copy `business_auth_service.dart` এবং rename করুন
2. Update endpoints accordingly
3. Create corresponding models and viewmodels
4. Integrate with respective login screens

### Additional Features to Implement:
- [ ] Social login (Google, Facebook, Apple)
- [ ] Biometric authentication
- [ ] Token refresh mechanism
- [ ] Offline mode support
- [ ] Profile update API
- [ ] Business data CRUD operations

## Troubleshooting

### Issue: "Network Error"
**Solution:** 
- Check internet connection
- Verify API base URL is correct
- Check if backend server is running

### Issue: "Invalid response format"
**Solution:**
- Verify API response matches expected format
- Check console logs for actual response
- Update model classes if needed

### Issue: "Login failed with status 401"
**Solution:**
- Wrong credentials
- Check if user exists in database
- Verify password is correct

### Issue: Token not saved
**Solution:**
- Check SharedPreferences permissions
- Verify `shared_preferences` package is installed
- Check console for storage errors

## API Integration Checklist

- [x] Storage Service created
- [x] API Service created
- [x] Business Models created
- [x] Business Auth Service created
- [x] Business Auth ViewModel created
- [x] Login Screen integrated
- [ ] Sign Up Screen integrated
- [ ] Forgot Password Screen integrated
- [ ] Verification Code Screen integrated
- [ ] Update API Base URL
- [ ] Test with real backend
- [ ] Implement other roles (Provider, User, Event Manager)

## Contact & Support

যদি কোনো সমস্যা হয় বা প্রশ্ন থাকে, তাহলে:
1. Console logs check করুন
2. API response format verify করুন
3. Network connectivity check করুন
4. Backend API documentation দেখুন

---

**Created:** 2026-01-11
**Version:** 1.0.0
**Status:** Business Role - Ready for Testing
