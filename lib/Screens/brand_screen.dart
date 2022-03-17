import 'dart:convert';

import 'package:ana_exports_b2c/Models/brand_screen_model.dart';
import 'package:ana_exports_b2c/Screens/cart_screen.dart';
import 'package:flutter/material.dart';

import '../constant.dart';
import 'package:http/http.dart' as http;

class BrandScreen extends StatefulWidget {
  const BrandScreen({Key? key}) : super(key: key);

  @override
  _BrandScreenState createState() => _BrandScreenState();
}

class _BrandScreenState extends State<BrandScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Brand Screen"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
            icon: const Icon(Icons.production_quantity_limits),
          ),
        ],
      ),
      body: FutureBuilder<BrandScreenModel>(
          future: getProduct(http.Client()),
          builder: (context, brandList) {
            if (brandList.hasData) {
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
                                BorderSide(color: Colors.blue, width: 1.0),
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
                                  mainAxisExtent: 250),
                          itemCount: brandList.data!.data.length,
                          itemBuilder: (BuildContext ctx, index) {
                            return InkWell(
                              onTap: () {},
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    margin: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: Colors.white,
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.transparent,
                                            blurRadius: 5.0,
                                            spreadRadius: 5.0,
                                            offset: Offset(5.0, 5.0),
                                          )
                                        ],
                                        border: Border.all(
                                            color: Colors.transparent)),
                                    child: ClipOval(
                                      child: FadeInImage.assetNetwork(
                                          placeholder:
                                              'assets/images/no_image.jpeg',
                                          image: IMAGE_BASE_URL +
                                              brandList
                                                  .data!.data[index].image!,
                                          fit: BoxFit.cover,
                                          imageErrorBuilder:
                                              (context, error, stackTrace) {
                                            return Image.asset(
                                                'assets/images/no_image.jpeg',
                                                fit: BoxFit.fitWidth);
                                          }),
                                    ),
                                  ),
                                  Text(
                                    brandList.data!.data[index].brandName!,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 18.0,
                                      letterSpacing: 0.5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            );

                            // return InkWell(
                            //   onTap: () {},
                            //   child: Column(
                            //     children: <Widget>[
                            //       Container(
                            //         height: 250,
                            //         margin: const EdgeInsets.all(2),
                            //         decoration: BoxDecoration(
                            //           color: Colors.white,
                            //           borderRadius: BorderRadius.circular(25.0),
                            //         ),
                            //         child: Column(
                            //           mainAxisAlignment:
                            //               MainAxisAlignment.spaceEvenly,
                            //           crossAxisAlignment:
                            //               CrossAxisAlignment.center,
                            //           children: <Widget>[
                            //             ClipRRect(
                            //               borderRadius:
                            //                   BorderRadius.circular(10.0),
                            //               child: FadeInImage(
                            //                 image: NetworkImage(IMAGE_BASE_URL +
                            //                     brandList
                            //                         .data!.data[index].image!),
                            //                 placeholder: const AssetImage(
                            //                     "assets/images/no_image.jpeg"),
                            //                 imageErrorBuilder:
                            //                     (context, error, stackTrace) {
                            //                   return Image.asset(
                            //                     'assets/images/no_image.jpeg',
                            //                     fit: BoxFit.fitWidth,
                            //                     height: 125,
                            //                   );
                            //                 },
                            //                 fit: BoxFit.cover,
                            //                 height: 125,
                            //                 width: MediaQuery.of(context)
                            //                     .size
                            //                     .width,
                            //               ),
                            //             ),
                            //             // Padding(
                            //             //   padding: EdgeInsets.all(8.0),
                            //             //   child: Text(
                            //             //     brandList
                            //             //         .data!.data[index].brandName!,
                            //             //     maxLines: 1,
                            //             //     style: const TextStyle(
                            //             //         color: Colors.deepPurple,
                            //             //         fontWeight: FontWeight.bold,
                            //             //         fontSize: 18.0),
                            //             //   ),
                            //             // )
                            //           ],
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // );
                          }),
                    ),
                  ),
                ],
              );
            } else if (brandList.hasError) {
              return Center(
                child: Text(
                  "Sorry Something wrong please try again !!",
                  style: TextStyle(
                      color: Colors.deepPurple,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}

Future<BrandScreenModel> getProduct(http.Client client) async {
  final response = await client.get(Uri.parse(BASE_URL + "brand_list"),
      headers: {'apikey': "914c9e52e6414d9494e299708d176a41"});
  print("Status Code " + response.statusCode.toString());
  print("Request Url " + response.request!.url.toString());
  print(response.body);
  return BrandScreenModel.fromJson(jsonDecode(response.body));
}
