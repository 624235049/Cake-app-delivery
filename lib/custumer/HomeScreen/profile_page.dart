import 'dart:convert';

import 'package:appbirthdaycake/config/api.dart';
import 'package:appbirthdaycake/config/approute.dart';
import 'package:appbirthdaycake/custumer/HomeScreen/logout.dart';
import 'package:appbirthdaycake/style.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/usermodel.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  CUsertable model;
  String name, phone, address;
  @override
  void initState() {
    super.initState();
    readDataUser();
  }

  Future<Null> readDataUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String user_id = preferences.getString('id');
    String url =
        '${API.BASE_URL}/flutterapi/src/getuserwhereid.php?isAdd=true&id=$user_id';

    await Dio().get(url).then((value) {
      if (value.toString() != 'null') {
        var result = json.decode(value.data);

        for (var map in result) {
          setState(() {
            model = CUsertable.fromJson(map);
            name = model.name;
            phone = model.phone;
            address = model.address;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Center(
          child: Text(
            'PROFILE',
            style: TextStyle(
                fontFamily: 'Bebas',
                fontSize: 30,
                fontWeight: FontWeight.w500,
                color: Colors.blue.shade200),
          ),
        ),
      ),
      body: model != null
          ? SingleChildScrollView(
              child: Container(
                //color: Colors.pink.shade50,
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.blue.shade100),
                      child: Image(
                        image: AssetImage(
                          Style().ProfileImage,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Divider(
                          color: Colors.blue.shade300,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        buildListTile(),
                        SizedBox(
                          height: 10,
                        ),
                        buildListTile2(),
                        SizedBox(
                          height: 10,
                        ),
                        buildListTile3(),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(
                          color: Colors.blue.shade300,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        buildListTile4(),
                      ],
                    ),
                  ],
                ),
              ),
            )
          : Style().showProgress(),
    );
  }

  ListTile buildListTile() {
    return ListTile(
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.blue.shade100),
        child: Icon(
          Icons.perm_contact_calendar_rounded,
          size: 25,
          color: Colors.redAccent,
        ),
      ),
      title: Text(name),
      trailing: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.grey.shade200),
        child: Icon(
          Icons.accessibility,
          size: 20,
          color: Colors.grey,
        ),
      ),
    );
  }

  ListTile buildListTile2() {
    return ListTile(
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.blue.shade100),
        child: Icon(
          Icons.phone,
          size: 25,
          color: Colors.teal,
        ),
      ),
      title: Text(phone),
      trailing: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.grey.shade200),
        child: Icon(
          Icons.phone_forwarded_outlined,
          size: 20,
          color: Colors.grey,
        ),
      ),
    );
  }

  ListTile buildListTile3() {
    return ListTile(
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: Colors.blue.shade100),
        child: Icon(
          Icons.location_on,
          size: 25,
          color: Colors.red,
        ),
      ),
      title: Text(address),
      trailing: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, AppRoute.EditLatLng, arguments: model);
        },
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.amberAccent),
          child: Icon(
            Icons.map_outlined,
            size: 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  ListTile buildListTile4() {
    return ListTile(
      leading: GestureDetector(
        onTap: () {
          signOutProcess(context);
        },
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.blue.shade100),
          child: const Icon(
            Icons.logout,
            size: 25,
            color: Colors.red,
          ),
        ),
      ),
      title: Text('LOGOUT'),
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
    );
  }
}
