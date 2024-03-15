import 'package:appbirthdaycake/config/approute.dart';
import 'package:appbirthdaycake/custumer/shopping/cart_body.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      //appBar: _buildAppBar(),
      body: CartBody(),
    );
  }
}