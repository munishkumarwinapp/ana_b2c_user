import 'dart:convert';
import 'package:ana_exports_b2c/Models/login_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userName = TextEditingController();
  final _passwordText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            ClipPath(
              clipper: WaveClipperOne(),
              child: Container(
                height: 240,
                color: Color(0xfff3AC7AA),
                child: const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Ana Exports",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        letterSpacing: .5,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            const Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
              child: Text(
                "Login",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            const Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0),
              child: Text(
                "User Name",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0),
              child: TextField(
                controller: _userName,
              ),
            ),
            const Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
              child: Text(
                "Password",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
              child: TextField(
                controller: _passwordText,
              ),
            ),
            Container(
                margin: EdgeInsets.fromLTRB(16.0, 48.0, 16.0, 0),
                child: ElevatedButton(
                    onPressed: () {
                      if (_userName.text.toString().isEmpty) {
                        MotionToast.error(
                          title: const Text(
                            'Error',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          description: Text('Please enter your name'),
                          animationType: ANIMATION.fromBottom,
                          position: MOTION_TOAST_POSITION.bottom,
                          // width: 300,
                        ).show(context);
                      } else if (_passwordText.text.toString().isEmpty) {
                        MotionToast.error(
                          title: const Text(
                            'Error',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          description: Text('Please enter your password'),
                          animationType: ANIMATION.fromBottom,
                          position: MOTION_TOAST_POSITION.bottom,
                          width: 300,
                        ).show(context);
                      } else {
                        loginServiceCall(
                            context,
                            http.Client(),
                            _userName.text.toString(),
                            _passwordText.text.toString());
                      }
                    },
                    child: Text("Login"))),
            const Padding(
              padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    "Don't have account ?, Register",
                    style: TextStyle(color: Colors.green),
                  )),
            ),
          ],
        ),
        bottomSheet: BottomAppBar(
          child: Container(
              width: MediaQuery.of(context).size.width,
              child: InkWell(
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  print(prefs.getString("username"));
                },
                child: const Text(
                  "Powerd by winapp it solution pte ltd",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
              )),
        ),
      ),
    );
  }
}

Future<LoginModel> loginServiceCall(BuildContext context, http.Client client,
    String userName, String password) async {
  debugPrint("Cat_CODE" + userName);
  EasyLoading.show(status: 'loading...');
  Map<String, dynamic> body = {'email': userName, 'password': password};
  String encodedBody = body.keys.map((key) => "$key=${body[key]}").join("&");

  final response = await client.post(Uri.parse(BASE_URL + "login"),
      headers: {
        'apikey': "914c9e52e6414d9494e299708d176a41",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: encodedBody);
  print("Status Code " + response.statusCode.toString());
  print("Request Url " + response.request.toString());
  print(response.body);
  EasyLoading.dismiss();
  if (LoginModel.fromJson(jsonDecode(response.body)).statusCode == 200) {
    if (LoginModel.fromJson(jsonDecode(response.body)).data[0].verified !=
        "1") {
      MotionToast.error(
        title: const Text(
          'Error',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        description: Text('User is not verified. Please verify first'),
        animationType: ANIMATION.fromBottom,
        position: MOTION_TOAST_POSITION.bottom,
        width: 300,
      ).show(context);
    } else if (LoginModel.fromJson(jsonDecode(response.body))
        .data[0]
        .customerCode
        .isEmpty) {
      MotionToast.error(
        title: const Text(
          'Error',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        description: Text('Invalid user please check your crediential'),
        animationType: ANIMATION.fromBottom,
        position: MOTION_TOAST_POSITION.bottom,
        width: 300,
      ).show(context);
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('email',
          LoginModel.fromJson(jsonDecode(response.body)).data[0].email);
      prefs.setString('customer_code',
          LoginModel.fromJson(jsonDecode(response.body)).data[0].customerCode);
      prefs.setString('customer_name',
          LoginModel.fromJson(jsonDecode(response.body)).data[0].customerName);
      prefs.setString('customer_phone_no',
          LoginModel.fromJson(jsonDecode(response.body)).data[0].phoneNo);
      Navigator.pop(context);
    }
  } else {
    MotionToast.error(
      title: const Text(
        'Error',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      description: Text('Login Failed, Please check your crediential'),
      animationType: ANIMATION.fromBottom,
      position: MOTION_TOAST_POSITION.bottom,
      width: 300,
    ).show(context);
  }

  return LoginModel.fromJson(jsonDecode(response.body));
}
