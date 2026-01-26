## Backend Field Mapping Test

Run the app and create an employee. Check the console/debug output for these logs:

### When Creating Employee:
Look for: `📤 Creating Employee - Fields:`
This will show you what fields are being sent to backend.

### When Getting Employees:
Look for: `📥 Get All Employees Response:`
This will show you the exact JSON structure from backend.

### Expected Backend Fields (as per your requirement):
```
fullName
mobileNumber
email
headline
description
categories
whyChooseService (array)
appointmentEnabled (boolean)
appointmentSlots (array of objects)
servicePhoto (file)
photo (file) - for profile picture
```

### Current Mapping in App:
```dart
// Sending to Backend (toJson):
'fullName' → employee.name
'mobileNumber' → employee.phone
'email' → employee.email
'headline' → employee.headline
'description' → employee.about
'categories' → employee.serviceCategory
'whyChooseService[0]', 'whyChooseService[1]'... → employee.whyChooseUs
'appointmentEnabled' → employee.isAppointmentBased
'appointmentSlots' → JSON string of appointment options
'servicePhoto' → idCardBack file
'photo' → idCardFront file

// Receiving from Backend (fromJson):
employee.name ← json['fullName']
employee.phone ← json['mobileNumber']
employee.email ← json['email']
employee.headline ← json['headline']
employee.about ← json['description']
employee.serviceCategory ← json['categories']
employee.whyChooseUs ← json['whyChooseService']
employee.isAppointmentBased ← json['appointmentEnabled']
employee.appointmentOptions ← json['appointmentSlots']
employee.idCardBack ← json['servicePhoto']
employee.profileImage ← json['photo']
```

### Troubleshooting Steps:

1. **Run the app in debug mode**
2. **Create a new employee** with all fields filled
3. **Check the console output** for the debug logs
4. **Copy the response JSON** and check:
   - Are images returning as URLs?
   - Is description field present?
   - What are the exact field names?

5. **If field names are different**, update the model accordingly

### Common Issues:

1. **Images not uploading:**
   - Check if backend expects different field names
   - Check if backend requires specific image format
   - Check file size limits

2. **Description not saving:**
   - Verify backend field name is 'description'
   - Check if there's a character limit
   - Check if it's being sent in the request

3. **Data not returning:**
   - Check if backend is actually saving the data
   - Verify the GET endpoint returns all fields
   - Check if there's a database issue

### Next Steps:
Share the console output here and I'll help you fix the exact issue.
