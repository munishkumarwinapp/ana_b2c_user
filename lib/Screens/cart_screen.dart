import 'dart:convert';

import 'package:ana_exports_b2c/Models/address_model.dart';
import 'package:ana_exports_b2c/Screens/login_widget.dart';
import 'package:ana_exports_b2c/constant.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<String> _status = ["Cod", "Pay pal", "Pay Now"];

  String _verticalGroupValue = "Cod";
  String _customerName = "";
  String initialValue = "";
  String _customerId = "";
  String _customerAddress = "";
  final _addressText = TextEditingController();
  final _fetchaddress = TextEditingController();

  void loadSessionData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _customerName = prefs.getString('customer_name')!;
      _customerId = prefs.getString('customer_code')!;
      _customerAddress =
          prefs.getString("address")! + " " + prefs.getString("postal_code")!;
    });
  }

  @override
  void initState() {
    loadSessionData();
    print(CART);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CartScreen oldWidget) {
    loadSessionData();
    print("object");
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart Details"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: Cros,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
            child: Text(
              "Delivery Address",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 5.0,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Text(
                    _customerAddress,
                    maxLines: 2,
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {});
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: false,
                        builder: (context) {
                          return StatefulBuilder(builder: (context, SetState1) {
                            return Padding(
                              padding: MediaQuery.of(context).viewInsets,
                              child: ListView(
                                children: <Widget>[
                                  Container(
                                    margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
                                    child: const Text(
                                      "Change Address",
                                      style: TextStyle(
                                          color: Colors.black,
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
                                    child: const Text(
                                      "Postal Code",
                                      style: TextStyle(
                                          color: Colors.black,
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Container(
                                      margin: const EdgeInsets.fromLTRB(
                                          16, 0, 16, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                              flex: 8,
                                              child: TextFormField(
                                                controller: _addressText,
                                                keyboardType:
                                                    TextInputType.number,
                                                textInputAction:
                                                    TextInputAction.next,
                                              )),
                                          Expanded(
                                              flex: 2,
                                              child: IconButton(
                                                  onPressed: () async {
                                                    SharedPreferences prefs =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    getAddresserviceCall(
                                                            http.Client(),
                                                            _addressText.text
                                                                .toString())
                                                        .then((value) {
                                                      if (value
                                                          .data.isNotEmpty) {
                                                        initialValue = value
                                                            .data[0].street;
                                                        print("Value" +
                                                            initialValue);

                                                        SetState1(() {
                                                          initialValue = value
                                                              .data[0].street;
                                                          debugPrint(
                                                              initialValue);
                                                          _fetchaddress.text =
                                                              value.data[0]
                                                                  .street;

                                                          prefs.setString(
                                                              "address",
                                                              value.data[0]
                                                                  .street);
                                                          prefs.setString(
                                                              "postal_code",
                                                              value.data[0]
                                                                  .postcode);
                                                        });
                                                      } else {
                                                        MotionToast.error(
                                                          title: const Text(
                                                            'Error',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          description: const Text(
                                                              "No Address found, Please check"),
                                                          animationType:
                                                              ANIMATION
                                                                  .fromBottom,
                                                          position:
                                                              MOTION_TOAST_POSITION
                                                                  .bottom,
                                                          width: 300,
                                                        ).show(context);
                                                      }
                                                    });
                                                  },
                                                  icon: const Icon(
                                                    Icons.search,
                                                    color: Colors.green,
                                                  )))
                                        ],
                                      )),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.fromLTRB(
                                        16, 16, 16, 0),
                                    child: const Text(
                                      "Address",
                                      style: TextStyle(
                                          color: Colors.black,
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Container(
                                      margin: const EdgeInsets.fromLTRB(
                                          16, 0, 16, 0),
                                      child: TextFormField(
                                        controller: _fetchaddress,
                                        keyboardType: TextInputType.text,
                                      )),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
                                    child: const Text(
                                      "Unit No",
                                      style: TextStyle(
                                          color: Colors.black,
                                          letterSpacing: 0.5,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Container(
                                      margin: const EdgeInsets.fromLTRB(
                                          16, 0, 16, 0),
                                      child: TextFormField()),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.all(24),
                                      width: MediaQuery.of(context).size.width,
                                      child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Set Address")),
                                    ),
                                  )
                                  // Column(
                                  //   mainAxisAlignment: MainAxisAlignment.start,
                                  //   crossAxisAlignment: CrossAxisAlignment.start,
                                  //   children: <Widget>[

                                  //   ],
                                  // ),
                                ],
                              ),
                            );
                          });
                        });
                  },
                  child: const Text(
                    "Change",
                    style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0),
                  ),
                )
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
            child: Text(
              "Customer Name",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
            child: Text(
              _customerName,
              style: TextStyle(
                color: Colors.green,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Expanded(
                  child: Text(
                    "Your Order",
                    maxLines: 2,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    CART.clear();
                    setState(() {});
                  },
                  child: const Text(
                    "Clear All",
                    style: TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                  itemCount: CART.length,
                  itemBuilder: (BuildContext context, int indext) {
                    return Card(
                        color: Colors.white,
                        elevation: 6.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: FadeInImage(
                                image: NetworkImage(
                                    IMAGE_BASE_URL + CART[indext].itemRemarks),
                                placeholder: const AssetImage(
                                    "assets/images/no_image.jpeg"),
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
                                  return Image.asset(
                                      'assets/images/no_image.jpeg',
                                      height: 125,
                                      width: 125,
                                      fit: BoxFit.fitWidth);
                                },
                                fit: BoxFit.cover,
                                height: 125,
                                width: 125,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin:
                                    const EdgeInsets.fromLTRB(16, 16, 16, 0),
                                height: 125.0,
                                width: MediaQuery.of(context).size.width,
                                color: Colors.white,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            CART[indext].itemDescription,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        const Text(
                                          " \$ 0.00",
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          CART[indext].uOMCode,
                                          style: const TextStyle(
                                              color: Colors.green,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      var qty =
                                                          CART[indext].qty;
                                                      var convertQty =
                                                          int.parse(qty);
                                                      convertQty--;

                                                      CART
                                                          .asMap()
                                                          .forEach(
                                                              (index, value) =>
                                                                  {
                                                                    if (value
                                                                            .itemCode ==
                                                                        CART[index]
                                                                            .itemCode)
                                                                      {
                                                                        CART[index].qty =
                                                                            convertQty.toString()
                                                                      }
                                                                  });
                                                    });
                                                  },
                                                  child: const Icon(
                                                    Icons.remove_circle,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Text(CART[indext].qty,
                                                    style: const TextStyle(
                                                        fontSize: 18.0)),
                                                const SizedBox(width: 10),
                                                InkWell(
                                                  onTap: () {
                                                    var qty = CART[indext].qty;
                                                    var convertQty =
                                                        int.parse(qty);
                                                    convertQty++;

                                                    CART[indext].qty =
                                                        convertQty.toString();

                                                    // CART.asMap().forEach((index,
                                                    //         value) =>
                                                    //     {
                                                    //       if (value.itemCode ==
                                                    //           CART[index]
                                                    //               .itemCode)
                                                    //         {
                                                    //           CART[index].qty =
                                                    //               convertQty
                                                    //                   .toString()
                                                    //         }
                                                    //     });
                                                    setState(() {});
                                                  },
                                                  child: const Icon(
                                                    Icons.add_circle,
                                                    color: Colors.green,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                CART.removeAt(indext);
                                                setState(() {});
                                              },
                                              child: const Icon(
                                                  Icons.delete_forever,
                                                  color: Colors.red),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ));
                  }),
            ),
          )
        ],
      ),
      bottomNavigationBar: Container(
        height: 200,
        color: Colors.green.shade400,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    "Total Items",
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                  Text(
                    CART.length.toString(),
                    style: const TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
                  Text(
                    "Cart Price",
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ),
                  Text(
                    "\$ 0.00",
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            const Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
                child: Text(
                  "Payment mode",
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: RadioGroup<String>.builder(
                direction: Axis.horizontal,
                activeColor: Colors.white,
                groupValue: _verticalGroupValue,
                horizontalAlignment: MainAxisAlignment.spaceAround,
                onChanged: (value) => setState(() {
                  _verticalGroupValue = value!;
                }),
                items: _status,
                textStyle: const TextStyle(fontSize: 15, color: Colors.white),
                itemBuilder: (item) => RadioButtonBuilder(
                  item,
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  if (_customerId.isNotEmpty) {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.QUESTION,
                      animType: AnimType.BOTTOMSLIDE,
                      title: 'ANA EXPORTS',
                      desc: 'Are you sure to Place order ?',
                      btnCancelOnPress: () {
                        var map2 = {};
                        CART.forEach((customer) =>
                            map2[customer.billDiscount] = customer.companyCode);
                        print(map2);
                      },
                      btnOkOnPress: () {
                        DateTime now = DateTime.now();
                        String formattedDate =
                            DateFormat('dd/MM/yyyy').format(now);
                        if (CART.isEmpty) {
                          MotionToast.error(
                            title: const Text(
                              'Error',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            description: const Text(
                                "CART IS EMPTY. PLEASE ADD SOME PRODUCT TO CHECK OUT"),
                            animationType: ANIMATION.fromBottom,
                            position: MOTION_TOAST_POSITION.bottom,
                            width: 300,
                          ).show(context);
                        } else {
                          var json = jsonEncode(
                              CART.map((e) => e.toJsonAttr()).toList());
                          print(json);
                          updatePickListData(json.toString(), context);
                        }
                      },
                    ).show();
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    ).then((value) {
                      setState(() {});
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white, // background
                  onPrimary: Colors.black, // foreground
                ),
                child: const Text("Send Qutaion"))
          ],
        ),
      ),
    );
  }
}

Future updatePickListData(String invoiceDetails, BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  EasyLoading.show(status: 'Updating...');
  DateTime now = DateTime.now();
  String formattedDate = DateFormat('dd/MM/yyyy').format(now);
  print(formattedDate);
  var headers = {
    'apikey': '914c9e52e6414d9494e299708d176a41',
    'Content-Type': 'application/json',
    'Cookie': 'ci_session=64ed845b5f251b9ab36044b4949cd03cc25d0b00'
  };

  var request = http.Request('POST',
      Uri.parse('http://anaexports.sg/API/API-V1/APISERVICE/saveOrderInLocal'));

  request.body = json.encode({
    "InvoiceB2CHeaderList": {
      "TransactionNo": "",
      "Mode": "I",
      "TransactionDateString": formattedDate,
      "CompanyCode": 1,
      "CustomerCode": prefs.getString("customer_code"),
      "CustomerName": prefs.getString("customer_name"),
      "BlockUnitNo": "",
      "CustomerAddress1": prefs.getString("address"),
      "ContactNo": prefs.getString("customer_phone_no"),
      "EmailId": prefs.getString("email"),
      "Country": "Singapore",
      "PostalCode": "339948",
      "DelCustomerName": prefs.getString("customer_name"),
      "DelBlockUnitNo": "",
      "DeliveryAddress1": prefs.getString("address"),
      "DelContactNo": prefs.getString("customer_phone_no"),
      "DelCountry": "Singapore",
      "DelPostalCode": "339948",
      "CurrencyCode": "SGD",
      "CurrencyValue": "1",
      "PayMode": "Cash On Delivery",
      "PaymentRefNo": "",
      "CreditorDebitCardNo": "",
      "PaidAmount": "",
      "Status": "0",
      "LocationCode": "HQ",
      "TaxCode": "",
      "TaxType": "Z",
      "TaxPerc": "0",
      "SubTotal": "0.0",
      "Tax": "0.0",
      "NetTotal": "0.0",
      "Remarks": "",
      "DeliveryDateString": formattedDate,
      "DeliveryTime": "",
      "DiscountAmount": "0",
      "DeliveryStatus": "0",
      "DeliveryCharges": "0.00"
    },
    "InvoiceB2CDetaillist": jsonDecode(invoiceDetails)
  });
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
    EasyLoading.dismiss();
    CART.clear();
    MotionToast.success(
      title: const Text(
        'Success',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      description: const Text("Order Placed succesfully"),
      animationType: ANIMATION.fromBottom,
      position: MOTION_TOAST_POSITION.bottom,
      width: 300,
    ).show(context);
  } else {
    EasyLoading.dismiss();
    print(response.reasonPhrase);
  }
}

Future<AddressModel> getAddresserviceCall(
    http.Client client, String postalCode) async {
  EasyLoading.show(status: 'getting...');
  final response = await client.get(
      Uri.parse(BASE_URL + "getAddressByPostCode/" + postalCode),
      headers: {'apikey': "914c9e52e6414d9494e299708d176a41"});
  print("Status Code " + response.statusCode.toString());
  print("Request Url " + response.request!.url.toString());
  print(response.body);
  EasyLoading.dismiss();
  return AddressModel.fromJson(jsonDecode(response.body));
  ;
}

AddressModel parseData(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<AddressModel>((json) => AddressModel.fromJson(json))
      .toList();
}
