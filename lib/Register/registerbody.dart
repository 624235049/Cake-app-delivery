import 'package:appbirthdaycake/config/api.dart';
import 'package:appbirthdaycake/widgets/dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RegisterBody extends StatefulWidget {
  @override
  State<RegisterBody> createState() => _RegisterBodyState();
}

class _RegisterBodyState extends State<RegisterBody> {
  bool isHidden = false;
  Position userlocation;
  var _nameController = TextEditingController();
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  var _phoneController = TextEditingController();
  var _addressController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  double lat, lng;
  double get latitude => lat;
  double get longitude => lng;
  LatLng selectedLocation;
  bool isLoading = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    checkPermission();
    findlatlng().then((value) {
      setState(() {
        isLoading =
            false; // ตั้งค่า isLoading เป็น false เมื่อโหลดข้อมูลเสร็จสิ้น
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Color.fromRGBO(58, 163, 232, 1),
          Color.fromRGBO(226, 231, 241, 1.0),
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: isLoading
            ? Center(
                child:
                    CircularProgressIndicator()) // แสดงสัญลักษณ์การโหลดเมื่อ isLoading เป็น true
            : GestureDetector(
                onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                behavior: HitTestBehavior.opaque,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 110,
                        ),
                        Container(
                          child: Center(
                            child: Text(
                              'Create Account',
                              style: TextStyle(
                                  color: Colors.blue.shade200,
                                  fontFamily: 'Oleo',
                                  fontSize: 40),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: TextFormField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Name',
                                  icon: Icon(Icons.person_add_alt),
                                  labelText: 'Name :',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.blue.shade100),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.blue.shade200),
                                  ),
                                ),
                              ),
                            ),
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
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Username',
                                  icon: Icon(Icons.email),
                                  labelText: 'Username :',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.blue.shade100),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.blue.shade200),
                                  ),
                                ),
                              ),
                            ),
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
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: TextFormField(
                                obscureText: isHidden,
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'password',
                                  icon: Icon(Icons.lock),
                                  suffixIcon: IconButton(
                                      icon: isHidden
                                          ? Icon(Icons.visibility_off)
                                          : Icon(Icons.visibility),
                                      onPressed: togglePasswordVisibility),
                                  labelText: 'Password :',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.blue.shade100),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.blue.shade200),
                                  ),
                                ),
                              ),
                            ),
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
                                controller: _phoneController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Phone',
                                  icon: Icon(Icons.phone),
                                  labelText: 'Phone :',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.blue.shade100),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.blue.shade200),
                                  ),
                                ),
                              ),
                            ),
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
                                        BorderSide(color: Colors.blue.shade100),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.blue.shade200),
                                  ),
                                ),
                                readOnly: true,
                                onTap: () async {
                                  final coordinates = Coordinates(
                                      selectedLocation.latitude,
                                      selectedLocation.longitude);
                                  final addresses = await Geocoder.local
                                      .findAddressesFromCoordinates(
                                          coordinates);
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'เลือกตำแหน่งบนแผนที่',
                                style: TextStyle(
                                    color: Colors.blue.shade200,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 300,
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: LatLng(lat, lng),
                              zoom: 15,
                            ),
                            onTap: (LatLng location) {
                              setState(() {
                                selectedLocation = location;
                              });
                            },
                            markers: selectedLocation != null
                                ? {
                                    Marker(
                                      markerId: MarkerId('selected_location'),
                                      position: selectedLocation,
                                    ),
                                  }
                                : {},
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            if (selectedLocation != null) {
                              setState(() {
                                lat = selectedLocation.latitude;
                                lng = selectedLocation.longitude;
                              });
                              // TODO: ทำอย่างอื่นที่คุณต้องการเมื่อเลือกตำแหน่งบนแผนที่
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
                          child: Text(
                            'เลือกตำแหน่งนี้',
                            style: TextStyle(
                                color: Colors.blue.shade300,
                                //fontWeight: FontWeight.w600,
                                fontSize: 18),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: GestureDetector(
                            onTap: () {
                              if (_nameController == null ||
                                  _nameController.text.isEmpty ||
                                  _addressController.text == null ||
                                  _addressController.text.isEmpty ||
                                  _phoneController.text == null ||
                                  _phoneController.text.isEmpty ||
                                  _passwordController == null ||
                                  _passwordController.text.isEmpty) {
                                print('Have space');
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("กรุณากรอกให้ครบ"),
                                      actions: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.blue
                                                .shade100, // สีปุ่มเป็นสีชมพู
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("OK"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else {
                                uploadAndInsertData().then((value) {
                                  print("สำเร็จ");
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("สมัครสมาชิกสำเร็จ"),
                                        actions: [
                                          TextButton(
                                            style: ElevatedButton.styleFrom(
                                              primary: Colors.blue
                                                  .shade100, // สีปุ่มเป็นสีชมพู
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              "OK",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                });
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  color: Colors.blue[300],
                                  borderRadius: BorderRadius.circular(12)),
                              child: Center(
                                child: Text(
                                  'Join Us',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  void togglePasswordVisibility() => setState(() => isHidden = !isHidden);

  Future<Null> checkPermission() async {
    bool locationService;
    LocationPermission locationPermission;

    locationService = await Geolocator.isLocationServiceEnabled();
    if (locationService) {
      print('Sevice Location Open');
      locationPermission = await Geolocator.checkPermission();
      if (locationPermission == LocationPermission.denied) {
        locationPermission == await Geolocator.requestPermission();
        if (locationPermission == LocationPermission.deniedForever) {
          normalDialog(context, 'ไม่อนุญาติแชร์ Location โปรดแชร์ Location');
        } else {}
      } else {
        if (locationPermission == LocationPermission.deniedForever) {
          normalDialog(context, 'ไม่อนุญาติแชร์ Location โปรดแชร์ Location');
        } else {}
      }
    } else {
      print('Service Location Close');
      normalDialog(context,
          'Location service ปิดอยู่ ? กรุณาเปิดตำแหน่งของท่านก่อนใช้บริการค่ะ');
    }
  }

  Future<Null> findlatlng() async {
    Position positon = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      lat = positon.latitude;
      lng = positon.longitude;
      print(' lat == $lat , lng == $lng');
    });
  }

  //Future function upload data
  Future<Null> uploadAndInsertData() async {
    var name = _nameController.text;
    var address = _addressController.text;
    var phone = _phoneController.text;
    var user = _emailController.text;
    var password = _passwordController.text;
    // print(" name == ${name} ${address}");
    String apipath =
        '${API.BASE_URL}/flutterapi/src/register.php?isAdd=true&Name=$name&User=$user&Password=$password&chooseType=Customer&Phone=$phone&Address=$address&Lat=$lat&Lng=$lng&Token=token';

    await Dio().get(apipath).then((value) {
      if (value.toString() == 'true') {
        print('lng == $lng lat ==$lat');
        Navigator.pop(context);
      } else {
        normalDialog(context, "ไม่สำเร็จ");
      }
    });
  }
}
