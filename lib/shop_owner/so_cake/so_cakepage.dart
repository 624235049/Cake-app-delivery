import 'package:appbirthdaycake/config/approute.dart';
import 'package:appbirthdaycake/shop_owner/so_cake/so_cakebody.dart';
import 'package:flutter/material.dart';

class SOCakePage extends StatefulWidget {
  @override
  _SOCakePageState createState() => _SOCakePageState();
}

class _SOCakePageState extends State<SOCakePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: _buildAppBar(),
      body: SOCakeBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      //title: Text('Cake',style: TextStyle(color: Colors.pink[200]),),
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: Colors.blue[100],
        ),
        onPressed: () {
          Navigator.pushNamed(context, AppRoute.HomeShopOwnerRoute);
        },
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.add, color: Colors.blue[100]),
          onPressed: () {
            Navigator.pushNamed(context, AppRoute.AddCakeRoute);
          },
        ),
      ],
    );
  }
}
