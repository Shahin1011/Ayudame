import 'package:flutter/material.dart';

class ProviderUICard extends StatelessWidget {
  final String imageUrl;
  final String profileUrl;
  final String name;
  final String location;
  final String postedTime;
  final String serviceTitle;
  final String description;
  final double rating;
  final int reviewCount;
  final String price;
  final bool showOnlineIndicator;
  final bool showFavorite;
  final VoidCallback onViewDetails;

  final double? borderRadius;
  final EdgeInsets? margin;

  final List<BoxShadow>? boxShadow;

  const ProviderUICard({
    super.key,
    required this.imageUrl,
    required this.profileUrl,
    required this.name,
    required this.location,
    required this.postedTime,
    required this.serviceTitle,
    required this.description,
    required this.rating,
    required this.reviewCount,
    required this.price,
    required this.showOnlineIndicator,
    required this.onViewDetails,
    this.showFavorite = true,
    this.borderRadius,
    this.margin,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius ?? 20),
        boxShadow:
            boxShadow ??
            [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(borderRadius ?? 20),
                ),
                child: imageUrl.startsWith('http')
                    ? Image.network(
                        imageUrl,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset(
                              'assets/images/men_cleaning.jpg',
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                      )
                    : Image.asset(
                        imageUrl,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),
              if (showFavorite)
                const Positioned(
                  top: 15,
                  right: 15,
                  child: CircleAvatar(
                    backgroundColor: Colors.white60,
                    child: Icon(Icons.favorite_border, color: Colors.red),
                  ),
                ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: profileUrl.startsWith('http')
                              ? NetworkImage(profileUrl)
                              : AssetImage(profileUrl) as ImageProvider,
                        ),
                        if (showOnlineIndicator)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: 12,
                              width: 12,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            location,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      postedTime,
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                // টাইটেল এবং ডেসক্রিপশন
                Text(
                  serviceTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 15),

                // রেটিং সেকশন
                Row(
                  children: [
                    ...List.generate(5, (index) {
                      if (index < rating.floor()) {
                        return const Icon(Icons.star, color: Colors.orange, size: 22);
                      } else if (index < rating) {
                         return const Icon(Icons.star_half, color: Colors.orange, size: 22);
                      } else {
                        return const Icon(Icons.star_border, color: Colors.orange, size: 22);
                      }
                    }),
                    const SizedBox(width: 8),
                    Text(
                      rating.toStringAsFixed(2),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      " ($reviewCount)",
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                // প্রাইস এবং বাটন
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          const TextSpan(
                            text: "Appointment Price: ",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: price,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                      ElevatedButton(
                        onPressed: onViewDetails,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                            0xFF1E5631,
                          ), // Dark Green Color
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          minimumSize: Size.zero, // Removes default minimum size constraints
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Removes extra tap target spacing
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "View Details",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
