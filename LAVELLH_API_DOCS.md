# Lavellh Backend API Integration - Business Owner

## API Configuration

### Base URL
```
https://lavellh-backend.onrender.com
```

### Bearer Token (Example)
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY5NjJkMzIzYzE1ZWRlMDdkZTEyNmYxOSIsInVzZXJUeXBlIjoiYnVzaW5lc3NPd25lciIsImlhdCI6MTc2ODA4NDI2MiwiZXhwIjoxNzY4MDg1MTYyfQ.Bt_lsF7GXkv70XvfeB_MydAnN6aypVJdrSWUBsSXWgA
```

## API Endpoints

### 1. Register Business Owner
**Method:** POST  
**Endpoint:** `/api/business-owners/register`  
**Auth Required:** No

**Request Body:**
```json
{
  "business_name": "My Business",
  "owner_name": "John Doe",
  "email": "john@business.com",
  "phone": "+1234567890",
  "password": "password123",
  "address": "123 Main St",
  "business_type": "Restaurant"
}
```

### 2. Login Business Owner
**Method:** POST  
**Endpoint:** `/api/business-owners/login`  
**Auth Required:** No

**Request Body:**
```json
{
  "email": "john@business.com",
  "password": "password123"
}
```

### 3. Send OTP
**Method:** GET  
**Endpoint:** `/api/business-owners/send-otp?email={email}`  
**Auth Required:** No

**Example:**
```
GET /api/business-owners/send-otp?email=john@business.com
```

### 4. Verify OTP
**Method:** GET  
**Endpoint:** `/api/business-owners/verify-otp?email={email}&otp={otp}`  
**Auth Required:** No

**Example:**
```
GET /api/business-owners/verify-otp?email=john@business.com&otp=123456
```

### 5. Reset Password with OTP
**Method:** GET  
**Endpoint:** `/api/business-owners/reset-password?email={email}&otp={otp}&newPassword={newPassword}`  
**Auth Required:** No

**Example:**
```
GET /api/business-owners/reset-password?email=john@business.com&otp=123456&newPassword=newpass123
```

### 6. Get Business Owner Info
**Method:** GET  
**Endpoint:** `/api/business-owners/me`  
**Auth Required:** Yes (Bearer Token)

**Headers:**
```
Authorization: Bearer {token}
```

## Expected Response Format

### Success Response (Login/Register):
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "business": {
      "id": "6962d323c15ede07de126f19",
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

### Error Response:
```json
{
  "success": false,
  "message": "Invalid credentials"
}
```

## Testing Steps

### 1. Test Login
1. Open the app
2. Navigate to Business Login Screen
3. Enter credentials:
   - Email: `your_test_email@example.com`
   - Password: `your_test_password`
4. Click Login
5. Check console logs for API request/response

### 2. Check Console Logs
You should see:
```
🔐 Business Login - Email: your_email@example.com
🌐 POST Request to: https://lavellh-backend.onrender.com/api/business-owners/login
📦 Request Body: {"email":"...","password":"..."}
✅ Response Status: 200
📥 Response Body: {"success":true,...}
```

### 3. Test Registration
1. Navigate to Business Sign Up Screen
2. Fill in all fields
3. Click Register
4. Check console logs

### 4. Test Forgot Password Flow
1. Click "Forgot Password?"
2. Enter email
3. Click Send OTP
4. Enter OTP received
5. Enter new password
6. Submit

## Important Notes

⚠️ **API Response Format:**
- Make sure your backend returns `success`, `message`, and `data` fields
- The `data` object should contain `token` and `business` fields
- If format is different, update `BusinessAuthResponse` model

⚠️ **Token Storage:**
- Token is automatically stored in SharedPreferences
- Token is sent in `Authorization: Bearer {token}` header for authenticated requests

⚠️ **OTP Methods:**
- Send OTP, Verify OTP, and Reset Password use GET requests
- Parameters are sent as query strings

## Troubleshooting

### Issue: "Network Error"
- Check if backend server is running
- Verify internet connection
- Check if URL is correct

### Issue: "Invalid response format"
- Check console logs for actual response
- Verify response matches expected format
- Update models if needed

### Issue: Login fails with 401
- Wrong credentials
- User doesn't exist
- Check backend logs

### Issue: Token not working
- Token might be expired
- Check token format in headers
- Verify backend accepts Bearer tokens

## Files Updated

✅ `lib/services/api_service.dart` - Base URL updated  
✅ `lib/services/business_auth_service.dart` - All endpoints updated  
✅ `lib/viewmodels/business_auth_viewmodel.dart` - Method names updated  
✅ `lib/views/business/auth/BusinessLoginScreen.dart` - Already integrated

## Next Steps

1. ✅ Test login with real credentials
2. ⬜ Integrate Sign Up screen
3. ⬜ Integrate Forgot Password screen
4. ⬜ Test all flows end-to-end
5. ⬜ Handle edge cases and errors

---

**Updated:** 2026-01-11  
**API Version:** Lavellh Backend v1  
**Status:** Ready for Testing
