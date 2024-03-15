import 'dart:convert';

import 'package:appbirthdaycake/config/api.dart';
import 'package:appbirthdaycake/config/approute.dart';
import 'package:appbirthdaycake/custumer/model/order_model.dart';
import 'package:appbirthdaycake/custumer/model/user_model.dart';
import 'package:appbirthdaycake/style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  OrderModel orderModel;
  UserModel userModel;
  String order_id, date_time, emp_id;
  double lat1, lng1, lat2, lng2;
  String distanceString;
  int transport;
  Position userlocation;
  CameraPosition position;
  List<LatLng> polylineCoordinates = [];
  GoogleMapController _controller;
  List<UserModel> userModels = [];

  @override
  void initState() {
    super.initState();
    //orderModel = widget.orderModel;
    //emp_id = orderModel.empId;
    // order_id = orderModel.orderId;
    // date_time = orderModel.orderDateTime;
    //FindUserWhererider();
    findLatLng();
    //getPolyPoints();
  }

  Future<void> findLatLng() async {
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
        print("lat1 ===$lat1 lat2 ===> $lng1");
      });
    } catch (e) {
      // จัดการข้อผิดพลาดที่อาจเกิดขึ้นในการขอตำแหน่งที่ตั้ง
      print('Error: $e');
    }
  }

  // Future<Null> FindUserWhererider() async {
  //   if (userModels.length != 0) {
  //     userModels.clear();
  //   }
  //   String url =
  //       '${API
  //       .BASE_URL}/flutterapi/getUserriderWhereId.php?isAdd=true&id=$emp_id';
  //
  //   await Dio().get(url).then((value) {
  //     var result = json.decode(value.data);
  //     for (var item in result) {
  //       userModel = UserModel.fromJson(item);
  //     }
  //   });
  // }

  Widget showNoData(BuildContext context) => const Center(
        child: Text("ยังไม่มีข้อมูล"),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        backgroundColor: Colors.blue[200],
        elevation: 0,
        title: Text(''),
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
      body: lat1 == null ? Style().showProgress() : showList(),
    );
  }

  Future refresh() async {
    await Future.delayed(
      Duration(seconds: 3),
    );
    findLatLng();
  }

  Widget showList() => Column(
        children: [
          buildMap(),
          ListTile(
            leading: "" == null
                ? Style().showProgress()
                : Container(
                    // width: 50,
                    // height: 50,
                    child: Icon(Icons.perm_identity)),
            title: Text('ที่จัดส่ง : ${"userModel.name"}'),
          ),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text('ติดต่อ : ${"userModel.phone"}'),
          ),
        ],
      );

  Container buildMap() {
    return Container(
      height: 500,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(lat1, lng1),
          zoom: 11,
        ),
        polylines: {
          Polyline(
            polylineId: PolylineId('route'),
            points: polylineCoordinates,
            color: Color.fromARGB(255, 15, 50, 80),
            width: 10,
          ),
        },
        markers: mySet(),
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
        },
        //markers: mySet(),
      ),
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

  Marker shopMarker() {
    return Marker(
      markerId: MarkerId('ShopMarker'),
      position: LatLng(7.174831068712594, 100.59590248041171),
      icon: BitmapDescriptor.defaultMarkerWithHue(150.0),
      infoWindow: InfoWindow(
        title: 'อยู่ที่นี่ร้าน ',
      ),
    );
  }

  Set<Marker> mySet() {
    return <Marker>[userMarker(), shopMarker()].toSet();
  }
}
