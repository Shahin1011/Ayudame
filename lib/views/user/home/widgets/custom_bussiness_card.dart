import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import '../../../../core/routes/app_routes.dart';

class BusinessCard extends StatelessWidget {
  final String name;
  final String category;
  final double distance;
  final String categoryId;
  final String image;

  const BusinessCard({
    super.key,
    required this.name,
    required this.categoryId,
    required this.category,
    required this.distance,
    this.showDistance = true,
    required this.image,
  });

  final bool showDistance;

  @override
  Widget build(BuildContext context) {
    // Check if image is a URL or asset path
    bool isNetworkImage = image.startsWith('http://') || image.startsWith('https://');

    return GestureDetector(
      onTap: (){
        Get.toNamed(
          AppRoutes.nearYouProvidersScreen, 
          arguments: {
            'categoryId': categoryId,
            'categoryName': name
          }
        );
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color(0xFFEAEFE9), width: 1.5),

        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: image.isEmpty
                    ? Container(
                        width: 55,
                        height: 55,
                        color: Colors.grey[200],
                        child: Icon(Icons.category, color: Colors.grey[400]),
                      )
                    : isNetworkImage
                        ? CachedNetworkImage(
                            imageUrl: image,
                            width: 55,
                            height: 55,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              width: 55,
                              height: 55,
                              color: Colors.grey[200],
                              child: Icon(Icons.image, color: Colors.grey[400]),
                            ),
                            errorWidget: (context, url, error) => Container(
                              width: 55,
                              height: 55,
                              color: Colors.grey[200],
                              child: Icon(Icons.category, color: Colors.grey[400]),
                            ),
                          )
                        : Image.asset(
                            image,
                            width: 55,
                            height: 55,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: 55,
                              height: 55,
                              color: Colors.grey[200],
                              child: Icon(Icons.category, color: Colors.grey[400]),
                            ),
                          ),
              ),
            ),


            SizedBox(height: 12),

            /// Name
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 4),

            /// Provider Count
            Text(
              category,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 24),

            /// Distance
            if (showDistance)
              Row(
                children: [
                  const Icon(Icons.location_on,
                      size: 16, color: Colors.green),
                  const SizedBox(width: 4),
                  Text(
                    '${distance.toStringAsFixed(1)} Km',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
