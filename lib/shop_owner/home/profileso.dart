import 'package:appbirthdaycake/custumer/HomeScreen/accountwidget.dart';
import 'package:appbirthdaycake/custumer/HomeScreen/app_icon.dart';
import 'package:appbirthdaycake/custumer/HomeScreen/big_text.dart';
import 'package:appbirthdaycake/custumer/HomeScreen/logout.dart';
import 'package:flutter/material.dart';

class ProFileShopPage extends StatefulWidget {
  const ProFileShopPage({Key key}) : super(key: key);

  @override
  State<ProFileShopPage> createState() => _ProFileShopPageState();
}

class _ProFileShopPageState extends State<ProFileShopPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        margin: EdgeInsets.only(top: 10),
        child: Column(
          // profile Icons
          children: [
            SizedBox(
              height: 150,
            ),
            Image.asset('assets/images/logo.jpg'),
            SizedBox(
              height: 30,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //name
                    SizedBox(
                      height: 90,
                    ),
                    //message
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: GestureDetector(
                          onTap: () {
                            signOutProcess(context);
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.blue.shade50),
                            child: Icon(
                              Icons.logout,
                              size: 25,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        title: Text('LOG OUT'),
                        trailing: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.grey.shade200),
                          child: Icon(
                            Icons.outbond_outlined,
                            size: 20,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
