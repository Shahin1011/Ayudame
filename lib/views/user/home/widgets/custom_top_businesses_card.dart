import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';


class CustomTopbusinessesCard extends StatelessWidget {
  final String title;
  final String review;
  final String location;
  final int numberEmployees;
  final int numberOfServices;

  const CustomTopbusinessesCard({
    Key? key,
    required this.title,
    required this.review,
    required this.location,
    required this.numberEmployees,
    required this.numberOfServices,
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
        onTap: () {},
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
                    child: Image.network(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTcJtC8sXLqdg1ZzQ6TQ8rljPxBMilyRv7mwQ&s',
                      height: 85.h,
                      width: 85.w,
                      fit: BoxFit.cover,
                    ),
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
                                  fontSize: 16.sp,
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
                                SizedBox(width: 4.w),
                                Text(
                                  review,
                                  style: GoogleFonts.inter(
                                      fontSize: 14.sp,
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
                            SizedBox(width: 8.w),
                            Text(
                              location,
                              style: GoogleFonts.inter(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600]
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
                                SizedBox(width: 5.w),
                                Text(
                                  '$numberEmployees Employees',
                                  style: GoogleFonts.inter(
                                    fontSize: 14.sp,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SvgPicture.asset("assets/icons/service.svg"),
                                SizedBox(width: 5.w),
                                Text(
                                  '$numberOfServices Services',
                                  style: GoogleFonts.inter(
                                    fontSize: 14.sp,
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
}

