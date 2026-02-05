@echo off
echo Testing Deep Link: ajudame://payment/success?session_id=TEST_SESSION_123

adb shell am start -W -a android.intent.action.VIEW -d "ayudame://payment/success?session_id=TEST_SESSION_123"

echo.
echo If the app opened, the test was successful.
pause
