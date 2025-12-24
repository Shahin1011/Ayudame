import 'package:flutter/material.dart';


class ProvidersScreen extends StatelessWidget {
  const ProvidersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),

      appBar: AppBar(
        backgroundColor: const Color(0xFF1B5E4E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Providers',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(0),
        children: const [
          ProviderCard(
            imageUrl: 'https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=800',
            profileUrl: 'https://images.unsplash.com/photo-1560250097-0b93528c311a?w=100',
            name: 'Jackson Builder',
            location: 'Dhanmondi Dhaka 1209',
            postedTime: '1 day ago',
            description:
            'I take care of every corner, deep cleaning every room withcare,leaving your home fresh and perfectly tidy for you.',
            rating: 4.00,
            reviewCount: 120,
            price: 'From \$100',
            showOnlineIndicator: true,
          ),
          ProviderCard(
            imageUrl: 'https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=800',
            profileUrl: 'https://images.unsplash.com/photo-1560250097-0b93528c311a?w=100',
            name: 'Jackson Builder',
            location: 'Dhanmondi Dhaka 1209',
            postedTime: '1 day ago',
            description:
            'I take care of every corner, deep cleaning every room withcare,leaving your home fresh and perfectly tidy for you.',
            rating: 4.00,
            reviewCount: 120,
            price: 'From \$100',
            showOnlineIndicator: true,
          ),
          ProviderCard(
            imageUrl: 'https://images.unsplash.com/photo-1601758228041-f3b2795255f1?w=800',
            profileUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
            name: 'Jackson Builder',
            location: 'Dhanmondi Dhaka 1209',
            postedTime: '1 day ago',
            description:
            'I take your dog out for regular walks, keeping them active and happy.Every walk is safe, fun, and tailored to your pet\'s needs.',
            rating: 4.00,
            reviewCount: 120,
            price: 'From \$100',
            showOnlineIndicator: false,
          ),
          ProviderCard(
            imageUrl: 'https://images.unsplash.com/photo-1601758228041-f3b2795255f1?w=800',
            profileUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100',
            name: 'Jackson Builder',
            location: 'Dhanmondi Dhaka 1209',
            postedTime: '1 day ago',
            description:
            'I take your dog out for regular walks, keeping them active and happy.Every walk is safe, fun, and tailored to your pet\'s needs.',
            rating: 4.00,
            reviewCount: 120,
            price: 'From \$100',
            showOnlineIndicator: false,
          ),
        ],
      ),
    );
  }
}

class ProviderCard extends StatelessWidget {
  final String imageUrl;
  final String profileUrl;
  final String name;
  final String location;
  final String postedTime;
  final String description;
  final double rating;
  final int reviewCount;
  final String price;
  final bool showOnlineIndicator;

  const ProviderCard({
    Key? key,
    required this.imageUrl,
    required this.profileUrl,
    required this.name,
    required this.location,
    required this.postedTime,
    required this.description,
    required this.rating,
    required this.reviewCount,
    required this.price,
    required this.showOnlineIndicator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image section
          Stack(
            children: [
              Image.network(
                imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image, size: 50, color: Colors.grey),
                  );
                },
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.favorite_border,
                    size: 18,
                    color: Color(0xFFFF6B9D),
                  ),
                ),
              ),
            ],
          ),
          // Content section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: ClipOval(
                            child: Image.network(
                              profileUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.person, size: 24),
                                );
                              },
                            ),
                          ),
                        ),
                        if (showOnlineIndicator)
                          Positioned(
                            right: -2,
                            bottom: -2,
                            child: Container(
                              width: 14,
                              height: 14,
                              decoration: BoxDecoration(
                                color: const Color(0xFF4CAF50),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                name,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF212121),
                                ),
                              ),
                              Text(
                                postedTime,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF4CAF50),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            location,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF757575),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF424242),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    ...List.generate(
                      5,
                          (index) => Padding(
                        padding: const EdgeInsets.only(right: 2),
                        child: Icon(
                          Icons.star,
                          size: 16,
                          color: index < 4
                              ? const Color(0xFFFFC107)
                              : const Color(0xFFE0E0E0),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$rating ($reviewCount)',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF212121),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF212121),
                      ),
                    ),
                    ElevatedButton(
    onPressed: () {
    Navigator.pushNamed(context, '/service/profile');
    },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B5E4E),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 11,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text(
                        'View Details',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
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