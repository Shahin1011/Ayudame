import 'package:flutter/material.dart';
import 'package:middle_ware/core/theme/app_colors.dart';
import 'WelcomeScreen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool privacyAccepted = false;
  bool termsAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F8F4),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Title
              Text(
                'Select your comfortable language',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.050),

              // Language Selection Cards
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // English Card
                  Flexible(
                    child: _buildLanguageCard(
                      context: context,
                      language: 'English',
                      flag: '🇺🇸',
                      imagePath: 'assets/images/uk.png',
                      cardColor: Color(0xFF1C5941),
                      textColor: Colors.white,
                      onTap: () {
                        _handleLanguageSelection(context, 'English');
                      },
                    ),
                  ),

                  SizedBox(width: MediaQuery.of(context).size.width * 0.05), // 5% of screen width

                  // Spanish Card
                  Flexible(
                    child: _buildLanguageCard(
                      context: context,
                      language: 'Spanish',
                      flag: '🇪🇸',
                      textColor: Colors.black,
                      imagePath: 'assets/images/spain.png',
                      cardColor: Color(0xFFEAEFE9),
                      onTap: () {
                        _handleLanguageSelection(context, 'Spanish');
                      },
                    ),
                  ),
                ],
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageCard({
    required BuildContext context,
    required String language,
    required String flag,
    required String imagePath,
    required Color cardColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: cardColor, // Different color for each card
          borderRadius: BorderRadius.circular(20),
          border: Border.all( color: AppColors.mainAppColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Flag Icon - Circular with border
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white, // White background for flag circle
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Image.asset(
                  imagePath, // Different image for each card
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback to emoji if image fails to load
                    return Center(
                      child: Text(
                        flag,
                        style: const TextStyle(fontSize: 20),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Language Name
            Text(
              language,
              style: TextStyle( // REMOVED 'const' from here
                fontWeight: FontWeight.w500,
                color: textColor, // This makes it non-constant
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _handleLanguageSelection(BuildContext context, String language) {
    setState(() {
      privacyAccepted = false;
    });
    _showPrivacyPolicyDialog(context, language);
  }

  void _showPrivacyPolicyDialog(BuildContext context, String language) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              contentPadding: const EdgeInsets.all(28),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    const Text(
                      'Privacy & Policy',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 24,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Last updated date
                    Text(
                      'Last updated on 23 August 2025',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Description
                    Text(
                      'We collect personal information that you voluntarily provide to us when you register on the [app/service], express an interest in obtaining information about us or our products and services.',
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      'The personal information that we collect depends on the context of your interactions with us and the [app/service], the choices you make, and the products and features you use.',
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Section 1
                    const Text(
                      '1. Information we collect',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      'The personal information that we collect depends on the context of your interactions with us and the [app/service], the choices you make, and the products and features you use.',
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Section 2
                    const Text(
                      '2. Information use collect',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      'We process your personal information for these purposes in reliance on our legitimate business interests, in order to enter into or perform a contract with you.',
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Accept Terms Checkbox
                    InkWell(
                      onTap: () {
                        setDialogState(() {
                          privacyAccepted = !privacyAccepted;
                        });
                      },
                      child: Row(
                        children: [
                          Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: privacyAccepted ? const Color(0xFF9CCCA9) : Colors.white,
                              border: Border.all(
                                color: const Color(0xFF9CCCA9),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: privacyAccepted
                                ? const Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.white,
                            )
                                : null,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Accept terms & conditions',
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Next Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: privacyAccepted
                            ? () {
                          Navigator.of(context).pop();
                          _handleGetStarted(context, language);
                        }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF9CCCA9),
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey.shade300,
                          disabledForegroundColor: Colors.grey.shade500,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Next',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _handleGetStarted(BuildContext context, String language) {
    setState(() {
      termsAccepted = false;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),


                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: const BoxDecoration(

                      ),
                      child: const Text(
                        'Terms & Condition',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    // Scrollable Content
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome to Services App I',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700,
                              ),
                            ),

                            const SizedBox(height: 12),

                            Text(
                              'Accessing or using our services, you agree to be bound by these Terms of Service. If you do not agree with any part of the terms, you must not use our services.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade800,
                                height: 1.6,
                              ),
                            ),



                            const SizedBox(height: 24),

                            const Text(
                              '2. User Responsibilities',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              'As a user, you agree to:',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade800,
                              ),
                            ),

                            const SizedBox(height: 12),

                            _buildBulletPoint('Use the service only for lawful purposes.'),
                            _buildBulletPoint('Provide accurate and complete information when required.'),
                            _buildBulletPoint('Maintain the confidentiality of your account password.'),

                            const SizedBox(height: 24),

                            const Text(
                              '3. Intellectual Property',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              'All content, trademarks, and data on this service, including but not limited to text, graphics, logos, and images, are the property of [Your Company Name]',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade800,
                                height: 1.6,
                              ),
                            ),

                            const SizedBox(height: 24),

                            const Text(
                              '4. Disclaimers',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              'The service is provided on an "as is" and "as available" basis. [Your Company Name] makes no warranties, expressed or implied, regarding the operation.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade800,
                                height: 1.6,
                              ),
                            ),

                            const SizedBox(height: 24),

                            InkWell(
                              onTap: () {
                                setDialogState(() {
                                  termsAccepted = !termsAccepted;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(16),

                                child: Row(
                                  children: [
                                    Container(
                                      width: 16,
                                      height: 16,
                                      decoration: BoxDecoration(
                                        color: termsAccepted ? const Color(0xFF9CCCA9) : Colors.white,
                                        border: Border.all(
                                          color: const Color(0xFF9CCCA9),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: termsAccepted
                                          ? const Icon(
                                        Icons.check,
                                        size: 14,
                                        color: Colors.white,
                                      )
                                          : null,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Accept terms & conditions',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Next Button
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Color(0xFFE5E7EB),
                            width: 1,
                          ),
                        ),
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: termsAccepted
                              ? () {
                            Navigator.of(context).pop();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const WelcomeScreen(),
                              ),
                            );
                          }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF9CCCA9),
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: Colors.grey.shade300,
                            disabledForegroundColor: Colors.grey.shade500,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Next',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

            );
          },
        );
      },
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 7, right: 10),
            child: Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade600,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade800,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}