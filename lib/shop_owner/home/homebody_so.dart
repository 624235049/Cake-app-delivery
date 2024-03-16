import 'dart:io';

import 'package:appbirthdaycake/config/approute.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class HomeBodyShopOwner extends StatefulWidget {
  @override
  _HomeBodyShopOwnerState createState() => _HomeBodyShopOwnerState();
}

class _HomeBodyShopOwnerState extends State<HomeBodyShopOwner> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    aboutNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              alignment: Alignment.topCenter,
              image: AssetImage('assets/images/preview.png'),
            ),
            gradient: LinearGradient(colors: [
              Color.fromRGBO(121, 163, 254, 1),
              Color.fromRGBO(189, 207, 245, 1),
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 110,
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cake to Order',
                          style: TextStyle(
                              fontFamily: 'Bebas',
                              fontSize: 40,
                              color: Color.fromARGB(255, 214, 231, 244)),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          'Home',
                          style: TextStyle(fontFamily: 'Bebas', fontSize: 20),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoute.HomeOrderRoute);
                    },
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 5,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      'OrderCake',
                                      style: TextStyle(
                                          fontFamily: 'Bebas',
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                      maxLines: 2,
                                    ),
                                    Text(
                                      'ออเดอร์ลูกค้า',
                                      style: TextStyle(
                                          fontFamily: 'Bebas',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                      maxLines: 2,
                                    ),
                                    // Image.asset(
                                    //   'assets/images/7025560.png',
                                    //   height: 100,
                                    //   width: 100,
                                    //   fit: BoxFit.cover,
                                    //   alignment: Alignment.centerLeft,
                                    // )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      height: 180,
                      width: 360,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade500,
                              offset: Offset(4.0, 4.0),
                              blurRadius: 15.0,
                              spreadRadius: 1.0),
                          BoxShadow(
                              color: Colors.white,
                              offset: Offset(-4.0, -4.0),
                              blurRadius: 15.0,
                              spreadRadius: 1.0),
                        ],
                        image: DecorationImage(
                          image: AssetImage('assets/images/cake_home_blue.png'),
                          alignment: Alignment.centerRight,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, AppRoute.SOCakeRoute);
                    },
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 5,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      'BirthDay Cake',
                                      style: TextStyle(
                                          fontFamily: 'Bebas',
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                      maxLines: 2,
                                    ),
                                    Text(
                                      'เค้กในร้าน',
                                      style: TextStyle(
                                          fontFamily: 'Bebas',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                      maxLines: 2,
                                    ),
                                    // Image.asset(
                                    //   'assets/images/7025560.png',
                                    //   height: 100,
                                    //   width: 100,
                                    //   fit: BoxFit.cover,
                                    //   alignment: Alignment.centerLeft,
                                    // )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      height: 180,
                      width: 360,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade500,
                              offset: Offset(4.0, 4.0),
                              blurRadius: 15.0,
                              spreadRadius: 1.0),
                          BoxShadow(
                              color: Colors.white,
                              offset: Offset(-4.0, -4.0),
                              blurRadius: 15.0,
                              spreadRadius: 1.0),
                        ],
                        image: DecorationImage(
                          image:
                              AssetImage('assets/images/cake_home_blue2.png'),
                          alignment: Alignment.centerRight,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 140,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> aboutNotification() async {
    if (Platform.isAndroid) {
      print('เกี่ยวกับการแจ้งเตือน');
      FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
      await firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      // กำหนดค่า Firebase Messaging ด้วยตัวเลือกของโปรเจกต์ Firebase ของคุณ
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // จัดการข้อความ FCM เมื่อแอปอยู่ใน foreground
        print('onMessage: $message');
        // แสดงการแจ้งเตือนเมื่อได้รับข้อความจาก FCM
        showNotification(message);
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        // จัดการข้อความ FCM เมื่อแอปถูกเปิดจากสถานะที่ปิดใช้งาน
        print('onLaunch: $message');
      });

      //FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler); // เพิ่มเติม: ฟังก์ชันตัวจัดการข้อความในพื้นหลัง

      // กำหนดการตั้งค่าและเรียกใช้งาน plugin ของแจ้งเตือน
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');
      final InitializationSettings initializationSettings =
          InitializationSettings(android: initializationSettingsAndroid);
      await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    }
  }

  Future<void> showNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id', // กำหนด ID ของช่องแจ้งเตือนของคุณ
      'your_channel_name', // กำหนดชื่อของช่องแจ้งเตือนของคุณ// กำหนดคำอธิบายของช่องแจ้งเตือนของคุณ
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0, // กำหนด ID ของการแจ้งเตือน
      message.notification.title, // ใช้ชื่อในการแจ้งเตือนจาก FCM
      message.notification.body, // ใช้ข้อความในการแจ้งเตือนจาก FCM
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }
}
