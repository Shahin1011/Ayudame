class CategoryModel {
  final String id;
  final String name;
  final String description;
  final String icon;
  final bool isActive;

  CategoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.isActive,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    print("CategoryModel JSON: $json");
    
    // Prioritize categoryId as seen in Postman, then fall back to id/_id
    String parsedId = '';
    if (json['categoryId'] != null && json['categoryId'].toString().isNotEmpty) {
      parsedId = json['categoryId'].toString();
    } else if (json['id'] != null && json['id'].toString().isNotEmpty) {
      parsedId = json['id'].toString();
    } else if (json['_id'] != null && json['_id'].toString().isNotEmpty) {
      parsedId = json['_id'].toString();
    }

    return CategoryModel(
      id: parsedId,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      icon: json['icon'] ?? '',
      isActive: json['isActive'] ?? false,
    );
  }
}
