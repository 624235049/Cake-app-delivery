import 'package:appbirthdaycake/config/api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/usermodel.dart';

class EditMapPage extends StatefulWidget {
  const EditMapPage({Key key}) : super(key: key);

  @override
  State<EditMapPage> createState() => _EditMapPageState();
}

class _EditMapPageState extends State<EditMapPage> {
  List<CUsertable> userModels = [];
  CUsertable model;
  double Lat1, Lng1;
  double Lat, Lng;
  var _addressController = TextEditingController();
  double get latitude => Lat;

  double get longitude => Lng;
  LatLng selectedLocation;
  bool isLoading = true;

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    model = CUsertable();
    findLatLng().then((value) {
      setState(() {
        isLoading =
            false; // ตั้งค่า isLoading เป็น false เมื่อโหลดข้อมูลเสร็จสิ้น
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Object arguments = ModalRoute.of(context).settings.arguments;
    if (arguments is CUsertable) {
      model = arguments;
    }
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Edit Addree',
          style: TextStyle(color: Colors.blue.shade300),
        ),
      ),
      body: isLoading
          ? Center(
              child:
                  CircularProgressIndicator()) // แสดงสัญลักษณ์การโหลดเมื่อ isLoading เป็น true
          : GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              behavior: HitTestBehavior.opaque,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 500,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                              double.parse(model.lat), double.parse(model.lng)),
                          zoom: 15,
                        ),
                        onTap: (LatLng location) {
                          setState(() {
                            selectedLocation = location;
                          });
                        },
                        markers: selectedLocation != null
                            ? mySet().union({
                                Marker(
                                  markerId: MarkerId('selected_location'),
                                  position: selectedLocation,
                                ),
                              })
                            : mySet(),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[50],
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: TextFormField(
                            controller: _addressController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Address',
                              icon: Icon(Icons.account_balance),
                              labelText: 'Address :',
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue.shade500),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue.shade300),
                              ),
                            ),
                            readOnly: true,
                            onTap: () async {
                              final coordinates = Coordinates(
                                  selectedLocation.latitude,
                                  selectedLocation.longitude);
                              final addresses = await Geocoder.local
                                  .findAddressesFromCoordinates(coordinates);
                              final firstAddress = addresses.first;

                              setState(() {
                                _addressController.text =
                                    firstAddress.addressLine;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (selectedLocation != null) {
                          setState(() {
                            Lat = selectedLocation.latitude;
                            Lng = selectedLocation.longitude;
                          });
                          addLatLngToUser();
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('เพิ่มข้อมูลที่อยู่เรียบร้อยแล้ว'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('ตกลง'),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('เลือกตำแหน่ง'),
                                content: Text('กรุณาเลือกตำแหน่งบนแผนที่'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: Text('ตกลง'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue.shade300, // กำหนดสีพื้นหลัง
                      ),
                      child: Text(
                        'เลือกตำแหน่งนี้',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 30,
                      width: 150,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue.shade300, // สีพื้นหลังของปุ่ม
                          onPrimary: Colors.white, // สีข้อความภายในปุ่ม
                          textStyle:
                              TextStyle(fontSize: 16), // สไตล์ข้อความภายในปุ่ม
                        ),
                        child: Text('เสร็จสิ้น'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> addLatLngToUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String user_id = preferences.getString('id');
    var address = _addressController.text;
    String url =
        '${API.BASE_URL}/flutterapi/src/updateUserlatlng.php?isAdd=true&id=$user_id&Address=$address&Lat=$Lat&Lng=$Lng';

    await Dio()
        .get(url)
        .then((value) => print('Token added successfully $user_id'));
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
        Lat1 = double.parse(model.lat);
        Lng1 = double.parse(model.lng);
        print("lat1 ===$Lat1 lat2 ===> $Lng1");
      });
    } catch (e) {
      // จัดการข้อผิดพลาดที่อาจเกิดขึ้นในการขอตำแหน่งที่ตั้ง
      print('Error: $e');
    }
  }

  Marker userMarker() {
    return Marker(
      markerId: MarkerId('userMarker'),
      position: LatLng(Lat1, Lng1),
      icon: BitmapDescriptor.defaultMarkerWithHue(60.0),
      infoWindow: InfoWindow(
        title: 'ที่อยู่เดิมของคุณ',
      ),
    );
  }

  Set<Marker> mySet() {
    return <Marker>[userMarker()].toSet();
  }
}
