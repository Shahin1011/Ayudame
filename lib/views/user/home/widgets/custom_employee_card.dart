import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/routes/app_routes.dart';

class CustomEmployeeCard extends StatefulWidget {
  final String providerName;
  final String location;
  final String activeStatus;
  final String serviceTitle;
  final String serviceDescription;
  final String reviews;
  final double? appointmentPrice;
  final double? servicePrice;
  final String? serviceImage;
  final String? providerImage;
  final String? serviceId;
  final String? providerId;
  final bool? appointmentEnabled;

  const CustomEmployeeCard({
    super.key,
    required this.providerName,
    required this.location,
    required this.activeStatus,
    required this.serviceTitle,
    required this.serviceDescription,
    required this.reviews,
    this.appointmentPrice,
    this.servicePrice,
    this.serviceImage,
    this.providerImage,
    this.serviceId,
    this.providerId,
    this.appointmentEnabled,
  });

  @override
  State<CustomEmployeeCard> createState() => _CustomEmployeeCardState();
}

class _CustomEmployeeCardState extends State<CustomEmployeeCard> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Service Image
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: (widget.serviceImage != null && widget.serviceImage!.isNotEmpty)
                    ? Image.network(
                        widget.serviceImage!,
                        height: 180.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => _buildImagePlaceholder(),
                      )
                    : _buildImagePlaceholder(),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: GestureDetector(
                  onTap: () {
                    setState(() => _isFavorite = !_isFavorite);
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorite ? Colors.red : Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Provider Info
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24.r,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: (widget.providerImage != null && widget.providerImage!.isNotEmpty)
                          ? NetworkImage(widget.providerImage!)
                          : null,
                      child: (widget.providerImage == null || widget.providerImage!.isEmpty)
                          ? Icon(Icons.person, color: Colors.grey, size: 24.sp)
                          : null,
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.providerName,
                            style: GoogleFonts.inter(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(Icons.location_on, size: 14.sp, color: Colors.grey),
                              SizedBox(width: 4.w),
                              Expanded(
                                child: Text(
                                  widget.location,
                                  style: GoogleFonts.inter(
                                    fontSize: 12.sp,
                                    color: Colors.grey,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12.h),

                /// Service Details
                Text(
                  widget.serviceTitle,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  widget.serviceDescription,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: 12.h),

                /// Rating & Price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16.sp),
                        SizedBox(width: 4.w),
                        Text(
                          widget.reviews,
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Column(
                       crossAxisAlignment: CrossAxisAlignment.end,
                       children: [
                         if (widget.appointmentEnabled == true && widget.appointmentPrice != null)
                           Text(
                             'Appointment: \$${widget.appointmentPrice}',
                             style: GoogleFonts.inter(
                               fontSize: 12.sp,
                               fontWeight: FontWeight.w600,
                               color: const Color(0xFF1B5E4E),
                             ),
                           ),
                         if (widget.servicePrice != null)
                           Text(
                             'Service: \$${widget.servicePrice}',
                             style: GoogleFonts.inter(
                               fontSize: 12.sp,
                               fontWeight: FontWeight.w600,
                               color: const Color(0xFF1B5E4E),
                             ),
                           ),
                       ],
                    )
                  ],
                ),

                SizedBox(height: 16.h),

                /// View Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.toNamed(AppRoutes.employeeServiceDetails, arguments: {
                        'serviceId': widget.serviceId,
                        'providerId': widget.providerId,
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B5E4E),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      "View Details",
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      height: 180.h,
      width: double.infinity,
      color: Colors.grey[200],
      child: Icon(Icons.image, size: 40.sp, color: Colors.grey),
    );
  }
}
