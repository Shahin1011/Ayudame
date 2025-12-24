import 'package:flutter/material.dart';



class CategoriesPage extends StatefulWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}
  class _CategoriesPageState extends State<CategoriesPage> {
  int _selectedIndex = 1; // Set to 1 since this is the Categories page
  bool _isFavorite = false;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigation logic
    if (index == 0) {
      // Navigate to Home page
      Navigator.pushNamed(context, '/home');
    } else if (index == 1) {
      // Already on Categories page
      // Do nothing or refresh if needed
    } else if (index == 2) {
      // Navigate to Notifications page
      Navigator.pushNamed(context, '/notifications');
    } else if (index == 3) {
      // Navigate to Profile page
      Navigator.pushNamed(context, '/profile');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: SafeArea(
        child: Column(
          children: [

            Container(
              decoration: const BoxDecoration(
                color: Color(0xFF2D6A4F),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                children: [

                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Categories',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search Categories...',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),


            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85,
                  children: [
                    _buildCategoryCard(
                      'Home Services',
                      'https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=400',
                    ),
                    _buildCategoryCard(
                      'Personal Services',
                      'https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?w=400',
                    ),
                    _buildCategoryCard(
                      'Event Services',
                      'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?w=400',
                    ),
                    _buildCategoryCard(
                      'Moving Services',
                      'https://images.unsplash.com/photo-1600880292203-757bb62b4baf?w=400',
                    ),
                    _buildCategoryCard(
                      'Personal Services',
                      'https://images.unsplash.com/photo-1556740758-90de374c12ad?w=400',
                    ),
                    _buildCategoryCard(
                      'IT Services',
                      'https://images.unsplash.com/photo-1497366216548-37526070297c?w=400',
                    ),
                    _buildCategoryCard(
                      'Vehicle Services',
                      'https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?w=400',
                    ),
                    _buildCategoryCard(
                      'Improvement Services',
                      'https://images.unsplash.com/photo-1556911220-bff31c812dba?w=400',
                    ),
                    _buildCategoryCard(
                      'Education Services',
                      'https://images.unsplash.com/photo-1503676260728-1c00da094a0b?w=400',
                    ),
                    _buildCategoryCard(
                      'Pet Care Services',
                      'https://images.unsplash.com/photo-1548199973-03cce0bbc87b?w=400',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

    );

  }

  Widget _buildCategoryCard(String title, String imageUrl,{VoidCallback? onTap}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.image, size: 50, color: Colors.grey),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              border: Border(
                top: BorderSide(color: Color(0xFF2D6A4F), width: 2),
                left: BorderSide(color: Color(0xFF2D6A4F), width: 2),
                right: BorderSide(color: Color(0xFF2D6A4F), width: 2),
                bottom: BorderSide(color: Color(0xFF2D6A4F), width: 2),
              ),
            ),

    child: GestureDetector(
    onTap: () {
    Navigator.pushNamed(context, '/service');
    },
    child: Text(
    title,
    textAlign: TextAlign.center,
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    style: const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Color(0xFF2D6A4F),
    ),
    ),
    ),
          )
        ],
      ),
    );
  }
}