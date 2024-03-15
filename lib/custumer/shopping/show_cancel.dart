import 'dart:convert';

import 'package:appbirthdaycake/config/api.dart';
import 'package:appbirthdaycake/custumer/model/order_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/usermodel.dart';

class Showcancel extends StatefulWidget {
  const Showcancel({Key key}) : super(key: key);

  @override
  State<Showcancel> createState() => _ShowcancelState();
}

class _ShowcancelState extends State<Showcancel> {
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
                  subtitle1: TextStyle(
                    color:
                        Colors.blue.shade400, // กำหนดสีของตัวอักษรใน dropdown
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
              title: Text(
                'คำสั่งซื้อที่ : ${orderModels[index].orderId}',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold // กำหนดสีของตัวอักษรใน dropdown
                    ),
              ),
              subtitle: Text(
                'เวลาสั่งซื้อ : ${orderModels[index].orderDateTime}',
                style: TextStyle(
                  color: Colors.black, // กำหนดสีของตัวอักษรใน dropdown
                ),
              ),
              trailing: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      Text(
                        'CANCEL',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ],
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
                                    color: Colors.redAccent
                                        .shade400, // กำหนดสีของตัวอักษรใน dropdown
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
        '${API.BASE_URL}/flutterapi/src/getOrderWhereuser_idandstatus_cancel.php?isAdd=true&user_id=$user_id&status=Cancel';

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
