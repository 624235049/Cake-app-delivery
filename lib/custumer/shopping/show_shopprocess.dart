import 'dart:convert';

import 'package:appbirthdaycake/config/api.dart';
import 'package:appbirthdaycake/config/approute.dart';
import 'package:appbirthdaycake/custumer/model/order_model.dart';
import 'package:appbirthdaycake/widgets/dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/usermodel.dart';

class ShowShopprocess extends StatefulWidget {
  const ShowShopprocess({Key key}) : super(key: key);

  @override
  State<ShowShopprocess> createState() => _ShowShopprocessState();
}

class _ShowShopprocessState extends State<ShowShopprocess> {
  OrderModel orderModel;
  String user_id;
  bool statusAvatar = true;
  bool loadStatus = true;
  List<OrderModel> orderModels = [];
  List<List<String>> listmenucake = [];
  List<List<String>> listPrices = [];
  List<List<String>> listAmounts = [];
  List<List<String>> listSums = [];
  List<int> totalInts = [];
  List<int> statusInts = [];
  List<List<String>> statusindexs = [];
  CUsertable userModel;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    FindUserId();
    finduser();
  }

  // @override
  // Widget build(BuildContext context) {
  //   return statusAvatar ? Style().showProgress() : buildcontent();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: showListOrdercake(),
    ));
  }

  Widget showListOrdercake() {
    return ListView.builder(
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: orderModels.length,
      itemBuilder: (context, index) => Card(
        margin: EdgeInsets.all(8.0),
        child: Theme(
          data: Theme.of(context).copyWith(
            textTheme: Theme.of(context).textTheme.copyWith(
                  subtitle1: const TextStyle(
                    color: Colors.white, // กำหนดสีของตัวอักษรใน dropdown
                  ),
                ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border:
                  Border.all(color: Colors.blue.withOpacity(0.8), width: 0.5),
            ),
            child: ExpansionTile(
              initiallyExpanded: true,
              title: Text(
                'คำสั่งซื้อที่ : ${orderModels[index].orderId}',
                style: TextStyle(
                  color: Colors.black, // กำหนดสีของตัวอักษรใน dropdown
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'เวลาสั่งซื้อ : ${orderModels[index].orderDateTime}',
                style: TextStyle(
                  color: Colors.black, // กำหนดสีของตัวอักษรใน dropdown
                ),
              ),
              children: [
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'รายละเอียดการสั่งซื้อ',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black, // กำหนดสีของตัวอักษรใน dropdown
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Image.network(
                          API.CN_IMAGE + orderModels[index].imgcake,
                          height: 200,
                          width: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'ขนาดเค้ก : ${orderModels[index].size}',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.black, // กำหนดสีของตัวอักษรใน dropdown
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'ข้อความหน้าเค้ก : ${orderModels[index].text}',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.black, // กำหนดสีของตัวอักษรใน dropdown
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'วันที่นัดรับ : ${orderModels[index].pickup_date}',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.black, // กำหนดสีของตัวอักษรใน dropdown
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'ราคา : ${orderModels[index].price}',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.black, // กำหนดสีของตัวอักษรใน dropdown
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'จำนวน : ${orderModels[index].amount}',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.black, // กำหนดสีของตัวอักษรใน dropdown
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'ราคารวม : ${orderModels[index].sum}',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.black, // กำหนดสีของตัวอักษรใน dropdown
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'สถานะการชำระเงิน : ${orderModels[index].paymentStatus}',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.black, // กำหนดสีของตัวอักษรใน dropdown
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'สถานะการสั่งซื้อ : ${orderModels[index].status}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors
                                        .black, // กำหนดสีของตัวอักษรใน dropdown
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (orderModels[index].status == 'shopprocess') {
                          normalDialog2(
                              context,
                              'กรุณารอเค้กก่อนกดตรวจสอบสินค้า',
                              'เนื่องจากร้านกำลังจัดส่งเค้กของคุณ');
                        } else if (orderModels[index].status == 'Delivery') {
                          readOrder();
                          sendNotification();
                          updateStatusCompleteOrder(index);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        elevation: 0,
                      ),
                      child: Text(
                        'ฉันได้ตรวจสอบและยอมรับสินค้า',
                        style: TextStyle(
                            fontFamily: 'Bebas',
                            fontSize: 18,
                            color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> FindUserId() async {
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
    String username = userModel.name;
    String title = "ลูกค้าได้ตรวจสอบและรับเค้กเรียบร้อยแล้ว";
    String body = "ได้จัดส่งออเดอร์เสร็จสิ้นแล้ว";
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
      'ขอบคุณที่ใช้บริการร้านเค้กสั่งได้',
      'อย่าลืมประเมินความพึงพอใจหลังใช้บริการนะคุณลูกค้า',
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

  Future<void> sendCancelNotification() async {
    String tokenUser = userModel.token;
    String username = userModel.name;
    String title = "ลูกค้าได้ยกเลิกออเดอร์แล้ว";
    String body = "โปรดรอออเดอร์ครั้งต่อไป";
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
      'คุณได้ทำการยกเลิกการสั่งซื้อแล้ว',
      '',
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

  Future<void> share() async {
    await FlutterShare.share(
      title: 'ร้านเค้กสั่ง',
      text: 'ยินดีตอนรับร้านเค้กสั่งสั่งเค้กวันเกิดกันเลย',
      linkUrl:
          'https://github.com/624235048/appbirthdaycake/blob/master/assets/images/share.jpg?raw=true',
    );
  }

  Future<Null> finduser() async {
    setState(() {
      loadStatus = false;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    user_id = preferences.getString('id');
    print('user_id ==> $user_id');
    readOrder();
    readOrderDelivery();
  }

  Future<Null> readOrderDelivery() async {
    String url =
        '${API.BASE_URL}/flutterapi/src/getOrderWhereuser_idandstatus_Delivery.php?isAdd=true&user_id=$user_id&status=Delivery';

    Response response = await Dio().get(url);
    print('response ==> $response');
    if (response.toString() != 'null') {
      var result = jsonDecode(response.data);
      for (var map in result) {
        final OrderModel model = OrderModel.fromJson(map);
        setState(() {
          orderModels.add(model);
        });
      }
    }
  }

  Future<Null> readOrder() async {
    String url =
        '${API.BASE_URL}/flutterapi/src/getOrderWhereuser_idandstatus_shoppro.php?isAdd=true&user_id=$user_id&status=shopprocess';

    Response response = await Dio().get(url);
    print('response ==> $response');
    if (response.toString() != 'null') {
      var result = jsonDecode(response.data);
      for (var map in result) {
        final OrderModel model = OrderModel.fromJson(map);
        setState(() {
          orderModels.add(model);
        });
      }
    }
  }

  Future<Null> updateStatusCompleteOrder(int index) async {
    String order_id = orderModels[index].orderId;
    String path =
        '${API.BASE_URL}/flutterapi/src/editStatusWhereuser_id.php?isAdd=true&status=Finish&order_id=$order_id';
    await Dio().get(path).then((value) {
      if (value.toString() == 'true') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'ตรวจสอบและรับสินค้า',
                style: TextStyle(
                    color: Colors.blue.shade200, fontWeight: FontWeight.w600),
              ),
              content: Container(
                height: 170,
                width: 170,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/Png-Icon-Check.png', // เพิ่มรูปภาพตรงนี้
                      width: 100,
                      height: 100,
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              actions: [
                TextButton(
                  child: Text(
                    'ปิด',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacementNamed(context, AppRoute.HomeRoute);
                  },
                ),
              ],
            );
          },
        );
      }
    });
  }

  Future<void> readOrderProduct() async {
    final path =
        '${API.BASE_URL}/flutterapi/src/getOrderwherestatus_Userorder.php?isAdd=true&user_id=$user_id';

    final response = await Dio().get(path);
    print('response ==> $response');
    final result = jsonDecode(response.data);
    for (final item in result) {
      final model = OrderModel.fromJson(item);
      final amount = API().createStringArray(model.amount);
      final price = API().createStringArray(model.price);
      final pricesums = API().createStringArray(model.sum);
      var total = 0;
      for (final item in pricesums) {
        total += int.parse(item);
      }
      setState(() {
        orderModels.add(model);
        listAmounts.add(amount);
        listPrices.add(price);
        listSums.add(pricesums);
      });
    }
  }

  List<String> changeArrey(String string) {
    List<String> list = [];
    String myString = string.substring(1, string.length - 1);
    print('myString = $myString');
    list = myString.split(',');
    int index = 0;
    for (var string in list) {
      list[index] = string.trim();
      index++;
    }
    return list;
  }
}
