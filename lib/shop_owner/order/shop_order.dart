import 'dart:convert';

import 'package:appbirthdaycake/config/api.dart';
import 'package:appbirthdaycake/config/approute.dart';
import 'package:appbirthdaycake/custumer/model/order_model.dart';
import 'package:appbirthdaycake/style.dart';
import 'package:appbirthdaycake/widgets/dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../custumer/model/usermodel.dart';

class ShopOrderPage extends StatefulWidget {
  const ShopOrderPage({Key key}) : super(key: key);

  @override
  State<ShopOrderPage> createState() => _ShopOrderPageState();
}

class _ShopOrderPageState extends State<ShopOrderPage> {
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
  void initState() {
    readOrderProduct();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            showListOrdercake(),
          ],
        ),
      ),
    );
  }

  Widget showListOrdercake() {
    return ListView.builder(
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: orderModels.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          color: index % 2 == 0 ? Colors.blue.shade50 : Colors.blue.shade50,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Image.network(
                    API.CN_IMAGE + orderModels[index].imgcake,
                    width: 80, // กำหนดความกว้างของรูป
                    height: 80, // กำหนดความสูงของรูป
                    fit: BoxFit.cover, // กำหนดวิธีการปรับขนาดของรูป
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'คุณ ${orderModels[index].userName}',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16, // กำหนดขนาดตัวอักษรเป็น 16
                        color: Colors.blue.shade400, // กำหนดสีตัวอักษรเป็นสีดำ
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'คำสั่งซื้อที่ : ${orderModels[index].orderId}',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16, // กำหนดขนาดตัวอักษรเป็น 16
                        color: Colors.blue.shade400, // กำหนดสีตัวอักษรเป็นสีดำ
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'เวลาสั่งซื้อ :${orderModels[index].orderDateTime}',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16, // กำหนดขนาดตัวอักษรเป็น 16
                        color: Colors.blue.shade400, // กำหนดสีตัวอักษรเป็นสีดำ
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.blue
                                    .shade300), // เปลี่ยนสีพื้นหลังเป็นสีแดง
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            // เปลี่ยนสีตัวอักษรเป็นสีขาว
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                                context, AppRoute.orderDetailRoute,
                                arguments: orderModels[index]);
                          },
                          child: Text("See more"),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.blue
                                    .shade300), // เปลี่ยนสีพื้นหลังเป็นสีแดง
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            // เปลี่ยนสีตัวอักษรเป็นสีขาว
                          ),
                          onPressed: () {
                            updateStatusCompleteOrder(index).then((value) {
                              setState(() {
                                readOrderProduct();
                                Navigator.pop(context);
                              });
                            });
                          },
                          child: Text("Finish The Cake"),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
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
        '${API.BASE_URL}/flutterapi/src/getOrderwherestatus_Shopprocess.php?isAdd=true';

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

  Future<Null> updateStatusCompleteOrder(int index) async {
    String order_id = orderModels[index].orderId;
    String path =
        '${API.BASE_URL}/flutterapi/src/editStatusWhereuser_id.php?isAdd=true&status=Delivery&order_id=$order_id';

    await Dio().get(path).then((value) {
      if (value.toString() == 'true') {
        NotificationtoShop(index);
        normalDialog2(context, 'ยืนยันรายการที่ $order_id', 'ทำเค้กเสร็จแล้ว');
      }
    });
  }

  Future<Null> NotificationtoShop(int index) async {
    String id = orderModels[index].userId;
    String url =
        '${API.BASE_URL}/flutterapi/src/getUserriderWhereId.php?isAdd=true&id=$id';
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
      'ได้แจ้งลุกค้าทำเค้กวันเกิดเสร็จแล้ว',
      '',
      platformChannelSpecifics,
      payload: 'item x',
    );
    await Dio().get(url).then((value) {
      var result = json.decode(value.data);
      print('result ==> ${result}');
      for (var item in result) {
        userModel = CUsertable.fromJson(item);
        String tokenUser = userModel.token;
        print('tokenshop ====> $tokenUser');
        String title =
            "คุณ ${userModel.name} ทางร้านได้ทำเค้กของคุณเสร็จแล้ว";
        String body = "ทางร้านกำลังจะจัดส่งเค้กให้คุณ";
        String urlsendToken =
            "${API.BASE_URL}/flutterapi/src/notification.php?isAdd=true&token=$tokenUser&title=$title&body=$body";
        sendNotificationToShop(urlsendToken);
      }
    });
  }

  Future<Null> sendNotificationToShop(String urlsendToken) async {
    await Dio().get(urlsendToken).then(
          (value) => print('notification Success'),
        );
  }
}
