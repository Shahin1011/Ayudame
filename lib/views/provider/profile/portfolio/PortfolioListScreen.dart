import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:middle_ware/core/theme/app_colors.dart';
import 'package:middle_ware/widgets/custom_appbar.dart';
import '../../../../controller/provider/portfolio_controller.dart';
import '../../../../models/provider/portfolio_model.dart';
import 'AddPortfolioScreen.dart';
import 'EditPortfolioScreen.dart';

class PortfolioListScreen extends StatelessWidget {
  PortfolioListScreen({super.key});

  final PortfolioController controller = Get.put(PortfolioController());

  @override
  Widget build(BuildContext context) {
    Color primaryGreen = const Color(0xFF2C5F4F);
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBar(title: "Portfolio"),
      body: Obx(() {
        if (controller.isLoading.value && controller.portfolioList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        
        return RefreshIndicator(
          onRefresh: () => controller.getAllPortfolios(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Add Portfolio Button
                GestureDetector(
                  onTap: () => Get.to(() => const AddPortfolioScreen()),
                  child: CustomPaint(
                    painter: DashedBorderPainter(color: Colors.grey.shade400),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: const Center(
                        child: Text(
                          "Add Portfolio",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                if (controller.portfolioList.isEmpty)
                   const Padding(
                     padding: EdgeInsets.only(top: 50.0),
                     child: Text("No portfolio items found", style: TextStyle(color: Colors.grey)),
                   )
                else
                  ...controller.portfolioList.map((item) {
                    return Column(
                      children: [
                        _buildPortfolioCard(context, primaryGreen, item),
                        const SizedBox(height: 16),
                      ],
                    );
                  }).toList(),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildPortfolioCard(BuildContext context, Color primary, PortfolioModel item) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Edit/Delete
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title ?? "Untitled",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    if(item.serviceType != null)
                      Text(item.serviceType!, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  ],
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => _confirmDelete(context, item.id!),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: SvgPicture.asset(
                        'assets/icons/delete.svg',
                        width: 25,
                        height: 25,
                        colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => Get.to(() => EditPortfolioScreen(portfolio: item)),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: SvgPicture.asset(
                        'assets/icons/edit.svg',
                        width: 25,
                        height: 25,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),
          Row(
            children: [
              _buildImagePreview(
                "Before",
                Colors.grey[300]!,
                item.beforeImage,
              ),
              const SizedBox(width: 12),
              _buildImagePreview(
                "After",
                Colors.grey[300]!,
                item.afterImage,
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (item.about != null)
            Text(
              item.about!,
              style: TextStyle(fontSize: 13, color: primary, height: 1.5),
            ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Portfolio"),
        content: const Text("Are you sure you want to delete this item?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              controller.deletePortfolio(id);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview(String label, Color color, String? imageUrl) {
    return Expanded(
      child: Column(
        children: [
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
              // Use NetworkImage for API images
              image: imageUrl != null && imageUrl.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                      onError: (_, __) {}, 
                    )
                  : null,
            ),
             child: (imageUrl == null || imageUrl.isEmpty) 
               ? const Center(child: Icon(Icons.image_not_supported, color: Colors.grey)) 
               : null,
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.black)),
        ],
      ),
    );
  }
}

// Custom painter for dashed border (Included here to be self-contained or move to widgets)
class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;

  DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1.5,
    this.dashWidth = 6,
    this.dashSpace = 4,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          const Radius.circular(12),
        ),
      );

    _drawDashedPath(canvas, path, paint);
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    final dashPath = Path();
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final nextDash = distance + dashWidth;
        dashPath.addPath(metric.extractPath(distance, nextDash), Offset.zero);
        distance = nextDash + dashSpace;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
