import 'package:appbirthdaycake/custumer/HomeScreen/homebody.dart';
import 'package:appbirthdaycake/custumer/HomeScreen/profile.dart';
import 'package:appbirthdaycake/custumer/HomeScreen/profile_page.dart';
import 'package:appbirthdaycake/custumer/shopping/cart_order.dart';
import 'package:appbirthdaycake/custumer/shopping/cart_page.dart';
import 'package:appbirthdaycake/custumer/shopping/history_page.dart';
import 'package:appbirthdaycake/custumer/shopping/homehistory.dart';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String nameUser;

  int currentIndex = 0;
  final screens = [
    HomeBodyPage(),
    //CartOrderPage(),
    CartPage(),
    HomeHistoryPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        drawer: Drawer(
          child: Column(
            children: [
              SizedBox(
                height: 70,
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blue[500],
          unselectedItemColor: Colors.blue[300],
          iconSize: 20,
          //showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: currentIndex,
          onTap: (index) => setState(() => currentIndex = index),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Home',
              backgroundColor: Colors.blue[400],
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined),
                label: 'Cart',
                backgroundColor: Colors.blue[400]),
            BottomNavigationBarItem(
                icon: Icon(Icons.history_toggle_off),
                label: 'History',
                backgroundColor: Colors.blue[400]),
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
                backgroundColor: Colors.blue[400]),
          ],
        ),
        body: screens[currentIndex]);
  }
}
