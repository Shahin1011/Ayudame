import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:middle_ware/widgets/custom_appbar.dart';
import '../../../../controller/provider/portfolio_controller.dart';
import '../../../../models/provider/portfolio_model.dart';

class EditPortfolioScreen extends StatefulWidget {
  final PortfolioModel? portfolio;
  const EditPortfolioScreen({super.key, this.portfolio});

  @override
  State<EditPortfolioScreen> createState() => _EditPortfolioScreenState();
}

class _EditPortfolioScreenState extends State<EditPortfolioScreen> {
  final PortfolioController controller = Get.find<PortfolioController>();
  
  File? beforeImageFile;
  File? afterImageFile;
  
  late TextEditingController _titleController;
  late TextEditingController _serviceTypeController;
  late TextEditingController _aboutController;
  
  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.portfolio?.title ?? '');
    _serviceTypeController = TextEditingController(text: widget.portfolio?.serviceType ?? '');
    _aboutController = TextEditingController(text: widget.portfolio?.about ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _serviceTypeController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(bool isBefore) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        if (isBefore) {
          beforeImageFile = File(image.path);
        } else {
          afterImageFile = File(image.path);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Color primaryGreen = const Color(0xFF2C5F4F);
    
    // Fallback if no portfolio passed (shouldn't happen with correct nav)
    if (widget.portfolio == null && widget.portfolio?.id == null) {
      return Scaffold(
        appBar: CustomAppBar(title: "Edit Portfolio"),
        body: const Center(child: Text("Error: No portfolio data")),
      );
    }

    return Scaffold(
      appBar: CustomAppBar(title: "Edit Portfolio"),
      body: Obx(() {
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     // Title
                     const Text(
                      "Title",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                         contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Service Type
                     const Text(
                      "Service Type",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _serviceTypeController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    Row(
                      children: [
                        _buildEditImageBox(
                          "Before",
                          beforeImageFile,
                          widget.portfolio?.beforeImage,
                          true,
                        ),
                        const SizedBox(width: 16),
                        _buildEditImageBox(
                          "After",
                          afterImageFile,
                          widget.portfolio?.afterImage,
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
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value ? null : () async {
                           bool success = await controller.editPortfolio(
                             id: widget.portfolio!.id!,
                             title: _titleController.text,
                             serviceType: _serviceTypeController.text,
                             about: _aboutController.text,
                             beforeImage: beforeImageFile,
                             afterImage: afterImageFile,
                           );
                           
                           if (success) {
                             Get.back();
                             Get.snackbar("Success", "Changes saved successfully!", backgroundColor: Colors.green, colorText: Colors.white);
                           }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGreen,
                          padding: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: controller.isLoading.value
                           ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white))
                           : const Text(
                          "Save Changes",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
             if (controller.isLoading.value)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildEditImageBox(
    String label,
    File? newImageFile,
    String? currentImageUrl,
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
                    image: newImageFile != null
                        ? DecorationImage(
                            image: FileImage(newImageFile),
                            fit: BoxFit.cover,
                          )
                        : (currentImageUrl != null && currentImageUrl.isNotEmpty)
                          ? DecorationImage(
                            image: NetworkImage(currentImageUrl),
                            fit: BoxFit.cover,
                            onError: (_,__) {}
                          )
                          : null,
                  ),
                   child: (newImageFile == null && (currentImageUrl == null || currentImageUrl.isEmpty))
                      ? const Center(child: Icon(Icons.image, size: 40, color: Colors.grey))
                      : null,
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
