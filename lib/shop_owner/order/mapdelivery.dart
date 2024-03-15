import 'dart:convert';

import 'package:appbirthdaycake/config/api.dart';
import 'package:appbirthdaycake/config/approute.dart';
import 'package:appbirthdaycake/custumer/model/order_model.dart';
import 'package:appbirthdaycake/custumer/model/usermodel.dart';
import 'package:appbirthdaycake/fuction.dart';
import 'package:appbirthdaycake/style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FollowMapCustomerPage extends StatefulWidget {
  final OrderModel orderModel;
  const FollowMapCustomerPage({
    Key key,
    this.orderModel,
  }) : super(key: key);

  @override
  State<FollowMapCustomerPage> createState() => _FollowMapCustomerPageState();
}

class _FollowMapCustomerPageState extends State<FollowMapCustomerPage> {
  OrderModel orderModel;
  CUsertable userModel;
  String user_id, username;
  double lat1, lng1, lat2, lng2;
  CameraPosition position;
  List<LatLng> polylineCoordinates = [];
  GoogleMapController _controller;
  List<usertable> userModels = [];
  List<OrderModel> orderModels = [];

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    orderModel = widget.orderModel;
    user_id = orderModel.userId;
    FindUserWhererider();
    findLatLng();
    super.initState();
  }

  Future<Null> findLatLng() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          // แสดงข้อความหรือทำการขออนุญาตเข้าถึงตำแหน่งที่ตั้ง
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // แสดงข้อความให้ผู้ใช้เปิดการตั้งค่าแอปพลิเคชันและให้แอปพลิเคชันเข้าถึงตำแหน่งที่ตั้ง
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        lat1 = position.latitude;
        lng1 = position.longitude;
        lat2 = double.parse(userModel.lat);
        lng2 = double.parse(userModel.lng);
        print("lat1 ===$lat1 lat2 ===> $lng1");
      });
    } catch (e) {
      // จัดการข้อผิดพลาดที่อาจเกิดขึ้นในการขอตำแหน่งที่ตั้ง
      print('Error: $e');
    }
  }

  Future<Null> FindUserWhererider() async {
    if (userModels.length != 0) {
      userModels.clear();
    }
    String url =
        '${API.BASE_URL}/flutterapi/src/getUserriderWhereId.php?isAdd=true&id=$user_id';

    await Dio().get(url).then((value) {
      var result = json.decode(value.data);
      print('result ==> ${result}');
      for (var item in result) {
        userModel = CUsertable.fromJson(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade100,
        title: Text(
          "Delivery",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.blue),
      ),
      body: lat1 == null || lng2 == null ? Style().showProgress() : showList(),
    );
  }

  Widget showList() => SingleChildScrollView(
        child: Column(
          children: [
            buildMap(),
            Container(
              color: Colors.blue.shade50,
              child: ListTile(
                leading: Icon(
                  Icons.phone,
                  color: Colors.teal,
                ),
                title: Text('ติดต่อ : ${userModel.phone}'),
              ),
            ),
            Container(
              color: Colors.blue.shade50,
              child: ListTile(
                leading: Icon(
                  Icons.accessibility,
                  color: Colors.blueAccent,
                ),
                title: Text('ชื่อลูกค้า คุณ : ${userModel.name}'),
              ),
            ),
            Container(
              color: Colors.blue.shade50,
              child: ListTile(
                leading: Icon(
                  Icons.man_rounded,
                  color: Colors.redAccent,
                ),
                title: Text('ที่อยู่ : ${userModel.address}'),
              ),
            ),
            Container(
              color: Colors.blue.shade50,
              child: ListTile(
                leading: Icon(
                  Icons.attach_money,
                  color: Colors.amber,
                ),
                title: Text('ราคารวม : ${orderModel.sum} บาท'),
              ),
            ),
            Container(
              color: Colors.blue.shade50,
              child: ListTile(
                leading: Icon(Icons.money, color: Colors.green),
                title: Text('สถานะการชำระเงิน : ${orderModel.paymentStatus}'),
              ),
            ),
            //SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      NotificationtoShop(orderModel);
                      updateStatusCompleteOrder(orderModel);
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.blue[100], shape: StadiumBorder()),
                    child: Text(
                      "FINISH",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Container buildMap() {
    return Container(
      height: 500,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(lat1, lng1),
          zoom: 16,
        ),
        polylines: {
          Polyline(
            polylineId: PolylineId('route'),
            points: polylineCoordinates,
            color: Color.fromARGB(255, 15, 50, 80),
            width: 10,
          ),
        },
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
        markers: mySet(),
      ),
    );
  }

  Marker riderMarker() {
    return Marker(
      markerId: MarkerId('userOrderMarker'),
      position: LatLng(lat2, lng2),
      icon: BitmapDescriptor.defaultMarkerWithHue(150.0),
      infoWindow: InfoWindow(
          title: 'ลูกค้าอยู่ที่นี่ ', snippet: 'รหัสลูกค้า${userModel.id}'),
    );
  }

  Marker userMarker() {
    return Marker(
      markerId: MarkerId('userMarker'),
      position: LatLng(lat1, lng1),
      icon: BitmapDescriptor.defaultMarkerWithHue(60.0),
      infoWindow: InfoWindow(
        title: 'คุณอยู่ที่นี่',
      ),
    );
  }

  Set<Marker> mySet() {
    return <Marker>[userMarker(), riderMarker()].toSet();
  }

  Future<Null> updateStatusCompleteOrder(OrderModel orderModel) async {
    String order_id = orderModel.orderId;
    String path =
        '${API.BASE_URL}/flutterapi/src/editStatusWhereuser_id.php?isAdd=true&status=Finish&order_id=$order_id';

    await Dio().get(path).then((value) {
      if (value.toString() == 'true') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'ยืนยันรายการที่ $order_id',
                style: TextStyle(
                    color: Colors.blue.shade200,
                    fontWeight: FontWeight.w600 // เปลี่ยนสีตรงนี้
                    ),
              ),
              content: Text(
                'ส่งเสร็จสิ้น',
                style: TextStyle(
                    color: Colors.blue.shade200,
                    fontWeight: FontWeight.w600 // เปลี่ยนสีตรงนี้
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
                        fontWeight: FontWeight.w600 // เปลี่ยนสีตรงนี้
                        ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      }
    });
  }

  Future<Null> NotificationtoShop(OrderModel orderModel) async {
    String id = orderModel.userId;
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
      'ได้จัดส่งออเดอร์ที่ ${orderModel.orderId}เสร็จแล้ว',
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
            "คุณ ${userModel.name} ทางร้านได้จัดส่งออเดอร์ของคุณเรียบร้อยแล้ว";
        String body = "กรุณาตรวจสอบและกดรับสินค้าขอบคุณที่ใช้บริการ";
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
