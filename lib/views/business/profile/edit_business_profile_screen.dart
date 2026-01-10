import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:middle_ware/widgets/custom_appbar.dart';

class EditBusinessProfileScreen extends StatelessWidget {
  const EditBusinessProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8F5),
      appBar: CustomAppBar(title: "Edit Business Profile"),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Business cover photo',
                style: TextStyle(fontSize: 12.sp)),
            SizedBox(height: 8.h),
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.asset(
                    'assets/images/b_cover.png',
                    height: 160.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: Center(
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Icon(Icons.camera_alt,
                          color: Colors.grey[700]),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            _input('Business name', 'PrimePoint Services'),
            _input('Business category', 'Cleaning Services'),
            _input('Business location', '142, Newwork drdc 125'),
            _input('About', 'xxxxxxxxxxxxxxxxxxxx', maxLines: 4),

            SizedBox(height: 12.h),
            Text('Business photo',
                style: TextStyle(fontSize: 12.sp)),
            SizedBox(height: 8.h),
            Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.asset(
                    'assets/images/b_logo.png',
                    height: 120.h,
                    width: 120.h,
                    fit: BoxFit.cover,
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.camera_alt,
                      color: Colors.grey[700]),
                ),
              ],
            ),

            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1C5941),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _input(String label, String value, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12.sp)),
        SizedBox(height: 6.h),
        TextFormField(
          initialValue: value,
          maxLines: maxLines,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
        ),
        SizedBox(height: 14.h),
      ],
    );
  }
}
