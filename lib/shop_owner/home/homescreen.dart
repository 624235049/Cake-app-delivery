import 'package:appbirthdaycake/custumer/HomeScreen/logout.dart';
import 'package:appbirthdaycake/custumer/HomeScreen/profile.dart';
import 'package:appbirthdaycake/shop_owner/home/homebody_so.dart';
import 'package:appbirthdaycake/shop_owner/home/profileso.dart';
import 'package:appbirthdaycake/shop_owner/order/order_cakecomfrim.dart';
import 'package:appbirthdaycake/shop_owner/order/order_detail.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HomeShopOwner extends StatefulWidget {
  @override
  _HomeShopOwnerState createState() => _HomeShopOwnerState();
}

class _HomeShopOwnerState extends State<HomeShopOwner> {
  int currentIndex = 0;
  final screens = [
    HomeBodyShopOwner(),
    OrderPage(),
    ProFileShopPage(),
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
        selectedItemColor: Colors.blue[200],
        unselectedItemColor: Colors.blue[50],
        iconSize: 20,
        showUnselectedLabels: false,
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Home',
              backgroundColor: Colors.blue[200]),
          BottomNavigationBarItem(
              icon: Icon(Icons.apps_rounded),
              label: 'Confirm',
              backgroundColor: Colors.blue[200]),
          BottomNavigationBarItem(
              icon: Icon(Icons.article_outlined),
              label: 'Profile',
              backgroundColor: Colors.blue[200]),
        ],
      ),
      body: screens[currentIndex],
    );
  }
}
