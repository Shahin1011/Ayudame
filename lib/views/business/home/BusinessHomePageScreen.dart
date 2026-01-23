import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:middle_ware/core/theme/app_colors.dart';
import 'package:middle_ware/views/business/employee/all_employee.dart';
import '../../../core/app_icons.dart';
import 'BusinessNotificationPage.dart';
import '../../../widgets/provider_ui_card.dart';
import '../../../viewmodels/business_auth_viewmodel.dart';
import '../../../viewmodels/business_employee_viewmodel.dart';
import '../../../viewmodels/business_booking_viewmodel.dart';
import '../../../viewmodels/business_appointment_viewmodel.dart';
import '../../../core/routes/app_routes.dart';

class BusinessHomePageScreen extends StatefulWidget {
  const BusinessHomePageScreen({super.key});

  @override
  State<BusinessHomePageScreen> createState() => _BusinessHomePageScreenState();
}

class _BusinessHomePageScreenState extends State<BusinessHomePageScreen> {
  final BusinessAuthViewModel _viewModel = Get.put(BusinessAuthViewModel());
  final BusinessEmployeeViewModel _employeeViewModel = Get.put(
    BusinessEmployeeViewModel(),
  );
  final BusinessBookingViewModel _bookingViewModel = Get.put(
    BusinessBookingViewModel(),
  );
  final BusinessAppointmentViewModel _appointmentViewModel = Get.put(
    BusinessAppointmentViewModel(),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.getStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: AppColors.mainAppColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          flexibleSpace: Padding(
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 16),
            child: Obx(() {
              final business = _viewModel.currentBusiness.value;
              return Row(
                children: [
                  Container(
                    height: 51,
                    width: 51,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFD4B896),
                      image: DecorationImage(
                        image:
                            business?.logo != null && business!.logo!.isNotEmpty
                            ? NetworkImage(business.logo!)
                            : const AssetImage('assets/images/men.png')
                                  as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Welcome Back',
                          style: TextStyle(
                            fontFamily: "Inter",
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          business?.ownerName ?? 'Owner',
                          style: const TextStyle(
                            fontFamily: "Inter",
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BusinessNotificationPage(),
                        ),
                      );
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(5),
                      child: SvgPicture.asset(
                        AppIcons.notification,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF2D6A4F),
                          BlendMode.srcIn,
                        ),
                        width: 30,
                        height: 30,
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Cards Section Background
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF1C5941),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.r),
                  bottomRight: Radius.circular(20.r),
                ),
              ),
              padding: EdgeInsets.fromLTRB(
                16.w,
                kToolbarHeight + 75.h,
                16.w,
                24.h,
              ),
              child: Obx(() {
                final stats = _viewModel.stats.value;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            iconBgColor: const Color(0xFFFF8A8A),
                            iconPath: 'assets/icons/booking.svg',
                            iconColor: AppColors.white,
                            value: stats?['totalBookings']?.toString() ?? '0',
                            label: 'Total Booking',
                            percentage:
                                '+${stats?['growth']?['totalBookings']?.toString() ?? '0'}%',
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _buildStatCard(
                            iconBgColor: const Color(0xFFF07914),
                            iconPath: 'assets/icons/income.svg',
                            iconColor: AppColors.white,
                            value:
                                '\$${stats?['totalIncome']?.toString() ?? '0'}',
                            label: 'Total Income',
                            percentage:
                                '+${stats?['growth']?['totalIncome']?.toString() ?? '0'}%',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            iconBgColor: const Color(0xFF22C55E),
                            // Green
                            iconPath: 'assets/icons/user.svg',
                            iconColor: AppColors.white,
                            value:
                                stats?['totalEmployeesActive']?.toString() ??
                                '0',
                            label: 'Total Employee',
                            percentage:
                                '+${stats?['growth']?['totalEmployeesActive']?.toString() ?? '0'}%',
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _buildStatCard(
                            iconBgColor: const Color(0xFFA855F7),
                            iconPath: 'assets/icons/order.svg',
                            iconColor: AppColors.white,
                            value:
                                stats?['totalActiveOrders']?.toString() ?? '0',
                            label: 'Active Orders',
                            percentage:
                                '+${stats?['growth']?['totalActiveOrders']?.toString() ?? '0'}%',
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
            ),

            SizedBox(height: 16.h),

            // Search Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: TextField(
                  onChanged: (val) {
                    _employeeViewModel.searchEmployees(val);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search Employee...',
                    hintStyle: TextStyle(
                      color: AppColors.grey,
                      fontSize: 14.sp,
                    ),
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(12.w),
                      child: SvgPicture.asset(
                        'assets/icons/search-01.svg',
                        color: AppColors.grey,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.r),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.r),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.r),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 1.5,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // All Employee Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Employee',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.to(() => BusinessEmployeeListScreen());
                    },
                    child: Text(
                      'View All',
                      style: TextStyle(
                        color: const Color(0xFF1C5941),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Employee List (Search Results or All)
            Obx(() {
              final bool isSearchActive =
                  _employeeViewModel.isSearchActive.value;
              final bool isLoading = _employeeViewModel.isSearching.value;

              if (isLoading) {
                return Padding(
                  padding: EdgeInsets.only(top: 16.h),
                  child: const Center(child: CircularProgressIndicator()),
                );
              }

              // If user is searching (typed something)
              if (isSearchActive) {
                if (_employeeViewModel.searchResults.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.only(top: 16.h),
                    child: Center(
                      child: Text(
                        "No employees found matching your search.",
                        style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                      ),
                    ),
                  );
                }
                return _buildEmployeeList(_employeeViewModel.searchResults);
              }

              // Default state: Show only one employee card
              if (_employeeViewModel.employeeList.isEmpty) {
                return Padding(
                  padding: EdgeInsets.only(top: 20.h),
                  child: Center(
                    child: Text(
                      "No employees added.",
                      style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                    ),
                  ),
                );
              }
              // Show only the first employee on the home page
              return _buildEmployeeList([
                _employeeViewModel.employeeList.first,
              ]);
            }),
            SizedBox(height: 40.h),
            // All Providers Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'My Bookings',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'View All',
                      style: TextStyle(
                        color: AppColors.mainAppColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // My Bookings Section
            Obx(() {
              if (_bookingViewModel.isLoading.value) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (_bookingViewModel.bookingList.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(child: Text('No bookings found.')),
                );
              }

              return Column(
                children: _bookingViewModel.bookingList.map((booking) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildProviderCard(
                      name: booking.customerName ?? 'Unknown',
                      address: booking.address ?? 'No address provided',
                      date: booking.date ?? 'No date',
                      problemNote: booking.problemNote ?? 'No notes available.',
                      totalPrice: booking.totalPrice?.toInt(),
                      downPayment: booking.downPayment?.toInt(),
                      status: booking.status,
                      showReschedule:
                          false, // Defaulting to false as requested for 1st part
                      onTap: () {
                        if (booking.id != null) {
                          debugPrint('👆 Tapped Accept Booking: ${booking.id}');
                          _bookingViewModel.acceptBooking(booking.id!);
                        } else {
                          debugPrint('❌ Error: Booking ID is null');
                          Get.snackbar("Error", "Invalid Booking ID");
                        }
                      },
                      onReject: () {
                        if (booking.id != null) {
                          debugPrint('👆 Tapped Reject Booking: ${booking.id}');
                          _bookingViewModel.rejectBooking(booking.id!);
                        } else {
                          debugPrint('❌ Error: Booking ID is null');
                          Get.snackbar("Error", "Invalid Booking ID");
                        }
                      },
                    ),
                  );
                }).toList(),
              );
            }),

            const SizedBox(height: 24),
            // My Appointments Section (Reschedule variant)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'My Appointments',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Get.toNamed(AppRoutes.userAppointments);
                    },
                    child: const Text(
                      'View All',
                      style: TextStyle(
                        color: AppColors.mainAppColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Obx(() {
              if (_appointmentViewModel.isLoading.value) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (_appointmentViewModel.appointmentList.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(child: Text('No appointments found.')),
                );
              }

              return Column(
                children: _appointmentViewModel.appointmentList.map((
                  appointment,
                ) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildProviderCard(
                      name: appointment.customerName ?? 'Unknown',
                      address: appointment.address ?? 'No address provided',
                      date: appointment.date ?? 'No date',
                      problemNote:
                          appointment.problemNote ?? 'No notes available.',
                      totalPrice: appointment.totalPrice?.toInt(),
                      downPayment: appointment.downPayment?.toInt(),
                      status: appointment.status,
                      showReschedule: true,
                      onTap: () {
                        if (appointment.id != null) {
                          _appointmentViewModel.acceptAppointment(
                            appointment.id!,
                          );
                        }
                      },
                      onReject: () {
                        if (appointment.id != null) {
                          _appointmentViewModel.rejectAppointment(
                            appointment.id!,
                          );
                        }
                      },
                      onReschedule: () {
                        if (appointment.id != null) {
                          _showRescheduleDialog(appointment.id!);
                        }
                      },
                    ),
                  );
                }).toList(),
              );
            }),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _showRescheduleDialog(String appointmentId) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1C5941),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Color(0xFF1C5941),
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        // Format Date: YYYY-MM-DD
        String formattedDate =
            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";

        // Format Time: HH:mm
        String formattedTime =
            "${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}";

        _appointmentViewModel.rescheduleAppointment(
          appointmentId,
          formattedDate,
          formattedTime,
        );
      }
    }
  }

  Widget _buildEmployeeList(List<dynamic> list) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final employee = list[index];
        return GestureDetector(
          onTap: () {
            // Navigate to detail screen, passing the employee object
            Get.toNamed(AppRoutes.businessEmployee, arguments: employee);
          },
          child: ProviderUICard(
            borderRadius: 12,
            margin: EdgeInsets.zero,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            imageUrl:
                (employee.servicePhoto != null &&
                    employee.servicePhoto!.isNotEmpty)
                ? employee.servicePhoto!
                : 'assets/images/men_cleaning.jpg',
            profileUrl:
                (employee.profilePicture != null &&
                    employee.profilePicture!.isNotEmpty)
                ? employee.profilePicture!
                : 'assets/images/profile.png',
            name: employee.name ?? 'Unknown',
            location: 'Dhanmondi, Dhaka', // Static or add to model
            postedTime: employee.availableTime ?? 'Available',
            serviceTitle:
                employee.headline ??
                employee.serviceCategory ??
                'Service Provider',
            description: employee.about ?? 'No description available.',
            rating: 4.5, // Static or add to model
            reviewCount: 120, // Static
            price:
                '\$${employee.pricing}', // Using getter that returns non-null string
            showOnlineIndicator: true,
            onViewDetails: () {
              Get.toNamed(AppRoutes.businessEmployee, arguments: employee);
            },
          ),
        );
      },
    );
  }
}

Widget _buildStatCard({
  required Color iconBgColor,

  required String iconPath,
  required Color iconColor,
  required String value,
  required String label,
  required String percentage,
}) {
  return Container(
    padding: EdgeInsets.all(16.w),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(25.r),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: SvgPicture.asset(
                iconPath,
                color: iconColor,
                width: 20.w,
                height: 20.h,
              ),
            ),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                percentage,
                style: TextStyle(
                  color: const Color(0xFF2E7D32),
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),

        Text(
          value,
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
      ],
    ),
  );
}

Widget _buildProviderCard({
  required String name,

  required String address,
  required String date,
  required String problemNote,
  int? price,
  int? totalPrice,
  int? downPayment,
  String? status,
  required bool showReschedule,
  VoidCallback? onTap,
  VoidCallback? onReject,
  VoidCallback? onReschedule,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    padding: const EdgeInsets.all(14),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Provider Info
        Row(
          children: [
            const CircleAvatar(
              radius: 20,
              backgroundColor: Color(0xFFFFE4CC),
              backgroundImage: AssetImage('assets/images/provider_avatar.png'),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontFamily: "Inter",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const Text(
              '12:25 pm',
              style: TextStyle(
                fontFamily: "Inter",
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Color(0xFF666666),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Address
        RichText(
          text: TextSpan(
            children: [
              const TextSpan(
                text: 'Address: ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  fontFamily: "Inter",
                ),
              ),
              TextSpan(
                text: address,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF666666),
                  fontFamily: "Inter",
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        // Date
        RichText(
          text: TextSpan(
            children: [
              const TextSpan(
                text: 'Date: ',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  fontFamily: "Inter",
                ),
              ),
              TextSpan(
                text: date,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF666666),
                  fontFamily: "Inter",
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // Problem Note
        const Text(
          'Problem Note:',
          style: TextStyle(
            fontFamily: "Inter",
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          problemNote,
          style: const TextStyle(
            fontFamily: "Inter",
            fontSize: 12,
            color: Color(0xFF666666),
            height: 1.4,
          ),
        ),
        const SizedBox(height: 12),
        // Price Info
        if (totalPrice != null && downPayment != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Price: \$$totalPrice',
                style: const TextStyle(
                  fontFamily: "Inter",
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1C5941),
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Down payment: ',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1C5941),
                        fontFamily: "Inter",
                      ),
                    ),
                    TextSpan(
                      text: '\$$downPayment',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1C5941),
                        fontFamily: "Inter",
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ] else if (price != null) ...[
          Text(
            'Price: \$$price',
            style: const TextStyle(
              fontFamily: "Inter",
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1C5941),
            ),
          ),
        ],
        const SizedBox(height: 12),
        if (status?.toLowerCase() == 'cancelled' ||
            status?.toLowerCase() == 'rejected')
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFE74C3C).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFE74C3C)),
            ),
            child: const Center(
              child: Text(
                'Cancelled',
                style: TextStyle(
                  fontFamily: "Inter",
                  color: Color(0xFFE74C3C),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          )
        else if (status?.toLowerCase() == 'accepted' ||
            status?.toLowerCase() == 'confirmed' ||
            status?.toLowerCase() == 'completed')
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF1C5941).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFF1C5941)),
            ),
            child: const Center(
              child: Text(
                'Accepted',
                style: TextStyle(
                  fontFamily: "Inter",
                  color: Color(0xFF1C5941),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          )
        else if (showReschedule)
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onReschedule ?? () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF1C5941)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: const Text(
                        'Reschedule',
                        style: TextStyle(
                          fontFamily: "Inter",
                          color: Color(0xFF1C5941),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onTap ?? () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1C5941),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Accept',
                        style: TextStyle(
                          fontFamily: "Inter",
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  onPressed: onReject ?? () {},
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontFamily: "Inter",
                      color: Color(0xFFE74C3C),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          )
        else
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onReject ?? () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFE74C3C)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontFamily: "Inter",
                      color: Color(0xFFE74C3C),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: onTap ?? () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1C5941),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Accept',
                    style: TextStyle(
                      fontFamily: "Inter",
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),
      ],
    ),
  );
}
