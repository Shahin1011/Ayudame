# Quick Reference - Business API Integration

## 🚀 Quick Start

### 1. Update API URL (REQUIRED)
```dart
// lib/services/api_service.dart
static const String baseURL = 'https://your-backend-url.com';
```

### 2. Use in Login Screen
```dart
// Already integrated in BusinessLoginScreen.dart
final BusinessAuthViewModel _authViewModel = Get.put(BusinessAuthViewModel());

// Email field
TextField(
  controller: _authViewModel.emailController,
  ...
)

// Password field
TextField(
  controller: _authViewModel.passwordController,
  ...
)

// Login button
ElevatedButton(
  onPressed: _authViewModel.isLoading.value 
    ? null 
    : () => _authViewModel.login(),
  ...
)
```

## 📋 API Endpoints

Update these in `lib/services/business_auth_service.dart`:

```dart
Login:          POST   /api/business/auth/login
Sign Up:        POST   /api/business/auth/signup
Get Info:       GET    /api/business/auth/me
Forgot Pass:    POST   /api/business/auth/forgot-password
Verify Code:    POST   /api/business/auth/verify-code
Reset Pass:     POST   /api/business/auth/reset-password
```

## 🔧 Common Tasks

### Get Current User
```dart
final authVM = Get.find<BusinessAuthViewModel>();
final business = authVM.currentBusiness.value;
print(business?.businessName);
```

### Check Login Status
```dart
final authVM = Get.find<BusinessAuthViewModel>();
if (authVM.isLoggedIn.value) {
  // User is logged in
}
```

### Logout
```dart
final authVM = Get.find<BusinessAuthViewModel>();
await authVM.signOut();
```

## 📦 Required Packages

```yaml
dependencies:
  get: ^4.6.6
  http: ^1.1.0
  shared_preferences: ^2.2.2
```

## 🔍 Debug Logs

Look for these in console:
```
🌐 POST Request to: ...
📦 Request Body: ...
✅ Response Status: 200
📥 Response Body: ...
```

## ⚠️ Common Errors

| Error | Solution |
|-------|----------|
| Network error | Check internet & API URL |
| Invalid response | Verify API response format |
| Status 401 | Wrong credentials |
| Status 500 | Backend server error |

## 📝 Expected Response Format

```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "token": "jwt_token_here",
    "business": {
      "id": "123",
      "business_name": "My Business",
      "email": "email@example.com"
    }
  }
}
```

## 🎯 Next Steps

1. ✅ Update API base URL
2. ✅ Test login with real credentials
3. ⬜ Integrate Sign Up screen
4. ⬜ Integrate Forgot Password screen
5. ⬜ Implement other roles (Provider, User, Event Manager)
