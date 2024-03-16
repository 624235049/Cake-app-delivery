import 'dart:convert';

import 'package:appbirthdaycake/config/api.dart';
import 'package:appbirthdaycake/config/approute.dart';
import 'package:appbirthdaycake/config/appsetting.dart';
import 'package:appbirthdaycake/custumer/model/usermodel.dart';
import 'package:appbirthdaycake/widgets/dialog.dart';
import 'package:appbirthdaycake/services/network.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isHidden = false;

  var _usernameController = TextEditingController();

  var _passwordController = TextEditingController();

  String tokenId;

  @override
  void dispose() {
    _usernameController?.dispose();
    _passwordController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.getToken().then((token) {
      tokenId = token.toString();
      print('FCM Token: $tokenId');
    });
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Color.fromRGBO(58, 163, 232, 1),
          Color.fromRGBO(226, 231, 241, 1.0),
        ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            reverse: true,
            padding: EdgeInsets.all(32),
            child: Column(
              children: [
                SizedBox(
                  height: 150,
                ),
                Image.asset('assets/images/birthday.png'),
                Container(
                  child: Center(
                    child: Text(
                      'Welcome ',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          fontFamily: 'Oleo'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextFormField(
                        controller: _usernameController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.person,
                              color: Colors.blue[100],
                            ),
                            border: InputBorder.none,
                            hintText: 'Username'),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: TextFormField(
                        controller: _passwordController,
                        validator: (value) {
                          if (value.toString().isEmpty) {
                            return 'กรุณากรอก password ด้วย ค่ะ';
                          } else {}
                        },
                        obscureText: isHidden,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.lock,
                              color: Colors.blue[100],
                            ),
                            suffixIcon: IconButton(
                                color: Colors.blue[100],
                                icon: isHidden
                                    ? Icon(Icons.visibility_off)
                                    : Icon(Icons.visibility),
                                onPressed: togglePasswordVisibility),
                            border: InputBorder.none,
                            hintText: 'Password'),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                  onPressed: () async {
                    final username = _usernameController.text;
                    final password = _passwordController.text;
                    if(username.isNotEmpty && password.isNotEmpty) {
                    checkAuthen();
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setString(AppSetting.userNameSetting, username);
                    prefs.setString(AppSetting.passwordSetting, password);}
                  },
                  child: Text('Login',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.blue[300],
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 120),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50))),
                ),
                SizedBox(
                  height: 7,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Not a member?',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoute.RegisterRoute);
                      },
                      child: Text(
                        'Register now',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void togglePasswordVisibility() => setState(() => isHidden = !isHidden);

  Future<Null> checkAuthen() async {
    var email = _usernameController.text;
    var password = _passwordController.text;
    String url =
        '${API.BASE_URL}/flutterapi/src/getUserWhereUser.php?isAdd=true&User=$email';

    try {
      Response response = await Dio().get(url);
      //print('res = $response');
      print("$password ");
      var result = json.decode(response.data);
      print('result = $result');
      for (var map in result) {
        CUsertable userModel = CUsertable.fromJson(map);
        print("password === ${userModel.password}");
        if (password == userModel.password) {
          print("password === true == ${userModel.password}");
          String chooseType = userModel.chooseType;
          if (chooseType == 'Customer') {
            RoutetoService(userModel);
            Navigator.pushNamedAndRemoveUntil(
                context, AppRoute.HomeRoute, (route) => false);
          } else if (chooseType == 'ShopOwner') {
            RoutetoService(userModel);
            Navigator.pushNamedAndRemoveUntil(
                context, AppRoute.HomeShopOwnerRoute, (route) => false);
          } else {
            print('Error!');
          }
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Password ผิด กรุณาลองใหม่อีกครั้ง"),
                actions: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.pink.shade100, // สีปุ่มเป็นสีชมพู
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
          print('Password ผิด กรุณาลองใหม่อีกครั้ง ค่ะ');
        }
      }
    } catch (e) {
      normalDialog(context, 'Password ผิด กรุณาลองใหม่อีกครั้ง ค่ะ');
    }
  }

  Future<Null> RoutetoService(CUsertable userModel) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(API().keyId, userModel.id);
    preferences.setString(API().keyType, userModel.chooseType);
    preferences.setString(API().keyName, userModel.name);
    await addTokenToUser(tokenId);
  }

  Future<void> updateToken() async {
    // ติดตั้ง OneSignal
    OneSignal.shared.setAppId("777efcf3-1984-4cbd-bc48-e63b4db352c3");
    // กำหนดขอบเขตการใช้งาน OneSignal
    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      // ตอบสนองเมื่อผู้ใช้เปิดการแจ้งเตือน
    });

    // รับข้อมูลของอุปกรณ์
    await OneSignal.shared.getDeviceState().then((deviceState) {
      // เรียกใช้งาน Token ของผู้ใช้
      String token = deviceState?.pushToken;
      print("OneSignal Token: $token");
      // เรียกใช้ฟังก์ชันเพื่อเพิ่ม Token ในฐานข้อมูลผู้ใช้
      addTokenToUser(token);
    });
  }

  Future<void> addTokenToUser(String tokenId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String user_id = preferences.getString('id');
    String url =
        '${API.BASE_URL}/flutterapi/src/updateUserToken.php?isAdd=true&id=$user_id&Token=$tokenId';

    await Dio()
        .get(url)
        .then((value) => print('Token added successfully $user_id'));
  }
}
