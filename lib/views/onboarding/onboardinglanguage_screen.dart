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
              const Text(
                'Select your comfortable language',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.050),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: _buildLanguageCard(
                      context: context,
                      language: 'English',
                      flag: '🇺🇸',
                      imagePath: 'assets/images/uk.png',
                      cardColor: AppColors.mainAppColor,
                      textColor: Colors.white,
                      onTap: () => _handleLanguageSelection(context, 'English'),
                    ),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                  Flexible(
                    child: _buildLanguageCard(
                      context: context,
                      language: 'Spanish',
                      flag: '🇪🇸',
                      imagePath: 'assets/images/spain.png',
                      cardColor: Colors.white,
                      textColor: Colors.black,
                      onTap: () => _handleLanguageSelection(context, 'Spanish'),
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
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.mainAppColor, width: 2),
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
            Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: ClipOval(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Text(flag, style: const TextStyle(fontSize: 20)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              language,
              style: TextStyle(fontWeight: FontWeight.w500, color: textColor, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  // ল্যাঙ্গুয়েজ সিলেক্ট করলে ডাটা রিসেট হবে এবং ডায়ালগ ওপেন হবে
  void _handleLanguageSelection(BuildContext context, String language) {
    setState(() {
      privacyAccepted = false;
      termsAccepted = false;
    });
    // এখানে language পাস করা হয়েছে যা আগে মিসিং ছিল
    _showPrivacyPolicyDialog(context, language);
  }

  // ১. Privacy & Policy Dialog
  void _showPrivacyPolicyDialog(BuildContext context, String language) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Privacy & Policy', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.black),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Last updated on 23 August 2025', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                    const SizedBox(height: 20),
                    _buildBodyText('We collect personal information that you voluntarily provide to us when you register on the Services App, express an interest in obtaining information about us or our products and services.'),
                    const SizedBox(height: 15),
                    _buildBodyText('The personal information that we collect depends on the context of your interactions with us and the Services App.'),
                    const SizedBox(height: 20),
                    _buildSectionTitle('1. Information we collect'),
                    _buildBodyText('The personal information that we collect depends on the context of your interactions with us and the choices you make.'),
                    const SizedBox(height: 20),
                    _buildSectionTitle('2. Information use collect'),
                    _buildBodyText('We process your personal information for these purposes in reliance on our legitimate business interests.'),
                    const SizedBox(height: 25),
                    _buildCheckbox('Accept privacy & policy', privacyAccepted, (val) {
                      setDialogState(() => privacyAccepted = !privacyAccepted);
                    }),
                    const SizedBox(height: 20),
                    _buildNextButton(privacyAccepted, () {
                      Navigator.pop(context);
                      _showTermsAndConditionsDialog(context);
                    }),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ২. Terms & Condition Dialog
  void _showTermsAndConditionsDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Terms & Condition', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.black),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildSectionTitle('1. Welcome to Services App !'),
                    _buildBodyText('Accessing or using our services, you agree to be bound by these Terms of Service. If you do not agree, you must not use our services.'),
                    const SizedBox(height: 20),
                    _buildSectionTitle('2. User Responsibilities'),
                    _buildBodyText('As a user, you agree to:'),
                    _buildBulletPoint('Use the service only for lawful purposes.'),
                    _buildBulletPoint('Provide accurate and complete information.'),
                    _buildBulletPoint('Maintain confidentiality of your account.'),
                    const SizedBox(height: 20),
                    _buildSectionTitle('3. Intellectual Property'),
                    _buildBodyText('All content, trademarks, and data are property of Services App.'),
                    const SizedBox(height: 20),
                    _buildSectionTitle('4. Disclaimers'),
                    _buildBodyText('The service is provided on an "as is" and "as available" basis.'),
                    const SizedBox(height: 25),
                    _buildCheckbox('Accept terms & conditions', termsAccepted, (val) {
                      setDialogState(() => termsAccepted = !termsAccepted);
                    }),
                    const SizedBox(height: 20),
                    _buildNextButton(termsAccepted, () {
                      Navigator.pop(context);
                      // WelcomeScreen এ নেভিগেট করার কোড
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const WelcomeScreen()));
                    }),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // সাহায্যকারী উইজেটসমূহ
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black)),
    );
  }

  Widget _buildBodyText(String text) {
    return Text(text, style: TextStyle(color: Colors.grey.shade800, fontSize: 14, height: 1.5));
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(padding: EdgeInsets.only(top: 6, right: 8), child: Icon(Icons.circle, size: 6, color: Colors.black54)),
          Expanded(child: _buildBodyText(text)),
        ],
      ),
    );
  }

  Widget _buildCheckbox(String label, bool value, Function(bool?) onChanged) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: value ? AppColors.mainAppColor : Colors.white,
              border: Border.all(color: AppColors.mainAppColor, width: 2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: value ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
          ),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildNextButton(bool isEnabled, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: isEnabled ? onPressed : null,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: isEnabled ? AppColors.mainAppColor : Colors.grey.shade300, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Colors.white,
          foregroundColor: AppColors.mainAppColor,
          disabledForegroundColor: Colors.grey.shade500,
        ),
        child: const Text('Next', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}