import 'dart:convert';

import 'package:ana_exports_b2c/Models/category_screen_model.dart';
import 'package:ana_exports_b2c/Screens/cart_screen.dart';
import 'package:ana_exports_b2c/Screens/product_screen.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';
import 'package:http/http.dart' as http;

import '../constant.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  // final List<String> listImages = [
  //   'assets/images/banner1.png',
  //   'assets/images/kalamart_banner.png',
  // ];

  final bool _isPlaying = false;
  // final List<Map> myProducts =
  //     List.generate(101, (index) => {"id": index, "name": "Product $index"})
  //         .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: loginbackground,
      appBar: AppBar(
        title: const Text(
          "Dash Board",
        ),
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
                  style: TextStyle(color: Colors.white),
                ),
                child: const Icon(Icons.production_quantity_limits),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 200,
            width: MediaQuery.of(context).size.width,
            child: CarouselSlider.builder(
                unlimitedMode: true,
                enableAutoSlider: true,
                slideBuilder: (index) {
                  return FadeInImage(
                    image: NetworkImage(responseImage[index]),
                    placeholder:
                        const AssetImage("assets/images/no_image.jpeg"),
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset('assets/images/no_image.jpeg',
                          fit: BoxFit.fitWidth);
                    },
                    fit: BoxFit.cover,
                    height: 125,
                    width: MediaQuery.of(context).size.width,
                  );
                },
                initialPage: 0,
                slideTransform: const CubeTransform(),
                itemCount: responseImage.length),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Categories",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          FutureBuilder<CategoryScreenModel>(
              future: getCateogry(http.Client()),
              builder: (context, snapShot) {
                if (snapShot.hasData) {
                  return Expanded(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 200,
                                  childAspectRatio: 2 / 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10),
                          itemCount: snapShot.data!.data.length,
                          itemBuilder: (BuildContext ctx, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProductScreen(
                                            categoryCode: snapShot
                                                .data!.data[index].categoryCode
                                                .toString(),
                                          )),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    color: Colors.white,
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.transparent,
                                        blurRadius: 5.0,
                                        spreadRadius: 5.0,
                                        offset: Offset(5.0, 5.0),
                                      )
                                    ],
                                    border:
                                        Border.all(color: Colors.transparent)),
                                child: ClipOval(
                                  child: FadeInImage.assetNetwork(
                                    placeholder: 'assets/images/no_image.jpeg',
                                    image: IMAGE_BASE_URL +
                                        snapShot.data!.data[index].image!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  );
                } else if (snapShot.hasError) {
                  print(snapShot.error);
                  return const Center(
                    child: Text(
                      "Sorry Some thing wrong Please try again",
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple),
                    ),
                  );
                } else {
                  return Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.25),
                      child: CircularProgressIndicator());
                }
              }),
        ],
      ),
    );
  }
}

Future<CategoryScreenModel> getCateogry(http.Client client) async {
  final response = await client.get(Uri.parse(BASE_URL + "category_list"),
      headers: {'apikey': "914c9e52e6414d9494e299708d176a41"});
  print("Status Code " + response.statusCode.toString());
  print("Request Url " + response.request!.url.toString());
  print(response.body);
  return CategoryScreenModel.fromJson(jsonDecode(response.body));
  ;
}
