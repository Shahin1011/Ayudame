import 'package:flutter/material.dart';
import 'package:dashed_rect/dashed_rect.dart';

class providerBankAddInformationPage extends StatefulWidget {
  const providerBankAddInformationPage({super.key});

  @override
  State<providerBankAddInformationPage> createState() => _providerBankInformationPageState();
}

class _providerBankInformationPageState extends State<providerBankAddInformationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF2D6A4F),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 4, right: 16, top: 8, bottom: 16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                    ),
                    const Expanded(
                      child: Text(
                        'Bank Information',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ),
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  // Add Bank Account Button
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: DashedRect(
                      color: Colors.grey.shade400,
                      strokeWidth: 2,
                      gap: 4,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/provider/bank/info');
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                            child: const Center(
                              child: Text(
                                'Add Bank Account',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}