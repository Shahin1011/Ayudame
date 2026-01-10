import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:middle_ware/core/theme/app_colors.dart';
import 'package:middle_ware/widgets/custom_appbar.dart';

class PortfolioListScreen extends StatelessWidget {
  const PortfolioListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Color primaryGreen = const Color(0xFF2C5F4F);
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: CustomAppBar(title: "Portfolio"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Add Portfolio Button with dashed border
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddPortfolioScreen(),
                ),
              ),
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
            // Portfolio Item Cards
            _buildPortfolioCard(context, primaryGreen),
            const SizedBox(height: 16),
            _buildPortfolioCard(context, primaryGreen),
          ],
        ),
      ),
    );
  }

  Widget _buildPortfolioCard(BuildContext context, Color primary) {
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
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditPortfolioScreen(),
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: SvgPicture.asset(
                  'assets/icons/edit.svg',
                  width: 30,
                  height: 30,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildImagePreview(
                "Before",
                Colors.grey[300]!,
                "assets/images/before.png",
              ),
              const SizedBox(width: 12),
              _buildImagePreview(
                "After",
                Colors.grey[300]!,
                "assets/images/after.png",
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "From grime to glorious, we transform your space into a sparkling sanctuary. Watch as we revitalize every corner, bringing back the shine and freshness to your home.",
            style: TextStyle(fontSize: 13, color: primary, height: 1.5),
          ),
          const SizedBox(height: 8),
          _buildBulletPoint(
            "\"From neglected to renewed, your home's fresh story.\"",
          ),
          _buildBulletPoint(
            "\"We don't just clean; we craft comfort from chaos.\"",
          ),
          _buildBulletPoint(
            "\"See the shine? It's where old worries meet new sparkle.\"",
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(fontSize: 12)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 12, height: 1.4),
            ),
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
              image: imageUrl != null
                  ? DecorationImage(
                      image: AssetImage(imageUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}

// Custom painter for dashed border
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

// --- Add Portfolio Screen ---
class AddPortfolioScreen extends StatefulWidget {
  const AddPortfolioScreen({super.key});

  @override
  State<AddPortfolioScreen> createState() => _AddPortfolioScreenState();
}

class _AddPortfolioScreenState extends State<AddPortfolioScreen> {
  String? beforeImage;
  String? afterImage;
  final TextEditingController _aboutController = TextEditingController();
  final int maxLength = 1000;

  @override
  void dispose() {
    _aboutController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(bool isBefore) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        if (isBefore) {
          beforeImage = image.path;
        } else {
          afterImage = image.path;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Color primaryGreen = const Color(0xFF2C5F4F);
    int currentLength = _aboutController.text.length;

    return Scaffold(
      appBar: CustomAppBar(title: "Add Portfolio"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildUploadBox("Before Upload", beforeImage, true),
                const SizedBox(width: 16),
                _buildUploadBox("After Uploader", afterImage, false),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              "About",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _aboutController,
              maxLines: 6,
              maxLength: maxLength,
              onChanged: (value) => setState(() {}),
              decoration: InputDecoration(
                hintText: "Describe your portfolio work...",
                hintStyle: TextStyle(color: Colors.grey.shade400),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryGreen, width: 1.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                counterText: '',
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "$currentLength/$maxLength",
                style: TextStyle(
                  fontSize: 12,
                  color: currentLength > maxLength ? Colors.red : Colors.grey,
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Validate and publish
                  if (beforeImage != null &&
                      afterImage != null &&
                      _aboutController.text.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Portfolio published successfully!"),
                      ),
                    );
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please complete all fields"),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Publish",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadBox(String label, String? imagePath, bool isBefore) {
    return Expanded(
      child: Column(
        children: [
          GestureDetector(
            onTap: () => _pickImage(isBefore),
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300, width: 1.5),
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade50,
              ),
              child: imagePath != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(File(imagePath), fit: BoxFit.cover),
                    )
                  : const Center(
                      child: Icon(
                        Icons.camera_alt,
                        color: Color(0xFF2C5F4F),
                        size: 32,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}

// --- Edit Portfolio Screen ---
class EditPortfolioScreen extends StatefulWidget {
  const EditPortfolioScreen({super.key});

  @override
  State<EditPortfolioScreen> createState() => _EditPortfolioScreenState();
}

class _EditPortfolioScreenState extends State<EditPortfolioScreen> {
  String? beforeImage;
  String? afterImage;
  final TextEditingController _aboutController = TextEditingController(
    text:
        "From grime to glorious, we transform your space into a sparkling sanctuary. Watch as we revitalize every corner, bringing back the shine and freshness to your home.\n\n• \"From neglected to renewed, your home's fresh story.\"\n• \"We don't just clean; we craft comfort from chaos.\"\n• \"See the shine? It's where old worries meet new sparkle.\"",
  );

  Future<void> _pickImage(bool isBefore) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        if (isBefore) {
          beforeImage = image.path;
        } else {
          afterImage = image.path;
        }
      });
    }
  }

  @override
  void dispose() {
    _aboutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color primaryGreen = const Color(0xFF2C5F4F);

    return Scaffold(
      appBar: CustomAppBar(title: "Edit Profile"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildEditImageBox(
                  "Before",
                  beforeImage,
                  "assets/images/provider_service.jpg",
                  true,
                ),
                const SizedBox(width: 16),
                _buildEditImageBox(
                  "After",
                  afterImage,
                  "assets/images/provider_service.jpg",
                  false,
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              "About",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _aboutController,
              maxLines: 8,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: primaryGreen, width: 1.5),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Changes saved successfully!"),
                    ),
                  );
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Save Changes",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditImageBox(
    String label,
    String? imagePath,
    String defaultAsset,
    bool isBefore,
  ) {
    return Expanded(
      child: Column(
        children: [
          GestureDetector(
            onTap: () => _pickImage(isBefore),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                    image: imagePath != null
                        ? DecorationImage(
                            image: FileImage(File(imagePath)),
                            fit: BoxFit.cover,
                          )
                        : DecorationImage(
                            image: AssetImage(defaultAsset),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}
