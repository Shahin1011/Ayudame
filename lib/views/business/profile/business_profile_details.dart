import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:middle_ware/views/business/profile/edit_business_profile_screen.dart';
import 'package:middle_ware/widgets/custom_appbar.dart';


class BusinessProfileViewPage extends StatelessWidget {
  const BusinessProfileViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F8F5),
      appBar: CustomAppBar(title: "Business Profile",  actions: [
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.white),
          onPressed: () {
            Get.to(() => const EditBusinessProfileScreen());
          },
        )
      ],),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                'assets/images/b_cover.png',
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            _infoField("Business name", "PrimePoint Services"),
            _infoField("Business category", "Cleaning Services"),
            _infoField("Business location", "142, Newwork ddrc 125"),
            _infoField("About", "xxxxxxxxxxxxxxxxxxxxx"),
            const SizedBox(height: 20),
            const Text("Business photo",
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/b_logo.png',
                height: 120,
                width: 120,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoField(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
              const TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
