import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:appbirthdaycake/config/api.dart';
import 'package:appbirthdaycake/config/approute.dart';
import 'package:appbirthdaycake/custumer/model/cake_n_model.dart';
import 'package:appbirthdaycake/custumer/model/cart_model.dart';
import 'package:appbirthdaycake/helper/sqlite.dart';
import 'package:appbirthdaycake/widgets/dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/usermodel.dart';

class PayMentPage extends StatefulWidget {
  @override
  State<PayMentPage> createState() => _PayMentPageState();
}

class _PayMentPageState extends State<PayMentPage> {
  //List<CakeSize> cakesikeModels = [];
  List<CartModel> cartModels = [];
  List<List<String>> listgasids = [];
  List<int> listamounts = [];
  CakeNModel cakens;
  int total = 0;
  int quantityInt = 0;
  bool status = true;
  CUsertable userModel;
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

  Future<void> sendNotification() async {
    String tokenUser = userModel.token;
    String username = userModel.user;
    String title = "มีคำสั่งซื้อเค้กวันเกิดจากลูกค้า";
    String body = "คุณได้สั่งซื้อเค้กเรียบร้อยแล้วรอการยืนยันจากร้าน";
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

  File file;

  void _pickImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    final XFile pickedImage = await _picker.pickImage(
      source: source,
      maxWidth: 800,
      maxHeight: 800,
    );

    if (pickedImage != null) {
      File file = File(pickedImage.path);
      setState(() {
        this.file = file;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'Peyment',
          style: TextStyle(color: Colors.blue[300]),
        ),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.blue[200],
          ),
          onPressed: () {
            Navigator.pushNamed(context, AppRoute.HomeRoute);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Image.asset("assets/images/prompay_h.png"),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.blue.shade200), // เปลี่ยนสีพื้นหลังเป็นสีแดง
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8)), // เปลี่ยนสีตัวอักษรเป็นสีขาว
                ),
                onPressed: () => _pickImage(ImageSource.gallery),
                //style: ElevatedButton.styleFrom(primary: Colors.pinkAccent.shade50),
                child: Row(
                  children: [
                    Icon(Icons.image_outlined),
                    Text('PICK FROM GALLERY')
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  if (file == null) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('กรุณาแนบสลิปก่อนชำระเงิน!'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('ตกลง'),
                            ),
                          ],
                        );
                      },
                    );
                    return;
                  }
                  if (cartModels.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text(
                              'ยังไม่มีสินค้าในตะกร้า กรุณาเลือกสินค้าก่อนชำระเงิน!'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('ตกลง'),
                            ),
                          ],
                        );
                      },
                    );
                    return;
                  }
                  orderThread();
                  sendNotification();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.blue.shade200), // เปลี่ยนสีพื้นหลังเป็นสีแดง
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8)), // เปลี่ยนสีตัวอักษรเป็นสีขาว
                ),
                child: Row(
                  children: [Icon(Icons.assignment_turned_in), Text('SUMMIT')],
                ),
              ),
            ),
            file == null
                ? Container(
                    width: 300,
                    height: 300,
                    child: Image.asset('assets/images/galary.png'))
                : Image.file(file),
          ],
        ),
      ),
    );
    // );
  }

  Future<void> processUploadInsertData() async {
    String apisaveSlip = '${API.BASE_URL}/flutterapi/src/saveSlip.php';
    String nameSlip = 'slip${Random().nextInt(1000000)}.jpg';

    try {
      Map<String, dynamic> map = {};
      map['file'] = await MultipartFile.fromFile(file.path, filename: nameSlip);
      FormData data = FormData.fromMap(map);
      await Dio().post(apisaveSlip, data: data).then((value) async {
        String imageSlip = '/flutterapi/images/slip/$nameSlip';
        print('value == $value');
        DateTime dateTime = DateTime.now();
        // print(dateTime.toString());
        String slipDateTime = DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
        SharedPreferences preferences = await SharedPreferences.getInstance();
        String userId = preferences.getString('id');
        String userName = preferences.getString('name');
        String path =
            '${API.BASE_URL}/flutterapi/src/addpayment.php?isAdd=true&slip_date_time=$slipDateTime&image_slip=$imageSlip&order_id=none&user_id=$userId&user_name=$userName&emp_id=none';
        await Dio().get(path).then((value) {
          print("upload success");
        });
      });
    } catch (e) {}
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
        '${API.BASE_URL}/flutterapi/src/addOrder.php?isAdd=true&order_date_time=$order_date_time&user_id=$user_id&user_name=$user_name&distance=$distance&transport=$transport&cake_id=$cake_id&imgcake=$imgcakes&text=$text&cake_flavor=$cakeflavor&size=$size&price=$price&amount=$amount&sum=$count&pickup_date=$pickupDate&payment_status=userorder&status=ชำระเงินปลายทาง';

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
}
