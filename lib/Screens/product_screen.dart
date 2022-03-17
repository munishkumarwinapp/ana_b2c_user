import 'dart:convert';
import 'dart:ui';

import 'package:ana_exports_b2c/Models/place_order_detail_model.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:ana_exports_b2c/Models/product_model.dart';
import 'package:ana_exports_b2c/Screens/cart_screen.dart';

import '../constant.dart';

class ProductScreen extends StatefulWidget {
  final String categoryCode;
  const ProductScreen({
    Key? key,
    required this.categoryCode,
  }) : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<DropdownMenuItem<String>> _dropDownItem() {
    List<String> ddl = ["Carton", "Loose"];
    return ddl
        .map((value) => DropdownMenuItem(
              value: value,
              child: Text(value),
            ))
        .toList();
  }

  late Future<ProductScreenModel> myFuture;
  List<String> selectedItemValue = <String>[];
  @override
  void initState() {
    myFuture = getProduct(http.Client(), widget.categoryCode);
    super.initState();
  }

  var qtyValue = 0;

  @override
  void didUpdateWidget(covariant ProductScreen oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: loginbackground,

      appBar: AppBar(
        title: const Text("Products"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartScreen()),
                );
              },
              child: Badge(
                badgeColor: Colors.orange,
                position: BadgePosition.topStart(start: 10),
                badgeContent: Text(
                  CART.length.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
                child: const Icon(Icons.production_quantity_limits),
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<ProductScreenModel>(
          future: myFuture,
          builder: (context, productList) {
            if (productList.hasData) {
              final data = productList.data!.data;
              print(data.length);
              return Column(
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                      child: TextField(
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          suffixIcon: const Icon(
                            Icons.search,
                          ),
                          hintText: "Search",
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.green, width: 1.0),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.white, width: 1.0),
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      )),
                  Expanded(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  mainAxisExtent: 300),
                          itemCount: data.length,
                          itemBuilder: (BuildContext ctx, index) {
                            selectedItemValue.add("Carton");
                            return InkWell(
                              onTap: () {},
                              child: Container(
                                margin: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: FadeInImage(
                                        image: NetworkImage(
                                          IMAGE_BASE_URL + data[index].image!,
                                        ),
                                        placeholder: const AssetImage(
                                            "assets/images/no_image.jpeg"),
                                        imageErrorBuilder:
                                            (context, error, stackTrace) {
                                          return Image.asset(
                                              'assets/images/no_image.jpeg',
                                              fit: BoxFit.fitWidth);
                                        },
                                        fit: BoxFit.cover,
                                        height: 150,
                                        width:
                                            MediaQuery.of(context).size.width,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          8.0, 8.0, 8.0, 0.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                            child: Text(
                                              data[index].productName!,
                                              maxLines: 1,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    data[index].isAdded
                                        ? Expanded(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                DropdownButton(
                                                  value:
                                                      selectedItemValue[index]
                                                          .toString(),
                                                  items: _dropDownItem(),
                                                  onChanged: (value) {
                                                    selectedItemValue[index] =
                                                        value.toString();
                                                    CART[index].uOMCode =
                                                        value.toString();
                                                    setState(() {});
                                                  },
                                                ),
                                                IconButton(
                                                  icon: const Icon(
                                                      Icons.remove_circle),
                                                  onPressed: () {
                                                    if (data[index].counter >
                                                        0) {
                                                      data[index].counter--;
                                                      var count =
                                                          data[index].counter;
                                                      CART.asMap().forEach(
                                                          (index, value) => {
                                                                if (value
                                                                        .itemCode ==
                                                                    data[index]
                                                                        .productCode)
                                                                  {
                                                                    CART[index]
                                                                        .qty = data[
                                                                            index]
                                                                        .counter
                                                                        .toString()
                                                                  }
                                                              });
                                                    }
                                                    setState(() {});
                                                  },
                                                  color: Colors.red,
                                                ),
                                                Text(data[index]
                                                    .counter
                                                    .toString()),
                                                IconButton(
                                                  icon: Icon(Icons.add_circle),
                                                  color: Colors.green,
                                                  onPressed: () {
                                                    data[index].counter++;
                                                    var count =
                                                        data[index].counter;
                                                    CART.asMap().forEach(
                                                        (index, value) => {
                                                              if (value
                                                                      .itemCode ==
                                                                  data[index]
                                                                      .productCode)
                                                                {
                                                                  CART[index]
                                                                      .qty = data[
                                                                          index]
                                                                      .counter
                                                                      .toString()
                                                                }
                                                            });

                                                    setState(() {});
                                                  },
                                                ),
                                              ],
                                            ),
                                          )
                                        : Container(
                                            margin: const EdgeInsets.fromLTRB(
                                                12, 12, 12, 0),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  data[index].isAdded = true;
                                                  data[index].counter++;
                                                  PlaceOrderDetailModel
                                                      placeOrderObject =
                                                      PlaceOrderDetailModel(
                                                          billDiscount: "0",
                                                          companyCode: "1",
                                                          itemCode:
                                                              data[
                                                                          index]
                                                                      .productCode ??
                                                                  "",
                                                          itemDescription: data[
                                                                      index]
                                                                  .productName ??
                                                              "",
                                                          itemDiscount: "0",
                                                          itemRemarks:
                                                              data[index]
                                                                      .image ??
                                                                  "",
                                                          netTotal: "0.0",
                                                          price: "0.0",
                                                          qty: "1",
                                                          slNo: CART.length
                                                              .toString(),
                                                          subTotal: "",
                                                          tax: "0.0",
                                                          total: "0.0",
                                                          transactionNo: "",
                                                          uOMCode:
                                                              selectedItemValue[
                                                                      index]
                                                                  .toString());

                                                  CART.add(placeOrderObject);
                                                });
                                              },
                                              child: const Text("Add"),
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
                ],
              );
            } else if (productList.hasError) {
              print(productList.error);
              return const Center(
                child: Text("Sorry Some thing wrong, Please try again"),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}

Future<ProductScreenModel> getProduct(
    http.Client client, String categoryCode) async {
  debugPrint("Cat_CODE" + categoryCode);
  Map<String, dynamic> body = {'CategoryCode': categoryCode};
  String encodedBody = body.keys.map((key) => "$key=${body[key]}").join("&");

  final response = await client.post(Uri.parse(BASE_URL + "products"),
      headers: {
        'apikey': "914c9e52e6414d9494e299708d176a41",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: encodedBody);
  print("Status Code " + response.statusCode.toString());
  print("Request Url " + response.request.toString());
  print(response.body);
  return ProductScreenModel.fromJson(jsonDecode(response.body));
}
