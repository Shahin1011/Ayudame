import 'package:flutter/material.dart';



class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F8F4),
      body: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF2D5F4C),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    ),
                    const Expanded(
                      child: Text(
                        'Wishlist',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Wishlist Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildWishlistCard(
                  imagePath: 'https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=400',
                  name: 'Arafat Rahman',
                  location: 'Dhanmondi,Dhaka 1208',
                  description: 'I take care of every corner, deep cleaning every room without leaving your home fresh and perfectly tidy for you.',
                  rating: 4.00,
                  reviews: 100,
                  price: '\$100',
                ),
                const SizedBox(height: 16),
                _buildWishlistCard(
                  imagePath: 'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?w=400',
                  name: 'Jackson Builder',
                  location: 'Dhanmondi,Dhaka 1208',
                  description: 'I take your dog out for regular walks, keeping them active and happy.Every walk is safe, fun, and tailored to your pet\'s needs.',
                  rating: 4.00,
                  reviews: 100,
                  price: '\$100',
                ),
                const SizedBox(height: 16),
                _buildWishlistCard(
                  imagePath: 'https://images.unsplash.com/photo-1584515933487-779824d29309?w=400',
                  name: 'Monica Roy',
                  location: 'Dhanmondi,Dhaka 1208',
                  description: 'I monitor health, give medicines on time, and assist with daily routines. All while making sure they\'re comfortable.',
                  rating: 4.00,
                  reviews: 100,
                  price: '\$250',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistCard({
    required String imagePath,
    required String name,
    required String location,
    required String description,
    required double rating,
    required int reviews,
    required String price,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with close button
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Image.network(
                  imagePath,
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.close, size: 20),
                    padding: const EdgeInsets.all(4),
                    constraints: const BoxConstraints(),
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
                // Profile and Name
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(imagePath),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            location,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Description
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black54,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 12),

                // Rating
                Row(
                  children: [
                    ...List.generate(
                      5,
                          (index) => Icon(
                        index < 4 ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$rating ($reviews)',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Price and Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'From $price',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2D5F4C),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'View Details',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
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