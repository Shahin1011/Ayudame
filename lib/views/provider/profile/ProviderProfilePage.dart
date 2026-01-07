import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:middle_ware/core/app_icons.dart';
import 'package:middle_ware/core/theme/app_colors.dart';
import 'package:middle_ware/views/provider/orders/OrderProvider.dart';
import 'package:middle_ware/views/provider/profile/ProviderHelpSupportScreen.dart';
import 'package:middle_ware/views/provider/profile/ProviderNotificationPage.dart';
import 'package:middle_ware/views/provider/profile/ProviderPortfolioPage.dart';
import 'package:middle_ware/views/provider/profile/ProviderPrivacyPolicyScreen.dart';
import 'package:middle_ware/views/provider/profile/ProviderTermsConditionScreen.dart';
import 'package:middle_ware/views/provider/profile/all_service.dart';
import 'package:middle_ware/views/provider/profile/provider_bank_information.dart';
import 'package:middle_ware/views/provider/profile/provider_edit_profile.dart';
import 'package:middle_ware/views/provider/profile/provider_history.dart';
import 'package:middle_ware/views/provider/profile/provider_payment.dart';
import 'package:middle_ware/widgets/custom_appbar.dart';

class ProviderProfilePage extends StatefulWidget {
  const ProviderProfilePage({Key? key}) : super(key: key);

  @override
  State<ProviderProfilePage> createState() => _ProviderProfilePageState();
}

class _ProviderProfilePageState extends State<ProviderProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Profile",
        actions: [
          IconButton(
            onPressed: () {
              // Navigator.pushNamed(context, '/edit/profile');
            },
            icon: SvgPicture.asset(
              AppIcons.profileIcon,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.bgColor,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 24),

                  // Profile Picture and Name
                  Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage(
                            "assets/images/profile.png",
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'Seam Rahman',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 4),

                  const Text(
                    'seamr7845@gmail.com',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Inter",
                    ),
                  ),

                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        // --- My Order Card ---
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8F9F8),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      AppIcons.my_order,
                                      width: 20,
                                      height: 20,
                                      colorFilter: ColorFilter.mode(
                                        Colors.grey.shade700,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'My Order',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade700,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                IntrinsicHeight(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      // This Month Section
                                      Column(
                                        children: [
                                          Text(
                                            'This Month',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                          const Text(
                                            '05',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Vertical Divider
                                      VerticalDivider(
                                        color: Colors.grey.shade400,
                                        thickness: 1,
                                      ),
                                      // Total Section
                                      Column(
                                        children: [
                                          Text(
                                            'Total',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                          const Text(
                                            '442',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // --- Total Income Card ---
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            height: 105,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8F9F8),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      AppIcons.total_income,
                                      width: 20,
                                      height: 20,
                                      colorFilter: ColorFilter.mode(
                                        Colors.grey.shade700,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Total Income',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade700,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  '\$2000',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Account Information Section
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
                          child: Text(
                            'Account Information',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        _buildMenuItem(
                          iconPath: AppIcons.profileIcon,
                          title: 'Edit Profile',
                          onTap: () {
                        Get.to (() => const ProviderEditProfileScreen());
                          },
                        ),
                        _buildMenuItem(
                          iconPath: AppIcons.all_service,
                          title: 'All Services',
                          onTap: () {
                           Get.to (()=> allCreateServicePage());
                          },
                        ),
                        _buildMenuItem(
                          iconPath: AppIcons.oder_history,
                          title: 'Order History',
                          onTap: () {
                           Get.to (()=> ProviderHistoryProviderScreen());
                          },
                        ),
                        _buildMenuItem(
                          iconPath: AppIcons.portfolio,
                          title: 'Portfolio',
                          onTap: () {
                            // Get.to(() => PortfolioPage());
                                  Get.to(() => PortfolioListScreen());
                          },
                        ),
                        _buildMenuItem(
                          iconPath: AppIcons.payment,
                          title: 'Payment History',
                          onTap: () {
                            Get.to(() => const provider_PaymentHistoryScreen());


                          },
                        ),
                        _buildMenuItem(
                          iconPath: AppIcons.bank,
                          title: 'Bank Information',
                          onTap: () {
                            Get.to(() => BankInformationScreen());
                          },
                          showDivider: false,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Policy Center Section
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
                          child: Text(
                            'Policy Center',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        _buildMenuItem(
                          iconPath: AppIcons.privacy,
                          title: 'Privacy Policy',
                          onTap: () {
                           Get.to (()=> const ProviderPrivacyPolicyScreen());
                          },
                        ),
                        _buildMenuItem(
                          iconPath: AppIcons.terms,
                          title: 'Terms & Condition',
                          onTap: () {
                        Get.to (()=> const ProviderTermsConditionScreen());
                          },
                          showDivider: false,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Settings Section
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
                          child: Text(
                            'Settings',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        _buildMenuItem(
                          iconPath: AppIcons.notification,
                          title: 'Notification',
                          onTap: () {
                       Get.to  (()=> const ProviderNotificationPage());
                          },
                        ),
                        _buildMenuItem(
                          iconPath: AppIcons.help,
                          title: 'Help & Support',
                          onTap: () {
                           Get.to (()=> ProviderHelpSupportScreen());
                          },
                        ),
                        _buildMenuItem(
                          iconPath: AppIcons.logout,
                          title: 'Log Out',
                          onTap: _showLogoutDialog,
                        ),
                        _buildMenuItem(
                          iconPath: AppIcons.delete,
                          title: 'Delete Account',
                          onTap: () {
                            _showDeleteAccountDialog(context);
                          },
                          isDestructive: true,
                          showDivider: false,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    AppIcons.logout,
                    width: 32,
                    height: 32,
                    colorFilter: ColorFilter.mode(
                      Colors.orange.shade400,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Log Out',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Are you sure you want to log out?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          // Add your logout logic here
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Logged out successfully'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Log Out',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    AppIcons.delete,
                    width: 32,
                    height: 32,
                    colorFilter: ColorFilter.mode(
                      Colors.red.shade400,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Delete Account',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Are you sure to delete this account? This action cannot be undone.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Account deleted successfully'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Yes, Delete',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuItem({
    required String iconPath,
    required String title,
    required VoidCallback onTap,
    bool showDivider = true,
    bool isDestructive = false,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                SvgPicture.asset(
                  iconPath,
                  width: 22,
                  height: 22,
                  colorFilter: ColorFilter.mode(
                    isDestructive ? Colors.red : Colors.black54,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontFamily: "Inter",
                      fontSize: 14,
                      color: isDestructive ? Colors.red : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SvgPicture.asset(
                  AppIcons.arrow_right,
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    isDestructive ? Colors.red : Colors.black38,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
