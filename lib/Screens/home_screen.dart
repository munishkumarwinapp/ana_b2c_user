import 'package:ana_exports_b2c/Screens/brand_screen.dart';
import 'package:ana_exports_b2c/Screens/dash_board_screen.dart';
import 'package:ana_exports_b2c/Screens/product_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  final screens = [
    const DashBoardScreen(),
    const ProductScreen(
      categoryCode: "",
    ),
    // const ProductScreen(
    //   categoryCode: "",
    // ),
    const BrandScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        body: screens[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            backgroundColor: Colors.green,
            selectedFontSize: 15,
            unselectedFontSize: 10,
            onTap: (value) => setState(() {
                  currentIndex = value;
                }),
            currentIndex: currentIndex,
            items: const [
              BottomNavigationBarItem(
                  label: "Home", icon: Icon(Icons.dialpad_sharp)),
              BottomNavigationBarItem(
                  label: "Products", icon: Icon(Icons.shopping_bag)),
              BottomNavigationBarItem(
                  label: "Brand", icon: Icon(Icons.branding_watermark_sharp)),
            ]));
  }
}
