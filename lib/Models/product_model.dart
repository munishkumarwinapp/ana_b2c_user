class ProductScreenModel {
  late List<ProductListModel> data;
  ProductScreenModel({
    required this.data,
  });

  factory ProductScreenModel.fromJson(Map<String, dynamic> json) {
    var splashList = json['Data'] as List;
    List<ProductListModel> prod = splashList
        .map((tagJson) => ProductListModel.fromJson(tagJson))
        .toList();

    return ProductScreenModel(data: prod);
  }
}

class ProductListModel {
  final String? id;
  final String? image;
  final String? productCode;
  final String? productName;
  int counter = 0;
  bool isAdded = false;

  ProductListModel({
    this.id,
    this.image,
    this.productCode,
    this.productName,
  });

  factory ProductListModel.fromJson(Map<String, dynamic> json) {
    return ProductListModel(
      id: json['id'] as String,
      image: json['ProductImagePath'] as String,
      productCode: json['ProductCode'] ?? "",
      productName: json['ProductName'] as String,
    );
  }
}
