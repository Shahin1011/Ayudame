import 'package:flutter/material.dart';

class BusinessCard extends StatelessWidget {
  final String name;
  final String category;
  final double rating;
  final double distance;
  final String image;

  const BusinessCard({
    super.key,
    required this.name,
    required this.category,
    required this.rating,
    required this.distance,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
              child: Image.asset(
                image,
                width: 44,
                height: 44,
                fit: BoxFit.cover, // or BoxFit.contain
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

          /// Category
          Text(
            category,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[600],
            ),
          ),

          const Spacer(),

          /// Rating + Distance
          Row(
            children: [
              const Icon(Icons.star, size: 16, color: Colors.orange),
              const SizedBox(width: 4),
              Text(
                rating.toString(),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              const Icon(Icons.location_on,
                  size: 16, color: Colors.green),
              const SizedBox(width: 4),
              Text(
                '$distance Km',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
