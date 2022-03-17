class AddressModel {
  late List<AddressResultModel> data;
  AddressModel({
    required this.data,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    var splashList = json['result'] as List;
    List<AddressResultModel> prod =
        splashList.map((tagJson) => AddressResultModel.fromJson(tagJson)).toList();

    return AddressModel(data: prod);
  }
}

class AddressResultModel {
  late String country;
  late String street;
  late String building;
  late String postcode;
  AddressResultModel({
    required this.country,
    required this.street,
    required this.building,
    required this.postcode,
  });


  factory AddressResultModel.fromJson(Map<String, dynamic> json) {
    return AddressResultModel(
      country: json['country'] as String,
      street: json['street'] as String,
      building: json['building'] as String,
      postcode: json['postcode'] as String,
    );
  }

}
