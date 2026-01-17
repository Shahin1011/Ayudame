## Employee API Testing Guide

### API Endpoints Confirmed:

1. **List All Employees**
   - Method: `GET`
   - Endpoint: `/api/business-owners/employees`
   - Auth: Required

2. **Get Employee Detail**
   - Method: `GET`
   - Endpoint: `/api/business-owners/employees/{id}`
   - Example ID: `69683a29cbd414fd5c73a008`
   - Auth: Required

3. **Create Employee**
   - Method: `POST` (multipart/form-data)
   - Endpoint: `/api/business-owners/employees`
   - Auth: Required

4. **Update Employee**
   - Method: `PUT` (via POST with _method=PUT for multipart)
   - Endpoint: `/api/business-owners/employees/{id}`
   - Auth: Required

### Backend Fields (10 fields total):

```json
{
  "fullName": "string",
  "mobileNumber": "string",
  "email": "string",
  "headline": "string",
  "description": "string",
  "categories": "string",
  "whyChooseService": ["string array"],
  "appointmentEnabled": "boolean",
  "appointmentSlots": [
    {
      "duration": "string",
      "price": "number"
    }
  ],
  "servicePhoto": "file upload"
}
```

### Testing Steps:

#### 1. Test Create Employee
1. Run the app in debug mode
2. Navigate to Employee List screen
3. Click "Create an employee"
4. Fill all fields:
   - Employee Name
   - Mobile Number
   - Email
   - Upload Service Photo (required)
   - Select Category
   - Headline
   - About this service (description)
   - Why choose us (4 items)
   - Service pricing
   - Toggle "Make an Appointment" ON
   - Add duration & price pairs

5. Click "Create Now"

6. **Check Console Output:**
   ```
   📤 Creating Employee - Fields: {...}
   📤 Creating Employee - Files: [servicePhoto]
   📤 servicePhoto path: /path/to/image
   📥 Response Status: 200 or 201
   📥 Response Body: {...}
   ✅ Employee Created: {...}
   ```

#### 2. Test Get All Employees
1. After creating employee, app will auto-refresh
2. **Check Console Output:**
   ```
   📥 Get All Employees Status: 200
   📥 Get All Employees Response: {...}
   📋 Total Employees: X
   📋 First Employee Data: {...}
   ```

3. **Verify in UI:**
   - Employee card shows correct name
   - Headline appears
   - Description appears
   - Service photo displays
   - Category shows

#### 3. Test Get Employee Detail
1. Tap on an employee card
2. **Check Console Output:**
   ```
   📥 Get Employee Detail Status: 200
   📥 Get Employee Detail Response: {...}
   📋 Employee Detail Data: {...}
   ```

### Expected Response Structure:

```json
{
  "success": true,
  "data": {
    "_id": "69683a29cbd414fd5c73a008",
    "fullName": "John Doe",
    "mobileNumber": "+1234567890",
    "email": "john@example.com",
    "headline": "Professional Cleaner",
    "description": "Expert in home cleaning services...",
    "categories": "Home Cleaning",
    "whyChooseService": [
      "24/7 Service",
      "Efficient & Fast",
      "Affordable Prices",
      "Expert Team"
    ],
    "appointmentEnabled": true,
    "appointmentSlots": [
      {
        "duration": "15 min",
        "price": 50
      },
      {
        "duration": "30 min",
        "price": 100
      }
    ],
    "servicePhoto": "https://example.com/uploads/service-photo.jpg"
  }
}
```

### Common Issues & Solutions:

#### Issue 1: Image not uploading
**Symptoms:** servicePhoto is null or empty in response
**Debug:**
- Check console: `📤 servicePhoto path:` - Is path valid?
- Check response: Does it contain servicePhoto URL?
**Solution:**
- Ensure image is selected
- Check file size (max 5MB)
- Verify backend accepts multipart/form-data

#### Issue 2: Description not saving
**Symptoms:** description field is null in response
**Debug:**
- Check console: `📤 Creating Employee - Fields:` 
- Look for: `description: "your text"`
**Solution:**
- Ensure "About this service" field is filled
- Check if backend has character limit

#### Issue 3: whyChooseService not saving
**Symptoms:** whyChooseService is null or empty array
**Debug:**
- Check console: `📤 Creating Employee - Fields:`
- Look for: `whyChooseService: ["item1","item2",...]`
**Solution:**
- Ensure all 4 "Why choose us" fields are filled
- Verify backend accepts JSON array format

#### Issue 4: appointmentSlots not saving
**Symptoms:** appointmentSlots is null or empty
**Debug:**
- Check if "Make an Appointment" toggle is ON
- Check console for: `appointmentSlots: [{...}]`
**Solution:**
- Toggle appointment ON
- Add at least one duration & price pair
- Verify JSON format is correct

### Next Steps:

1. **Run the app**
2. **Create a test employee**
3. **Copy console output** and share here
4. **Take screenshot** of employee list page
5. **Report any issues** you see

This will help identify the exact problem if data is still not saving correctly.
