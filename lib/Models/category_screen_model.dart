class CategoryScreenModel {
  late List<CategoryListModel> data;
  CategoryScreenModel({
    required this.data,
  });

  factory CategoryScreenModel.fromJson(Map<String, dynamic> json) {
    var splashList = json['Data'] as List;
    List<CategoryListModel> prod = splashList
        .map((tagJson) => CategoryListModel.fromJson(tagJson))
        .toList();

    return CategoryScreenModel(data: prod);
  }
}

class CategoryListModel {
  final String? id;
  final String? image;
  final String? categoryCode;
  final String? description;

  CategoryListModel({
    this.id,
    this.image,
    this.categoryCode,
    this.description,
  });

  factory CategoryListModel.fromJson(Map<String, dynamic> json) {
    return CategoryListModel(
      id: json['id'] as String,
      image: json['Image'] as String,
      categoryCode: json['CategoryCode'] as String,
      description: json['Description'] as String,
    );
  }
}
