import 'dart:convert';

import 'package:appbirthdaycake/config/api.dart';
import 'package:appbirthdaycake/config/approute.dart';
import 'package:appbirthdaycake/custumer/model/order_model.dart';
import 'package:appbirthdaycake/shop_owner/order/mapdelivery.dart';
import 'package:appbirthdaycake/style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class OrderliveryPage extends StatefulWidget {
  const OrderliveryPage({Key key}) : super(key: key);

  @override
  State<OrderliveryPage> createState() => _OrderliveryPageState();
}

class _OrderliveryPageState extends State<OrderliveryPage> {
  List<OrderModel> orderModels = [];
  List<List<String>> listPrices = [];
  List<List<String>> listSums = [];
  List<int> totals = [];
  List<List<String>> listusers = [];

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
                  child: Image.asset('assets/images/imageC.png'
                   ,
                    width: 80, // กำหนดความกว้างของรูป
                    height: 80, // กำหนดความสูงของรูป
                    fit: BoxFit.cover, // กำหนดวิธีการปรับขนาดของรูป
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
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
                        'สถานะการชำระเงิน :${orderModels[index].paymentStatus}',
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
                              '${orderModels[index].sum} THB',
                              style: Style().mainhATitle,
                            ),
                          ],
                        ),
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
                              //Navigator.pushNamed(context, AppRoute.orderDetailRoute,arguments: orderModels[index]);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FollowMapCustomerPage(
                                    orderModel : orderModels[index],
                                  ),
                                ),
                              );
                            },
                            child: Text("Delivery"),
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
                              //Navigator.pushNamed(context, AppRoute.orderDetailRoute,arguments: orderModels[index]);
                              Navigator.pushNamed(context, AppRoute.SignatureRoute
                              );
                            },
                            child: Text("SIGNATURE"),
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
    if (orderModels.isNotEmpty) {
      orderModels.clear();
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
      final price = API().createStringArray(model.price);
      final pricesums = API().createStringArray(model.sum);
      final user_id = API().createStringArray(model.userId);

      var total = 0;
      for (final item in pricesums) {
        total += int.parse(item);
      }

      setState(() {
        orderModels.add(model);
        listPrices.add(price);
        listSums.add(pricesums);
        totals.add(total);
        listusers.add(user_id);
      });
    }
  }
}

