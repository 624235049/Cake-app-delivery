import 'dart:convert';

import 'package:appbirthdaycake/config/api.dart';
import 'package:appbirthdaycake/config/approute.dart';
import 'package:appbirthdaycake/custumer/model/Cake_size_model.dart';
import 'package:appbirthdaycake/custumer/model/cake_n_model.dart';
import 'package:appbirthdaycake/custumer/model/cart_model.dart';
import 'package:appbirthdaycake/custumer/model/order_model.dart';
import 'package:appbirthdaycake/widgets/dialog.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:appbirthdaycake/helper/sqlite.dart';

import '../../style.dart';
import '../model/usermodel.dart';

class CartBody extends StatefulWidget {
  @override
  State<CartBody> createState() => _CartBodyState();
}

class _CartBodyState extends State<CartBody> {
  String id;
  List<CakeSize> cakesikeModels = [];
  List<CartModel> cartModels = [];
  List<List<String>> listgasids = [];
  List<CUsertable> cUsertable = [];
  List<int> listamounts = [];
  CakeNModel cakens;
  int total = 0;
  int quantityInt = 0;
  bool status = true;
  CUsertable userModel;
  List<usertable> userModels = [];

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    userModel = CUsertable();
    //  id = userModel.id;
    FindUser();
    readSQLite();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Your Cart",
            style: TextStyle(
                fontFamily: 'Bebas',
                fontSize: 30,
                fontWeight: FontWeight.w500,
                color: Colors.blue.shade200),
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        child: Column(
          children: [
            buildlistCake(),
            Expanded(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: buildCheckoutCard()),
            ),
          ],
        ),
      ),
    );
  }

  Future<Null> FindUser() async {
    String url =
        '${API.BASE_URL}/flutterapi/src/getUserriderWhereId.php?isAdd=true&id=8';
    try {
      final response = await Dio().get(url);
      var result = json.decode(response.data);
      print('result ==> $result');
      for (var item in result) {
        userModel = CUsertable.fromJson(item);
      }
    } catch (e) {
      print("Failed to find user: $e");
    }
  }

  Future<void> sendNotification() async {
    String tokenUser = userModel.token;
    String username = userModel.user;
    String title = "มีคำสั่งซื้อเค้กวันเกิดจากลูกค้า";
    String body = "กรุณากดยืนยันหรือยกเลิกเพื่อแจ้งให้ลูกค้าทราบ";
    String url =
        "${API.BASE_URL}/flutterapi/src/notification.php?isAdd=true&token=$tokenUser&title=$title&body=$body";
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'คุณได้สั่งเค้กวันเกิดเรียบร้อบแล้ว',
      'รอทางร้านยืนยันออเดอร์',
      platformChannelSpecifics,
      payload: 'item x',
    );
    try {
      final response = await Dio().get(url);
      if (response.statusCode == 200) {
        print("send ==> ${tokenUser}");
        print("send Noti Success");
      } else {
        throw Exception('Failed to send notification');
      }
    } catch (e) {
      print("Failed to send notification: $e");
    }
  }

  // Future<void> sendNotification() async {
  //   String tokenUser = userModel.token;
  //   String title = "มีออเดอร์";
  //   String body = "มีลูกค้าสั่งเค้ก";
  //   String url = "${API.BASE_URL}/flutterapi/src/notification.php?isAdd=true&token=$tokenUser&title=$title&body=$body";
  //
  //   try {
  //     await Dio().get(url);
  //     print("send ==> ${tokenUser}");
  //     print("send Noti Success");
  //   } catch (e) {
  //     print("Failed to send notification: $e");
  //   }
  // }

  Future<Null> readSQLite() async {
    var object = await SQLiteHlper().readAllDataFormSQLite();
    print('object length ==> ${object.length}');
    int newTotal = 0; // สร้างตัวแปรใหม่เพื่อเก็บค่า total ที่ถูกคำนวณใหม่
    if (object.length != 0) {
      for (var model in object) {
        String sumString = model.sum;
        int sumInt = int.parse(sumString);
        newTotal += sumInt; // เพิ่มราคาสินค้าลงในตัวแปร newTotal
      }
    }
    setState(() {
      status = object.isEmpty; // ถ้า object ว่างเปล่าก็ให้ status เป็น true
      cartModels = object;
      total = newTotal; // กำหนดค่า total ให้เท่ากับ newTotal
    });
  }

  Future<Null> orderThread() async {
    DateTime dateTime = DateTime.now();
    // print(dateTime.toString());
    String order_date_time = DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
    String distance = cartModels[0].distance;
    String transport = cartModels[0].transport;
    String pickupDate = cartModels[0].cake_date;
    String imgcakes = cartModels[0].cake_img;
    String cake_ids = cartModels[0].cake_id;
    String sizes = cartModels[0].cake_size;
    String texts = cartModels[0].cake_text;
    String cakeflavors = cartModels[0].cake_flavor;
    String prices = cartModels[0].price;
    String amounts = cartModels[0].amount;
    String sums = cartModels[0].sum;

    String cake_id = cake_ids.toString();
    String price = prices.toString();
    String size = sizes.toString();
    String amount = amounts.toString();
    String count = sums.toString();
    String text = texts.toString();
    String cakeflavor = cakeflavors.toString();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String user_id = preferences.getString('id');
    String user_name = preferences.getString('name');

    String url =
        '${API.BASE_URL}/flutterapi/src/addOrder.php?isAdd=true&order_date_time=$order_date_time&user_id=$user_id&user_name=$user_name&distance=$distance&transport=$transport&cake_id=$cake_id&imgcake=$imgcakes&text=$text&cake_flavor=$cakeflavor&size=$size&price=$price&amount=$amount&sum=$count&pickup_date=$pickupDate&payment_status=userorder&status=ชำระเงินแล้ว';

    await Dio().get(url).then((value) {
      if (value.toString() == 'true') {
        //updateQtyGas(amount, gas_id);
        clearOrderSQLite();
        //notificationtoShop(user_name);
      } else {
        normalDialog(context, 'ไม่สามารถสั่งซื้อได้กรุณาลองใหม่');
      }
    });
  }

  Future<Null> clearOrderSQLite() async {
    await SQLiteHlper().deleteAllData().then(
      (value) {
        normalDialog2(
            context, "สั่งซื้อสำเร็จ", "รอรับสินค้าตรวจสอบการสั่งซื้อ");
        readSQLite();
      },
    );
  }

  Widget buildlistCake() => SingleChildScrollView(
        child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: cartModels.length,
          itemBuilder: (context, index) {
            return Card(
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 5, bottom: 5),
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.network(
                            API.CN_IMAGE + cartModels[index].cake_img,
                            width: double.maxFinite,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'หมายเลขเค้ก : ${cartModels[index].cake_id}',
                              style: TextStyle(
                                //fontWeight: FontWeight.w600,
                                color: Colors.blue.shade400,
                              ),
                              maxLines: 2,
                            ),
                            Text(
                              "รสชาติ : ${cartModels[index].cake_flavor}",
                              style: TextStyle(
                                //fontWeight: FontWeight.w600,
                                color: Colors.blue.shade400,
                              ),
                              maxLines: 2,
                            ),
                            Text(
                              "ขนาด : ${cartModels[index].cake_size}",
                              style: TextStyle(
                                //fontWeight: FontWeight.w600,
                                color: Colors.blue.shade400,
                              ),
                              maxLines: 2,
                            ),
                            Text(
                              "ข้อความบนเค้ก : ${cartModels[index].cake_text}",
                              style: TextStyle(
                                //fontWeight: FontWeight.w600,
                                color: Colors.blue.shade400,
                              ),
                              maxLines: 2,
                            ),
                            Text(
                              "วันที่นัดรับ : ${cartModels[index].pickup_date}",
                              style: TextStyle(
                                //fontWeight: FontWeight.w600,
                                color: Colors.blue.shade400,
                              ),
                              maxLines: 2,
                            ),
                            SizedBox(height: 10),
                            Text.rich(
                              TextSpan(
                                text: "${cartModels[index].price} ฿",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green,
                                ),
                                children: [
                                  TextSpan(
                                    text: " x${cartModels[index].amount}",
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 5),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 40,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.cancel,
                          color: Colors.redAccent,
                        ),
                        onPressed: () async {
                          int id = cartModels[index].id;
                          print('You Click delete id = $id');
                          await SQLiteHlper()
                              .deleteDataWhereId(id)
                              .then((value) {
                            print('delete Success id =$id');
                            readSQLite();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );

  Widget buildCheckoutCard() {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 30,
      ),
      // height: 174,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Color(0xFFDADADA).withOpacity(0.15),
          )
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F6F9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.monetization_on, color: Colors.amber),
                ),
                Spacer(),
                Text("Proceed to Payment"),
                const SizedBox(width: 10),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 20,
                  color: Colors.blue.shade300,
                )
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    text: "TOTAL:\n",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue.shade300,
                        fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: "${total.toString()} THB",
                        style: TextStyle(fontSize: 20, color: Colors.redAccent),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    // Container(
                    //   margin: EdgeInsets.only(bottom: 20, right: 20),
                    //   height: 50,
                    //   width: 150,
                    //   child: ElevatedButton.icon(
                    //     style: ElevatedButton.styleFrom(
                    //       primary: Colors.blue.shade200,
                    //     ),
                    //     onPressed: () {
                    //       orderThread();
                    //       sendNotification();
                    //     },
                    //     label: Text(
                    //       'ชำระเงินปลายทาง',
                    //       style: TextStyle(color: Colors.white),
                    //     ),
                    //     icon: Icon(
                    //       Icons.add_shopping_cart_sharp,
                    //       color: Colors.white,
                    //     ),
                    //   ),
                    // ),
                    Container(
                      margin: EdgeInsets.only(bottom: 20, right: 20),
                      height: 50,
                      width: 150,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue.shade200,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoute.PeymentRoute);
                        },
                        label: Text(
                          'ชำระเงิน',
                          style: TextStyle(color: Colors.white),
                        ),
                        icon: Icon(
                          Icons.add_shopping_cart_sharp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
