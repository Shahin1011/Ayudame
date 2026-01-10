import 'package:flutter/material.dart';
import 'package:middle_ware/core/theme/app_colors.dart';
import 'package:middle_ware/widgets/custom_appbar.dart';

class ProviderFaqScreen extends StatefulWidget {
  const ProviderFaqScreen({Key? key}) : super(key: key);

  @override
  State<ProviderFaqScreen> createState() => _ProviderFaqScreenState();
}

class _ProviderFaqScreenState extends State<ProviderFaqScreen> {
  int? _expandedIndex;

  final List<Map<String, String>> _faqItems = [
    {
      'question': 'How do I book a service App?',
      'answer':
          'Select your service, pick a date & time, and confirm. You\'ll get a notification with details.',
    },
    {
      'question': 'Can I reschedule or cancel my booking?',
      'answer':
          'Yes, you can reschedule or cancel your booking from the order history section.',
    },
    {
      'question': 'What payment methods are accepted?',
      'answer':
          'We accept credit cards, debit cards, and digital payment methods.',
    },
    {
      'question': 'How do I contact the service provider?',
      'answer':
          'You can contact the service provider through the app\'s messaging feature or phone number provided.',
    },
    {
      'question': 'Is my personal information safe?',
      'answer':
          'Yes, we use encryption and secure protocols to protect your personal information.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'FAQ'),
      backgroundColor: AppColors.bgColor,
      body: Column(
        children: [

          const SizedBox(height: 16),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _faqItems.length,
              itemBuilder: (context, index) {
                final isExpanded = _expandedIndex == index;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Theme(
                      data: Theme.of(
                        context,
                      ).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        tilePadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        title: Text(
                          _faqItems[index]['question']!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        trailing: Icon(
                          isExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Colors.black54,
                        ),
                        onExpansionChanged: (expanded) {
                          setState(() {
                            _expandedIndex = expanded ? index : null;
                          });
                        },
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                _faqItems[index]['answer']!,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
