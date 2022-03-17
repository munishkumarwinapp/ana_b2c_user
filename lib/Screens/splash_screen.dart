import 'dart:convert';

import 'package:ana_exports_b2c/Models/splash_model.dart';
import 'package:ana_exports_b2c/Screens/home_screen.dart';
import 'package:flutter/material.dart';

import '../constant.dart';
import 'package:http/http.dart' as http;

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);
   

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/ana_splash.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder<SplashScreenModel>(
            future: getBanner(http.Client()),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.result.isNotEmpty) {
                  var data = snapshot.data!.result;
                  splash = data;

                  for (var item in splash) {
                    responseImage.add(item.path + item.image);
                  }                  
                  return  HomeScreen();
                } else {
                  return Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/ana_splash.png"),
                          fit: BoxFit.cover,
                        ),
                      ));
                }
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/ana_splash.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: null,
                );
              } else {
                return Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/ana_splash.png"),
                        fit: BoxFit.cover,
                      ),
                    ));
              }
            }),
      ),
    );
  }
}

Future<SplashScreenModel> getBanner(http.Client client) async {
  final response = await client.get(Uri.parse(BASE_URL + "getBanners"),
      headers: {'apikey': "914c9e52e6414d9494e299708d176a41"});
  print("Status Code " + response.statusCode.toString());
  print("Request Url " + response.request!.url.toString());
  print(response.body);
  return SplashScreenModel.fromJson(jsonDecode(response.body));
  ;
}
SplashScreenModel parseData(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<SplashScreenModel>((json) => SplashScreenModel.fromJson(json))
      .toList();
}
