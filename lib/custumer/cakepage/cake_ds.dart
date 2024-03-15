import 'dart:convert';
import 'dart:ffi';
import 'dart:ui' as ui;
import 'dart:io';
import 'dart:math';
import 'package:appbirthdaycake/config/api.dart';
import 'package:appbirthdaycake/style.dart';
import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:appbirthdaycake/custumer/model/Cake_size_model.dart';
import 'package:appbirthdaycake/custumer/model/cake_n_model.dart';
import 'package:appbirthdaycake/custumer/model/cart_model.dart';
import 'package:appbirthdaycake/helper/sqlite.dart';
import 'package:appbirthdaycake/widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/usermodel.dart';

class CakeDesignPage extends StatefulWidget {
  const CakeDesignPage({Key key}) : super(key: key);

  @override
  State<CakeDesignPage> createState() => _CakeDesignPageState();
}

class _CakeDesignPageState extends State<CakeDesignPage> {
  String cake_id;
  List<CartModel> cartModels = [];
  String img;
  String selectedCakeSize;
  String selectedCakeFlavor;
  String sizeIds;
  String pricecake;
  int _quantiy = 0;
  String pickupdate;
  var cake_date = TextEditingController();
  var size_cake = TextEditingController();
  var cake_detail = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TextEditingController dateController = TextEditingController();
  int sizeId;
  List<CakeSize> cakesizes = [];
  bool confirmOrder = false;
  int total = 0;
  File file;
  CUsertable userModel;
  List<usertable> userModels = [];
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initSate() {
    cake_date.dispose();
    size_cake.dispose();
    cake_detail.dispose();
    super.initState();
  }

  @override
  void initState() {
    userModel = CUsertable();
    //  id = userModel.id;
    FindUser();
    super.initState();
  }

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

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("2lbs"), value: "2lbs"),
      DropdownMenuItem(child: Text("3lbs"), value: "3lbs"),
      DropdownMenuItem(child: Text("4lbs"), value: "4lbs"),
      DropdownMenuItem(child: Text("5lbs"), value: "5lbs"),
    ];
    return menuItems;
  }

  List<DropdownMenuItem<String>> get dropdownCake {
    List<DropdownMenuItem<String>> flavorItems = [
      DropdownMenuItem(child: Text("ช็อกโกแลต"), value: "ช็อกโกแลต"),
      DropdownMenuItem(child: Text("วานิลา"), value: "วานิลา"),
      DropdownMenuItem(child: Text("ผลไม้"), value: "ผลไม้"),
    ];
    return flavorItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back_ios_new),),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.shopping_cart_outlined),
                )
              ],
            ),
            elevation: 0,
            bottom: PreferredSize(
                child: Container(
                  //margin: EdgeInsets.only(left: 26)
                  child: Center(
                      child: Text(
                    'Cake Order Details',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  )),
                  width: double.maxFinite,
                  padding: EdgeInsets.only(top: 5, bottom: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      )),
                ),
                preferredSize: ui.Size.fromHeight(0)),
            pinned: true,
            expandedHeight: 400,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  color: Colors.blue.shade200, // เปลี่ยนสีพื้นหลังเป็นสีน้ำเงิน
                ),
                child: file == null
                    ? InkWell(
                        onTap: () => _pickImage(ImageSource.gallery),
                        child: Container(
                            width: 300,
                            height: 300,
                            child: Image.asset('assets/images/galary.png')),
                      )
                    : Image.file(file),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        'ขนาดเค้ก',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            showPopup(context);
                          },
                          icon: Icon(
                            Icons.help_outline,
                            color: Colors.red.shade400,
                          ))
                    ],
                  ),
                ),
                Container(
                  width: 350,
                  child: DropdownButtonFormField(
                    value: selectedCakeSize,
                    items: dropdownItems,
                    onChanged: (String value) {
                      setState(() {
                        selectedCakeSize = value;
                        switch (selectedCakeSize) {
                          case "2lbs":
                            pricecake = '300';
                            break;

                          case "3lbs":
                            pricecake = '400';
                            break;

                          case "4lbs":
                            pricecake = '500';
                            break;

                          case "5lbs":
                            pricecake = '600 ';
                            break;

                          default:
                            pricecake = "";
                            break;
                        }
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    children: [
                      Text(
                        'เวลานัดรับเค้ก',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                birthDayFormField(),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    children: [
                      Text(
                        'ข้อความหน้าเค้ก',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: TextFormField(
                      controller: cake_detail,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        //hintText: 'Text',
                        //icon: Icon(Icons.email)
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    children: [
                      const Text(
                        'รสชาติเค้ก',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: 350,
                  child: DropdownButtonFormField(
                    value: selectedCakeFlavor,
                    items: dropdownCake,
                    onChanged: (String value) {
                      setState(() {
                        selectedCakeFlavor = value;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: 25,
                    right: 25,
                    top: 25,
                    bottom: 25,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (_quantiy < 20) {
                              _quantiy++;
                            }
                          });
                        },
                        child: Icon(Icons.add),
                      ),
                      Text("$_quantiy"),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (_quantiy > 0) {
                              _quantiy--;
                            }
                          });
                        },
                        child: Icon(Icons.remove),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 35,
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'ราคา',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            pricecake != null
                                ? "${pricecake.toString()} THB "
                                : "0 THB ",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20, right: 10),
                  height: 50,
                  width: 180,
                  child: ElevatedButton(
                    onPressed: () {
                      //print('price = $pricecake');
                      //addOrderToCart();
                      if (sizeId.toString().isEmpty ||
                          cake_detail.toString().isEmpty ||
                          _quantiy != 0) {
                        addOrderToCart();
                        //sendNotification();
                      } else {
                        normalDialog2(context, "กรุณาตรวจสอบคำสั่งซื้อ", "");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue[500],
                    ),
                    child: Text(
                      "Add Order",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<Null> FindUser() async {
    String url =
        '${API.BASE_URL}/flutterapi/src/getUserriderWhereId.php?isAdd=true&id=8';
    final response = await Dio().get(url);
    var result = json.decode(response.data);
    print('result ==> $result');
    for (var item in result) {
      userModel = CUsertable.fromJson(item);
    }
  }

  Future<Null> sendNotification() async {
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

  Future<Null> addOrderToCart() async {
    DateTime dateTime = DateTime.now();
    String order_date_time = DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
    String pickupDate = dateController.text;
    String cn_size = selectedCakeSize;
    String cn_text = cake_detail.text;
    String cn_cakeflavor = selectedCakeFlavor;
    String cn_price = pricecake.toString();
    int priceInt = int.parse(cn_price);
    int sumInt = priceInt * _quantiy;
    String amounts = _quantiy.toString();
    String sum = sumInt.toString();

    Random random = Random();
    int i = random.nextInt(100000);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String user_id = preferences.getString('id');
    String user_name = preferences.getString('name');
    String nameimage = 'no$i.jpg';
    String url = '${API.BASE_URL}/flutterapi/src/saveimage.php';

    try {
      Map<String, dynamic> map = Map();
      map['file'] =
          await MultipartFile.fromFile(file.path, filename: nameimage);
      FormData formData = FormData.fromMap(map);
      await Dio().post(url, data: formData).then((value) async {
        String cn_images = '$nameimage';
        String urlInsert =
            '${API.BASE_URL}/flutterapi/src/addOrder.php?isAdd=true&order_date_time=$order_date_time&user_id=$user_id&user_name=$user_name&distance=distance&transport=transport&cake_id=i&imgcake=$cn_images&text=$cn_text&cake_flavor=$cn_cakeflavor&size=$cn_size&price=$cn_price&amount=$amounts&sum=$sum&pickup_date=$pickupDate&payment_status=userorder&status=ชำระเงินปลายทาง';
        await Dio().get(urlInsert).then((value) async {
          bool confirmOrder = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('ยืนยันการสั่งซื้อ'),
                content: Text('คุณต้องการที่จะสั่งซื้อเลยใช่หรือไม่?'),
                actions: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors
                          .green), // กำหนดสีพื้นหลังเมื่อปุ่มไม่ได้ถูกแตะสัมผัส
                      foregroundColor: MaterialStateProperty.all<Color>(
                          Colors.white), // กำหนดสีข้อความภายในปุ่ม
                    ),
                    onPressed: () {
                      sendNotification();
                      Navigator.pop(context, true); // ส่งค่า true กลับไป
                    },
                    child: Text('ยืนยัน'),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors
                          .red), // กำหนดสีพื้นหลังเมื่อปุ่มไม่ได้ถูกแตะสัมผัส
                      foregroundColor: MaterialStateProperty.all<Color>(
                          Colors.white), // กำหนดสีข้อความภายในปุ่ม
                    ),
                    onPressed: () {
                      Navigator.pop(context, false); // ส่งค่า false กลับไป
                    },
                    child: Text('ยกเลิก'),
                  ),
                ],
              );
            },
          );

          if (confirmOrder != null && confirmOrder) {
            Navigator.pop(context);
          }
        });
      });
    } catch (e) {}
  }

  Widget birthDayFormField() {
    return Container(
      color: Colors.blue[50],
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: TextFormField(
        validator: (value) {
          if (value.toString().isEmpty) {
            return 'กรุณาเลือก ว/ด/ปี ที่นัดรับ';
          }
          return null; // คืนค่า null หากไม่มี error
        },
        decoration: InputDecoration(
          //labelText: "เลือกวัน",
          hintText: "เลือกวันส่ง",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
            icon: const Icon(Icons.calendar_today, color: Colors.blue),
            onPressed: () {
              selectDate(context);
            },
          ),
        ),
        controller: dateController,
        readOnly: true,
      ),
    );
  }

  void selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        dateController.text =
            '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}';
      });
    }
  }

  void showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            height: 250,
            width: 350,
            child: Image.asset(
              'assets/images/bb.png',
              width: 350,
              height: 400,
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                'OK',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade200,
                ),
              ),
              onPressed: () {
                // ปิดหน้าต่าง pop-up เมื่อกดปุ่ม OK
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
