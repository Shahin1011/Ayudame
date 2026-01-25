import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/routes/app_routes.dart';

class CustomProviderCard extends StatefulWidget {
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

  const CustomProviderCard({
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
  State<CustomProviderCard> createState() => _CustomProviderCardState();
}

class _CustomProviderCardState extends State<CustomProviderCard> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: (widget.serviceImage != null && widget.serviceImage!.isNotEmpty)
                      ? Image.network(
                          widget.serviceImage!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
                        )
                      : _buildPlaceholder(),
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

            /// Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25.r,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: (widget.providerImage != null && widget.providerImage!.isNotEmpty)
                            ? NetworkImage(widget.providerImage!)
                            : null,
                        child: (widget.providerImage == null || widget.providerImage!.isEmpty)
                            ? Icon(Icons.person, color: Colors.grey, size: 25.sp)
                            : null,
                      ),
                      SizedBox(width: 10.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.providerName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.location_on,
                                  size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                widget.location,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 8.h),

                  /// Service Title
                  Text(
                    widget.serviceTitle,
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(height: 6.h),

                  /// Description
                  Text(
                    widget.serviceDescription,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),

                  SizedBox(height: 12.h),

                  /// Rating
                  Row(
                    children: [
                      ...List.generate(
                        4,
                            (_) => const Icon(Icons.star,
                            size: 18, color: Colors.amber),
                      ),
                      const Icon(Icons.star_half,
                          size: 18, color: Colors.amber),
                      const SizedBox(width: 6),
                      Text(
                        widget.reviews,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  /// Price + Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.appointmentEnabled == true)
                            Text(
                              'Appointment Price: \$${widget.appointmentPrice ?? 0}',
                              style: GoogleFonts.inter(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1B5E4E),
                              ),
                            )
                          else
                            Text(
                              'Service Price: \$${widget.servicePrice ?? 0}',
                              style: GoogleFonts.inter(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1B5E4E),
                              ),
                            ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Get.toNamed(AppRoutes.providerServiceDetailsScreen, arguments: {
                            'serviceId': widget.serviceId,
                            'providerId': widget.providerId,
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2D6A4F),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const AppText(text: "View Details"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: 200,
      width: double.infinity,
      color: Colors.grey[200],
      child: Icon(Icons.image, size: 50.sp, color: Colors.grey),
    );
  }
}

class AppText extends StatelessWidget {
  final String text;
  const AppText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return const Text(
      "View Details",
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
    );
  }
}
