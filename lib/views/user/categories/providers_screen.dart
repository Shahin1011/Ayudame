import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:middle_ware/core/theme/app_colors.dart';
import 'package:middle_ware/views/components/custom_app_bar.dart';
import 'package:middle_ware/views/user/home/widgets/custom_provider_card.dart';

class ProvidersScreen extends StatelessWidget{
  const ProvidersScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBar(title: "Providers"),
      body: Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(top: 10),
                itemCount: 10,
                itemBuilder: (context, index){
                  return CustomRecentProviderCard(
                    providerName: 'Shahin Alam',
                    location: 'Dhanmondi, Dhaka 1209',
                    activeStatus: '1 hour ago',
                    serviceTitle: 'Expert House Cleaning Service',
                    serviceDescription: 'I take care of every corner, deep cleaning every room without leaving your home fresh and perfectly tidy for you.',
                    reviews: '4.00 (120)',
                    appointmentPrice: 50,
                    servicePrice: 100,
                  );
                },
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.060)
          ],
        ),
      ),
    );
  }

}