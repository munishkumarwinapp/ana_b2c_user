class SplashScreenModel {
  late List<RessultListModel> result;
  SplashScreenModel({
    required this.result,
  });

  factory SplashScreenModel.fromJson(Map<String, dynamic> json) {
    var splashList = json['result'] as List;
    List<RessultListModel> prod = splashList
        .map((tagJson) => RessultListModel.fromJson(tagJson))
        .toList();

    return SplashScreenModel(result: prod);
  }
}

class RessultListModel {
  final int id;
  final String image;
  final String path;

  RessultListModel({
    required this.id,
    required this.image,
    required this.path,
  });

  factory RessultListModel.fromJson(Map<String, dynamic> json) {
    return RessultListModel(
      id: json['ID'] as int,
      image: json['image'] as String,
      path: json['Path'] as String,
    );
  }
}
