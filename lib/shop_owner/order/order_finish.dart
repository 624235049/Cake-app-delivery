import 'dart:convert';

import 'package:appbirthdaycake/config/api.dart';
import 'package:appbirthdaycake/config/approute.dart';
import 'package:appbirthdaycake/custumer/model/order_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class OrderFinishPage extends StatefulWidget {
  const OrderFinishPage({Key key}) : super(key: key);

  @override
  State<OrderFinishPage> createState() => _OrderFinishPageState();
}

class _OrderFinishPageState extends State<OrderFinishPage> {
  List<OrderModel> orderModels = [];

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
                    Text(
                      'สถานะการสั่งซื้อ :${orderModels[index].status}',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16, // กำหนดขนาดตัวอักษรเป็น 16
                        color: Colors.blue.shade400, // กำหนดสีตัวอักษรเป็นสีดำ
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    // Row(
                    //   children: [
                    //     ElevatedButton(
                    //       style: ButtonStyle(
                    //         backgroundColor: MaterialStateProperty.all<Color>(
                    //             Colors.pink
                    //                 .shade100), // เปลี่ยนสีพื้นหลังเป็นสีแดง
                    //         foregroundColor:
                    //         MaterialStateProperty.all<Color>(Colors.white),
                    //         // เปลี่ยนสีตัวอักษรเป็นสีขาว
                    //       ),
                    //       onPressed: () {
                    //         //Navigator.pushNamed(context, AppRoute.orderDetailRoute,arguments: orderModels[index]);
                    //       },
                    //       child: Text("See more"),
                    //     ),
                    //     SizedBox(
                    //       width: 10,
                    //     ),
                    //   ],
                    // ),
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
    }

    final path =
        '${API.BASE_URL}/flutterapi/src/getOrderwherestatus_Finish.php?isAdd=true';

    final response = await Dio().get(path);

    final result = jsonDecode(response.data);
    for (final item in result) {
      final model = OrderModel.fromJson(item);


      setState(() {
        orderModels.add(model);
      });
    }
  }
}
