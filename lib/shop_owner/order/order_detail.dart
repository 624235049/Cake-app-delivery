import 'dart:convert';
import 'dart:ffi';
import 'package:appbirthdaycake/config/api.dart';
import 'package:appbirthdaycake/config/approute.dart';
import 'package:appbirthdaycake/custumer/model/cake_n_model.dart';
import 'package:appbirthdaycake/custumer/model/cart_model.dart';
import 'package:appbirthdaycake/custumer/model/order_model.dart';
import 'package:appbirthdaycake/widgets/dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../custumer/model/usermodel.dart';

class OrderDetailPage extends StatefulWidget {
  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  OrderModel order;
  List<OrderModel> orderModels = [];
  List<List<String>> listCake = [];
  List<List<String>> listAmounts = [];
  List<List<String>> listPrices = [];
  List<List<String>> listSums = [];
  List<int> totals = [];
  List<List<String>> listusers = [];
  CUsertable userModel;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  @override
  Void initSate() {
    order = OrderModel();
    readOrderProduct();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Object arguments = ModalRoute.of(context).settings.arguments;
    if (arguments is OrderModel) {
      order = arguments;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.blue.shade100,
          ),
          onPressed: () {
            Navigator.pushNamed(context, AppRoute.HomeOrderRoute);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                //color: Colors.pink.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(API.CN_IMAGE + order.imgcake),
                      SizedBox(height: 15),
                      Card(
                        color: Colors.blue.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  'CAKE DETAIL',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                    color: Colors.blue
                                        .shade400, // กำหนดขนาดตัวอักษรเป็น 16
                                    //color: Colors.black, // กำหนดสีตัวอักษรเป็นสีดำ
                                  ),
                                ),
                              ),
                              SizedBox(height: 15),
                              Text(
                                'User Name: ${order.userName}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20,
                                  color: Colors.blue
                                      .shade400, // กำหนดขนาดตัวอักษรเป็น 16
                                  //color: Colors.black, // กำหนดสีตัวอักษรเป็นสีดำ
                                ),
                              ),
                              SizedBox(height: 15),
                              Text(
                                'Order ID: ${order.orderId}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20,
                                  color: Colors.blue
                                      .shade400, // กำหนดขนาดตัวอักษรเป็น 16
                                  //color: Colors.black, // กำหนดสีตัวอักษรเป็นสีดำ
                                ),
                              ),
                              SizedBox(height: 15),
                              Text(
                                'วันที่นัดรับ: ${order.pickup_date}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20,
                                  color: Colors.blue
                                      .shade400, // กำหนดขนาดตัวอักษรเป็น 16
                                  //color: Colors.black, // กำหนดสีตัวอักษรเป็นสีดำ
                                ),
                              ),
                              SizedBox(height: 15),
                              Text(
                                'ขนาดเค้ก : ${order.size}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20,
                                  color: Colors.blue
                                      .shade400, // กำหนดขนาดตัวอักษรเป็น 16
                                  //color: Colors.black, // กำหนดสีตัวอักษรเป็นสีดำ
                                ),
                              ),
                              SizedBox(height: 15),
                              Text(
                                'ข้อความหน้าเค้ก : ${order.text}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20,
                                  color: Colors.blue
                                      .shade400, // กำหนดขนาดตัวอักษรเป็น 16
                                  //color: Colors.black, // กำหนดสีตัวอักษรเป็นสีดำ
                                ),
                              ),
                              SizedBox(height: 15),
                              Text(
                                'จำนวน : ${order.amount}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20,
                                  color: Colors.blue
                                      .shade400, // กำหนดขนาดตัวอักษรเป็น 16
                                  //color: Colors.black, // กำหนดสีตัวอักษรเป็นสีดำ
                                ),
                              ),
                              SizedBox(height: 15),
                              Text(
                                'Payment Status: ${order.paymentStatus}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20,
                                  color: Colors.blue
                                      .shade400, // กำหนดขนาดตัวอักษรเป็น 16
                                  //color: Colors.black, // กำหนดสีตัวอักษรเป็นสีดำ
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // สามารถแสดงข้อมูลเพิ่มเติมได้ตามต้องการ// แสดงรายการสินค้า
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.blue.shade100), // เปลี่ยนสีพื้นหลังเป็นสีแดง
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8)), // เปลี่ยนสีตัวอักษรเป็นสีขาว
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    Icon(Icons.assignment_turned_in),
                    Text('เสร็จแล้ว')
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> readOrderProduct() async {
    if (orderModels.isNotEmpty) {
      orderModels.clear();
      listCake.clear();
      listAmounts.clear();
      listPrices.clear();
      listSums.clear();
      totals.clear();
      listusers.clear();
    }

    final path =
        '${API.BASE_URL}/flutterapi/src/getOrderwherestatus_Delivery.php?isAdd=true';

    final response = await Dio().get(path);

    final result = jsonDecode(response.data);
    for (final item in result) {
      final model = OrderModel.fromJson(item);
      final namecake = API().createStringArray(model.imgcake);
      final amount = API().createStringArray(model.amount);
      final price = API().createStringArray(model.price);
      final pricesums = API().createStringArray(model.sum);
      final user_id = API().createStringArray(model.userId);

      var total = 0;
      for (final item in pricesums) {
        total += int.parse(item);
      }

      setState(() {
        orderModels.add(model);
        listCake.add(namecake);
        listAmounts.add(amount);
        listPrices.add(price);
        listSums.add(pricesums);
        totals.add(total);
        listusers.add(user_id);
      });
    }
  }

  // Future<Null> updateStatusCompleteOrder(int index) async {
  //   String order_id = order.orderId;
  //   String path =
  //       '${API.BASE_URL}/flutterapi/src/editStatusWhereuser_id.php?isAdd=true&status=Delivery&order_id=$order_id';
  //
  //   await Dio().get(path).then((value) {
  //     if (value.toString() == 'true') {
  //       normalDialog2(context, 'ยืนยันรายการที่ $order_id', 'ทำเค้กเสร็จแล้ว');
  //       Navigator.pop(context);
  //     }
  //   });
  // }

  // Future<Null> NotificationtoShop(int index) async {
  //   String id = orderModels[index].userId;
  //   String url =
  //       '${API.BASE_URL}/flutterapi/src/getUserriderWhereId.php?isAdd=true&id=$id';
  //   const AndroidNotificationDetails androidPlatformChannelSpecifics =
  //       AndroidNotificationDetails(
  //     'your_channel_id',
  //     'your_channel_name',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //     ticker: 'ticker',
  //   );
  //   const NotificationDetails platformChannelSpecifics =
  //       NotificationDetails(android: androidPlatformChannelSpecifics);
  //   await flutterLocalNotificationsPlugin.show(
  //     0,
  //     'ได้แจ้งกำลังจัดส่งออเดอร์ที่ ${orderModels[index].orderId}แล้ว',
  //     '',
  //     platformChannelSpecifics,
  //     payload: 'item x',
  //   );
  //   await Dio().get(url).then((value) {
  //     var result = json.decode(value.data);
  //     print('result ==> ${result}');
  //     for (var item in result) {
  //       userModel = CUsertable.fromJson(item);
  //       String tokenUser = userModel.token;
  //       print('tokenshop ====> $tokenUser');
  //       String title =
  //           "คุณ ${userModel.name} ทางร้านได้ยืนยันการสั่งซื้อของคุณแล้ว";
  //       String body = "ทางร้านกำลังดำเนินการทำเค้ก";
  //       String urlsendToken =
  //           "${API.BASE_URL}/flutterapi/src/notification.php?isAdd=true&token=$tokenUser&title=$title&body=$body";
  //       sendNotificationToShop(urlsendToken);
  //     }
  //   });
  // }
  //
  // Future<Null> sendNotificationToShop(String urlsendToken) async {
  //   await Dio().get(urlsendToken).then(
  //         (value) => print('notification Success'),
  //       );
  // }
}
