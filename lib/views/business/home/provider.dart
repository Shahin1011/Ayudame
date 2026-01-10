import 'package:flutter/material.dart';
import 'package:middle_ware/widgets/custom_appbar.dart';
import '../../../widgets/provider_ui_card.dart';


class BusinessProvidersScreen extends StatelessWidget {
  const BusinessProvidersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: const CustomAppBar(title: "Providers"),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ProviderUICard(
            imageUrl:
            'https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=800',
            profileUrl:
            'https://images.unsplash.com/photo-1560250097-0b93528c311a?w=100',
            name: 'Jackson Builder',
            location: 'Dhanmondi Dhaka 1209',
            postedTime: '1 day ago',
            serviceTitle: 'House Cleaning',
            description:
            'I take care of every corner, deep cleaning every room with care.',
            rating: 4.0,
            reviewCount: 120,
            price: 'From \$100',
            showOnlineIndicator: true,
            onViewDetails: () {
              Navigator.pushNamed(context, '/service/profile');
            },
          ),

          ProviderUICard(
            imageUrl:
            'https://images.unsplash.com/photo-1601758228041-f3b2795255f1?w=800',
            profileUrl:
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
            name: 'Alex Walker',
            location: 'Gulshan Dhaka',
            postedTime: '2 days ago',
            serviceTitle: 'Dog Walking',
            description:
            'I take your dog out for regular walks, keeping them active.',
            rating: 4.0,
            reviewCount: 98,
            price: 'From \$80',
          ),
        ],
      ),
    );
  }
}
