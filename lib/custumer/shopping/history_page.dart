import 'dart:convert';
import 'package:appbirthdaycake/config/api.dart';
import 'package:appbirthdaycake/config/approute.dart';
import 'package:appbirthdaycake/custumer/model/order_model.dart';
import 'package:appbirthdaycake/custumer/model/review_model.dart';
import 'package:appbirthdaycake/style.dart';
import 'package:appbirthdaycake/widgets/dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:steps_indicator/steps_indicator.dart';

import '../model/usermodel.dart';

class HistoryPage extends StatefulWidget {
  final OrderModel orderModel;
  const HistoryPage({Key key, this.orderModel}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
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
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.blue.withOpacity(0.8), width: 0.5),
          ),
          child: ExpansionTile(
            initiallyExpanded: true,
            title: Text(
              'คำสั่งซื้อที่ : ${orderModels[index].orderId}',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                // กำหนดสีของตัวอักษรใน dropdown
              ),
            ),
            subtitle: Text(
              'เวลาสั่งซื้อ : ${orderModels[index].orderDateTime}',
              style: const TextStyle(
                color: Colors.black,
                // กำหนดสีของตัวอักษรใน dropdown
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
                    SizedBox(
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
                    SizedBox(
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
                                  color: Colors.blue
                                      .shade300, // กำหนดสีของตัวอักษรใน dropdown
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
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    flex: 20,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (orderModels[index].status == 'shopprocess') {
                          normalDialog2(context, 'ไม่สามารถยกเลิกการสั่งซื้อ',
                              'เนื่องจากร้านได้ยืนยันการสั่งซื้อของคุณแล้ว กรุณาติดต่อทางร้านค่ะ!');
                        } else if (orderModels[index].status == 'RiderHandle') {
                          normalDialog2(context, 'ไม่สามารถยกเลิกการสั่งซื้อ',
                              'เนื่องจากกำลังจัดสั่งรายแก๊สให้คุณ กรุณาติดต่อทางร้านค่ะ!');
                        } else if (orderModels[index].status == 'Finish') {
                          normalDialog2(
                              context,
                              'รายการสั่งซื้อของท่านสำเร็จแล้ว!',
                              'กรุณาติดต่อทางร้านค่ะ');
                        } else if (orderModels[index].status == 'userorder') {
                          readOrder();
                          confirmDeleteCancleOrder(index);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.redAccent,
                        elevation: 0,
                        //padding: EdgeInsets.zero,
                      ),
                      child: Text('ยกเลิกการสั่งซื้อ'),
                    ),
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

  Future<Null> confirmDeleteCancleOrder(int index) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('คุณต้องการจะยกเลิกรายการสั่งเค้กใช่ไหม ?'),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  primary: Colors.green,
                ),
                onPressed: () async {
                  cancleOrderUser(index);
                  sendCancelNotification();
                  readOrder();
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.check,
                  color: Colors.white,
                ),
                label: Text(
                  'ตกลง',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  primary: Colors.red,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.clear,
                  color: Colors.white,
                ),
                label: Text(
                  'ยกเลิก',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<Null> cancleOrderUser(int index) async {
    String order_id = orderModels[index].orderId;
    String url =
        '${API.BASE_URL}/flutterapi/src/cancleOrderWhereorderId.php?isAdd=true&status=Cancel&order_id=$order_id';

    await Dio().get(url).then((value) {
      readOrder();
      normalDialog2(
          context, 'ยกเลิกรายการสั่งซื้อสำเร็จ', 'รายการสั่งซื้อที่ $order_id');
    });
  }

  Future<Null> finduser() async {
    setState(() {
      loadStatus = false;
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    user_id = preferences.getString('id');
    print('user_id ==> $user_id');
    readOrder();
  }

  Future<Null> readOrder() async {
    String url =
        '${API.BASE_URL}/flutterapi/src/getOrderWhereuser_idandstatus.php?isAdd=true&user_id=$user_id&status=userorder';

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

  void showPopup(BuildContext context) {
    int _rating = 0;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/images/preview.png'),
                SizedBox(height: 200),
                Text(
                  'รีวิวหลังใช้บริการ',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.all(6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () => setState(() => _rating = 1),
                        icon: Icon(Icons.star_border),
                        color: _rating >= 1 ? Colors.orange : Colors.grey,
                      ),
                      IconButton(
                        onPressed: () => setState(() => _rating = 2),
                        icon: Icon(Icons.star_border),
                        color: _rating >= 2 ? Colors.orange : Colors.grey,
                      ),
                      IconButton(
                        onPressed: () => setState(() => _rating = 3),
                        icon: Icon(Icons.star_border),
                        color: _rating >= 3 ? Colors.orange : Colors.grey,
                      ),
                      IconButton(
                        onPressed: () => setState(() => _rating = 4),
                        icon: Icon(Icons.star_border),
                        color: _rating >= 4 ? Colors.orange : Colors.grey,
                      ),
                      // IconButton(
                      //   onPressed: () => setState(() => _rating = 5),
                      //   icon: Icon(Icons.star_border),
                      //   color: _rating >= 5 ? Colors.orange : Colors.grey,
                      // ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.blue[300], shape: StadiumBorder()),
                    onPressed: () => _submitRating(),
                    child: Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
                    color: Colors.blue.shade300, fontWeight: FontWeight.w600),
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
                  child: const Text(
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

  Future<void> _submitRating() async {
    int _rating = 0;
    List<ReviewModel> reviewModels = [];

    // สร้าง ReviewModel จาก _rating และเวลาปัจจุบัน
    final review = ReviewModel(score: _rating.toString());

    // เพิ่ม ReviewModel เข้าไปยังฐานข้อมูล
    String url =
        '${API.BASE_URL}/flutterapi/src/addreview.php?isAdd=true&score=${review.score}';

    await Dio().get(url).then((value) {
      if (value.toString() == 'true') {
        // อัปเดตข้อมูลใน state
        setState(() {
          reviewModels.add(review);
          _rating = 0;
        });

        // แสดง SnackBar เพื่อบอกให้ผู้ใช้ทราบว่าเรียบร้อยแล้ว
        // final snackBar = SnackBar(content: Text('Review submitted!'));
        // ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      //void _submitRating() {
    });
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
