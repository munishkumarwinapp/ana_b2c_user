class BrandScreenModel {
  late List<BrandListModel> data;
  BrandScreenModel({
    required this.data,
  });

  factory BrandScreenModel.fromJson(Map<String, dynamic> json) {
    var splashList = json['Data'] as List;
    List<BrandListModel> prod =
        splashList.map((tagJson) => BrandListModel.fromJson(tagJson)).toList();

    return BrandScreenModel(data: prod);
  }
}

class BrandListModel {
  final String? id;
  final String? image;
  final String? storeId;
  final String? brandName;

  BrandListModel({
    this.id,
    this.image,
    this.storeId,
    this.brandName,
  });

  factory BrandListModel.fromJson(Map<String, dynamic> json) {
    return BrandListModel(
      id: json['manufacturer_id'] as String,
      image: json['image'] as String,
      storeId: json['store_id'] as String,
      brandName: json['name'] as String,
    );
  }
}
