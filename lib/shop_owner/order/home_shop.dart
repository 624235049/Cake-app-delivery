import 'package:appbirthdaycake/config/approute.dart';
import 'package:appbirthdaycake/shop_owner/order/order_delivery.dart';
import 'package:appbirthdaycake/shop_owner/order/order_finish.dart';
import 'package:appbirthdaycake/shop_owner/order/shop_order.dart';
import 'package:flutter/material.dart';

class HomeShopPage extends StatefulWidget {
  const HomeShopPage({Key key}) : super(key: key);

  @override
  State<HomeShopPage> createState() => _HomeShopPageState();
}

class _HomeShopPageState extends State<HomeShopPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // จำนวนแท็บ
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[300],
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, AppRoute.HomeShopOwnerRoute);
            },
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text(
                  'ORDERLIST',
                  style: TextStyle(color: Colors.white,fontSize: 15), // สีของตัวอักษรในแท็บ
                ),
              ),
              Tab(
                child: Text(
                  'DELIVERY',
                  style: TextStyle(color: Colors.white,fontSize: 15), // สีของตัวอักษรในแท็บ
                ),
              ),
              Tab(
                child: Text(
                  'FINISH',
                  style: TextStyle(color: Colors.white,fontSize: 15), // สีของตัวอักษรในแท็บ
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // วิตเจ็ตสำหรับแท็บที่ 1
            ShopOrderPage(),
            // วิตเจ็ตสำหรับแท็บที่ 2
            OrderliveryPage(),
            OrderFinishPage()
          ],
        ),
      ),
    );
  }
}
