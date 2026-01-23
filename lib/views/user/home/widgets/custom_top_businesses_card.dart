import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


class CustomTopbusinessesCard extends StatelessWidget {
  final String title;
  final String review;
  final String location;
  final int numberEmployees;
  final int numberOfServices;

  final String? businessPhoto;
  final String? businessOwnerId;
  final VoidCallback? onTap;

  const CustomTopbusinessesCard({
    Key? key,
    required this.title,
    required this.review,
    required this.location,
    required this.numberEmployees,
    required this.numberOfServices,
    this.businessPhoto,
    this.businessOwnerId,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.h),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: InkWell(
        onTap: onTap ?? () {
          if (businessOwnerId != null) {
            Get.toNamed('/BusinessDetailsScreen', arguments: businessOwnerId);
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius:
                    const BorderRadius.all(Radius.circular(12)),
                    child: (businessPhoto != null && businessPhoto!.isNotEmpty)
                      ? Image.network(
                          businessPhoto!,
                          height: 85.h,
                          width: 85.w,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
                        )
                      : _buildPlaceholder(),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                title,
                                style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(Icons.star, size: 20, color: Colors.amber),
                                SizedBox(width: 2.w),
                                Text(
                                  review,
                                  style: GoogleFonts.inter(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[600]
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 12.h),

                        Row(
                          children: [
                            Icon(Icons.location_on, size: 20, color: Colors.grey[600]),
                            SizedBox(width: 2.w),

                            Expanded(
                              child: Text(
                                location,
                                style: GoogleFonts.inter(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 12.h),
                    
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.people, size: 18, color: Colors.grey[600],),
                                SizedBox(width: 2.w),
                                Text(
                                  '$numberEmployees Employees',
                                  style: GoogleFonts.inter(
                                    fontSize: 12.sp,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SvgPicture.asset("assets/icons/service.svg"),
                                SizedBox(width: 2.w),
                                Text(
                                  '$numberOfServices Services',
                                  style: GoogleFonts.inter(
                                    fontSize: 12.sp,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              )

            ],
          ),
        ),
      ),
    );
  }
  Widget _buildPlaceholder() {
    return Container(
      height: 85.h,
      width: 85.w,
      color: Colors.grey[200],
      child: Icon(Icons.business, size: 40.sp, color: Colors.grey),
    );
  }
}

