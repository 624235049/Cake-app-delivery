import 'dart:convert';
import 'package:appbirthdaycake/config/api.dart';
import 'package:appbirthdaycake/config/approute.dart';
import 'package:appbirthdaycake/custumer/HomeScreen/app_icon.dart';
import 'package:appbirthdaycake/custumer/HomeScreen/big_text.dart';
import 'package:appbirthdaycake/custumer/model/order_model.dart';
import 'package:appbirthdaycake/custumer/model/order_model.dart';
import 'package:appbirthdaycake/services/network.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../custumer/model/usermodel.dart';
import '../../fuction.dart';
import '../../style.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List<OrderModel> orderModels = [];
  List<List<String>> listCake = [];
  List<List<String>> listAmounts = [];
  List<List<String>> listPrices = [];
  List<List<String>> listSums = [];
  List<int> totals = [];
  List<List<String>> listusers = [];
  List<usertable> userModels = [];
  OrderModel orderModel;
  CUsertable userModel;
  String user_id;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


  @override
  void initState() {
    readOrderProduct();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            //toolbarHeight: 40,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(10),
              child: Container(
                child: Center(
                    child: BigText(
                  text: "Confirm Order Cake",
                  size: 26,
                )),
                width: double.maxFinite,
                padding: EdgeInsets.only(top: 5, bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
              ),
            ),
            pinned: true,
            backgroundColor: Colors.blue.shade100,
            expandedHeight: 20,
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  showListOrdercake(),
                ],
              ),
            ),
          )
        ],
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
                SizedBox(width: 5,),
                Expanded(
                  child: Column(
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
                      Text(
                        'หมายเลขเค้ก : ${orderModels[index].cakeId}',
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
                        'ขนาดเค้ก : ${orderModels[index].size}',
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
                        'จำนวน : ${orderModels[index].amount}',
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
                        'ข้อความหน้าเค้ก : ${orderModels[index].text}',
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
                        'ราคา : ${orderModels[index].price}',
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
                        'สถานะการชำระเงิน : ${orderModels[index].paymentStatus}',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16, // กำหนดขนาดตัวอักษรเป็น 16
                          color: Colors.blue.shade400, // กำหนดสีตัวอักษรเป็นสีดำ
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      // Style()
                      //     .showTitleH3('รหัสผู้จัดส่ง : ${orderModels[index].empId}'),
                      Text(
                        'สถานะการจัดส่ง : รอการยืนยัน',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16, // กำหนดขนาดตัวอักษรเป็น 16
                          color: Colors.blue.shade400, // กำหนดสีตัวอักษรเป็นสีดำ
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        padding: EdgeInsets.all(4.0),
                        child: Row(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'รวมทั้งหมด :  ',
                                  style: Style().mainh1Title,
                                ),
                              ],
                            ),
                            Text(
                              '${orderModels[index].sum.toString()} THB',
                              style: Style().mainhATitle,
                            ),
                          ],
                        ),
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
                                      .shade100), // เปลี่ยนสีพื้นหลังเป็นสีแดง
                              foregroundColor:
                                  MaterialStateProperty.all<Color>(Colors.white),
                              // เปลี่ยนสีตัวอักษรเป็นสีขาว
                            ),
                            onPressed: () {
                              updateStatusConfirmOrder(index).then((value) {
                                setState(() {
                                  readOrderProduct();
                                });
                              });
                            },
                            child: Text("Confirm Order"),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.red
                                      .shade400), // เปลี่ยนสีพื้นหลังเป็นสีแดง
                              foregroundColor:
                                  MaterialStateProperty.all<Color>(Colors.white),
                              // เปลี่ยนสีตัวอักษรเป็นสีขาว
                            ),
                            onPressed: () {
                              cancleOrderUser(index);
                            },
                            child: Text("Cancel"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> readOrderProduct() async {
    final path =
        '${API.BASE_URL}/flutterapi/src/getOrderwherestatus_Userorder.php?isAdd=true';

    final response = await Dio().get(path);
    print('response ==> $response');
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

  Future<Null> updateStatusConfirmOrder(int index) async {
    String order_id = orderModels[index].orderId;
    String path =
        '${API.BASE_URL}/flutterapi/src/editStatusWhereuser_id.php?isAdd=true&status=shopprocess&order_id=$order_id';

    await Dio().get(path).then(
      (value) {
        if (value.toString() == 'true') {
          NotificationtoShop(index);
          normalDialog2(context, 'ยืนยันรายการที่ $order_id', 'ดำเนินการต่อไป');
        }
      },
    );
  }

  Future<Null> cancleOrderUser(int index) async {
    String order_id = orderModels[index].orderId;
    String url =
        '${API.BASE_URL}/flutterapi/src/cancleOrderWhereorderId.php?isAdd=true&status=Cancel&order_id=$order_id';

    await Dio().get(url).then((value) {
      setState(() {
        NotificationCanceltoShop(index);
        readOrderProduct();
      });
      normalDialog2(
          context, 'ยกเลิกรายการสั่งซื้อสำเร็จ', 'รายการสั่งซื้อที่ $order_id');
    });
  }

  // Future<void> sendNotification(int index) async {
  //   String tokenUser = userModel.token;
  //   String username = userModel.name;
  //   String title = "ลูกค้าได้ตรวจสอบและรับเค้กเรียบร้อยแล้ว";
  //   String body = "ได้จัดส่งออเดอร์เสร็จสิ้นแล้ว";
  //   String url = "${API.BASE_URL}/flutterapi/src/notification.php?isAdd=true&token=$tokenUser&title=$title&body=$body";
  //   const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
  //     'your_channel_id',
  //     'your_channel_name',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //     ticker: 'ticker',
  //   );
  //   const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
  //   await flutterLocalNotificationsPlugin.show(
  //     0,
  //     'ขอบคุณที่ใช้บริการร้านเค้กสั่งได้',
  //     'อย่าลืมประเมินความพึงพอใจหลังใช้บริการนะคุณลูกค้า',
  //     platformChannelSpecifics,
  //     payload: 'item x',
  //   );
  //   try {
  //     final response = await Dio().get(url);
  //     if (response.statusCode == 200) {
  //       print("send ==> ${tokenUser}");
  //       print("send Noti Success");
  //     } else {
  //       throw Exception('Failed to send notification');
  //     }
  //   } catch (e) {
  //     print("Failed to send notification: $e");
  //   }
  // }

  Future<Null> NotificationtoShop(int index) async {
    String id = orderModels[index].userId;
    String url =
        '${API.BASE_URL}/flutterapi/src/getUserriderWhereId.php?isAdd=true&id=$id';
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'ได้แจ้งยืนยันการสั่งออเดอร์ที่${orderModels[index].orderId}แล้ว',
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
        String title = "คุณ ${userModel.name} ทางร้านได้ยืนยันการสั่งซื้อของคุณแล้ว";
        String body = "ทางร้านกำลังดำเนินการทำเค้ก";
        String urlsendToken = "${API.BASE_URL}/flutterapi/src/notification.php?isAdd=true&token=$tokenUser&title=$title&body=$body";
        sendNotificationToShop(urlsendToken);
      }
    });
  }

  Future<Null> NotificationCanceltoShop(int index) async {
    String id = orderModels[index].userId;
    String url =
        '${API.BASE_URL}/flutterapi/src/getUserriderWhereId.php?isAdd=true&id=$id';
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'ได้แจ้งยกเลิกการสั่งออเดอร์ที่ ${orderModels[index].orderId}แล้ว',
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
        String title = "ขออภัยในความไม่สะดวกทางร้านได้ยกเลิกออเดอร์ของคุณ";
        String body = "กรุณาติดต่อทงร้านหรือกดสั่งซื้อใหม่อีกครั้ง";
        String urlsendToken = "${API.BASE_URL}/flutterapi/src/notification.php?isAdd=true&token=$tokenUser&title=$title&body=$body";
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
