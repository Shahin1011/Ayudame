import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:middle_ware/views/user/categories/providers_screen.dart';
import 'package:middle_ware/views/user/categories/widgets/custom_categories_card.dart';
import '../../../controller/user/category_controller/category_conttroller.dart';
import '../../../core/theme/app_colors.dart';
import 'package:get/get.dart';


class CategoriesPage extends StatefulWidget {
  const CategoriesPage({Key? key}) : super(key: key);

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}
  class _CategoriesPageState extends State<CategoriesPage> {

    final CategoryController controller = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor1,
      body: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFF2D6A4F),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              padding: EdgeInsets.fromLTRB(20, 45, 20, 24),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      'Categories',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),

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
                child: Obx((){
                  if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.errorMessage.isNotEmpty) {
                  return Center(child: Text(controller.errorMessage.value));
                  }

                  if (controller.categories.isEmpty) {
                  return const Center(child: Text("No categories found"));
                  }

                  return GridView.builder(
                    itemCount: controller.categories.length,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.85,
                    ),
                    itemBuilder: (context, index) {
                      final category = controller.categories[index];
                      print("Building CategoryCard: ${category.name} (ID: ${category.id})");

                      return CategoryCard(
                        title: category.name,
                        imageUrl: category.icon.isNotEmpty
                            ? category.icon
                            : "https://via.placeholder.com/150",
                        onTap: () {
                          print("Tapped Category: ${category.id}");
                          Get.to(() => ProvidersScreen(),
                              arguments: category.id);
                        },
                      );
                    },
                  );

                })

              ),
            ),
          ],
        ),
    );

  }


}