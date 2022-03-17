class LoginModel {
  late final String message;
  late List<loginObjectModel> data;
  late final int statusCode;
  LoginModel({
    required this.message,
    required this.data,
    required this.statusCode,
  });
  factory LoginModel.fromJson(Map<String, dynamic> json) {
    var splashList = json['Data'] as List;
    List<loginObjectModel> prod = splashList
        .map((tagJson) => loginObjectModel.fromJson(tagJson))
        .toList();

    return LoginModel(
        data: prod,
        message: json['Message'] as String,
        statusCode: json['Status_Code'] as int);
  }
}

class loginObjectModel {
  late final String companyCode;
  late final String customerCode;
  late final String customerName;
  late final String contactNo;
  late final String address1;
  late final String phoneNo;
  late final String contactPerson;
  late final String email;
  late final String verified;
  loginObjectModel({
    required this.companyCode,
    required this.customerCode,
    required this.customerName,
    required this.contactNo,
    required this.address1,
    required this.phoneNo,
    required this.contactPerson,
    required this.email,
    required this.verified,
  });

  factory loginObjectModel.fromJson(Map<String, dynamic> json) {
    return loginObjectModel(
      companyCode: json['CompanyCode'] as String,
      customerCode: json['CustomerCode'] as String,
      customerName: json['CustomerName'] as String,
      contactNo: json['ContactNo'] as String,
      address1: json['Address1'] as String,
      contactPerson: json['ContactPerson'] as String,
      email: json['Email'] as String,
      phoneNo: json['PhoneNo'] as String,
      verified: json['Verified'] as String,
    );
  }
}
