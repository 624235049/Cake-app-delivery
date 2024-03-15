import 'package:appbirthdaycake/custumer/shopping/history_page.dart';
import 'package:appbirthdaycake/custumer/shopping/show_cancel.dart';
import 'package:appbirthdaycake/custumer/shopping/show_finish.dart';
import 'package:appbirthdaycake/custumer/shopping/show_shopprocess.dart';
import 'package:flutter/material.dart';

class HomeHistoryPage extends StatefulWidget {
  const HomeHistoryPage({Key key}) : super(key: key);

  @override
  State<HomeHistoryPage> createState() => _HomeHistoryPageState();
}

class _HomeHistoryPageState extends State<HomeHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5, // จำนวนแท็บ
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Center(
            child: Text(
              'HISTORY',
              style: TextStyle(
                  fontFamily: 'Bebas',
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ),
          backgroundColor: Colors.blue.shade300,
          bottom: const TabBar(
            tabs: [
              Tab(
                child: Text(
                  'ออเดอร์',
                  style: TextStyle(
                      color: Colors.white, fontSize: 15), // สีของตัวอักษรในแท็บ
                ),
              ),
              Tab(
                child: Text(
                  'ที่ต้องรับ',
                  style: TextStyle(
                      color: Colors.white, fontSize: 15), // สีของตัวอักษรในแท็บ
                ),
              ),
              Tab(
                child: Text(
                  'สำเร็จ',
                  style: TextStyle(
                      color: Colors.white, fontSize: 15), // สีของตัวอักษรในแท็บ
                ),
              ),
              Tab(
                child: Text(
                  'ยกเลิก',
                  style: TextStyle(
                      color: Colors.white, fontSize: 15), // สีของตัวอักษรในแท็บ
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // วิตเจ็ตสำหรับแท็บที่ 1
            HistoryPage(),
            // วิตเจ็ตสำหรับแท็บที่ 2
            ShowShopprocess(),
            //OrderFinishPage()
            ShowFinish(),
            Showcancel(),
          ],
        ),
      ),
    );
  }
}
