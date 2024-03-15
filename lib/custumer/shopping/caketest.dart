import 'package:appbirthdaycake/config/api.dart';
import 'package:appbirthdaycake/custumer/model/order_model.dart';
import 'package:flutter/material.dart';

class OrderHistoryPage extends StatelessWidget {
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

  @override
  void initState() {
    //readOrder();
    // super.initState();
    //finduser();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blue.shade200,
          title: Center(
            child: Text('Order History'),
          )),
      body: ListView(
        children: [
          OrderItemWidget(
            orderNumber: 'ORD001',
            orderDate: '22 พฤษภาคม 2023',
            orderStatus: 'จัดส่งแล้ว',
          ),
          OrderItemWidget(
            orderNumber: 'ORD002',
            orderDate: '20 พฤษภาคม 2023',
            orderStatus: 'กำลังจัดเตรียมสินค้า',
          ),
          // เพิ่ม OrderItemWidget เพิ่มเติมได้ตามต้องการ
        ],
      ),
    );
  }
}

class OrderItemWidget extends StatelessWidget {
  final String orderNumber;
  final String orderDate;
  final String orderStatus;
  final List<String> productImages; // เพิ่มรายการรูปสิ่งค้า

  const OrderItemWidget({
    this.orderNumber,
    this.orderDate,
    this.orderStatus,
    this.productImages,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: ExpansionTile(
        title: Text(orderNumber),
        subtitle: Text(orderDate),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                // ระบบจัดการการกดปุ่ม Share
              },
            ),
            IconButton(
              icon: Icon(Icons.star_border),
              onPressed: () {
                // ระบบจัดการการกดปุ่มให้คะแนน
              },
            ),
          ],
        ),
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('รายละเอียดการสั่งซื้อ:'),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: productImages.length,
                  itemBuilder: (context, index) {
                    return Image.network(
                        productImages[index]); // แสดงรูปสิ่งค้า
                  },
                ),
                // เพิ่มรายละเอียดการสั่งซื้อเพิ่มเติมตามต้องการ
              ],
            ),
          ),
        ],
      ),
    );
  }
}
