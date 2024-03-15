import 'package:appbirthdaycake/custumer/HomeScreen/app_icon.dart';
import 'package:appbirthdaycake/custumer/model/cake_n_model.dart';
import 'package:appbirthdaycake/custumer/model/cart_model.dart';
import 'package:appbirthdaycake/helper/sqlite.dart';
import 'package:appbirthdaycake/widgets/dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopcartPage extends StatefulWidget {
  const ShopcartPage({Key key}) : super(key: key);

  @override
  State<ShopcartPage> createState() => _ShopcartPageState();
}

class _ShopcartPageState extends State<ShopcartPage> {
  List<CartModel> cartModels = [];
  List<List<String>> listgasids = [];
  List<int> listamounts = [];
  CakeNModel cakens;
  int total = 0;
  int quantityInt = 0;
  bool status = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //SizedBox(height: 130,),
                IconButton(
                    icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.blue[100],
                )),
                SizedBox(
                  width: 190,
                ),
                IconButton(
                    icon: Icon(
                  Icons.home,
                  color: Colors.blue[100],
                )
                    //backgroundColor: Colors.pink[100],
                    //iconSize: 24,
                    ),
                IconButton(
                    icon: Icon(
                  Icons.shopping_cart,
                  color: Colors.blue[100],
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<Null> orderThread() async {
    DateTime dateTime = DateTime.now();
    // print(dateTime.toString());
    String order_date_time = DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
    List<String> cake_ids = [];
    List<String> imgcakes = [];
    List<String> texts = [];
    List<String> sizes = [];
    List<String> prices = [];
    List<String> amounts = [];
    List<String> sums = [];

    for (var model in cartModels) {
      cake_ids.add(model.cake_id);
      imgcakes.add(model.cake_img);
      texts.add(model.cake_text);
      prices.add(model.price);
      sizes.add(model.cake_size);
      amounts.add(model.amount);
      sums.add(model.sum);
    }
    String cake_id = cake_ids.toString();
    String imgcake = imgcakes.toString();
    String text = texts.toString();
    String price = prices.toString();
    String size = sizes.toString();
    String amount = amounts.toString();
    String sum = sums.toString();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String user_id = preferences.getString('id');
    String user_name = preferences.getString('Name');
    print(
        'orderDateTime == $order_date_time ,user_id ==> $user_id,user_name ==> $user_name ');
    print(
        'cake_id ==> $cake_ids,imgcake ==>$imgcake,text ==> $Text,size ==> $size, price ==> $price , amount ==> $amount , sum ==> $sum');

    String url =
        'http://192.168.1.34:8080/flutterapi/addOrder.php?isAdd=true&order_date_time=$order_date_time&user_id=$user_id&user_name=$user_name&cake_id=$cake_id&imgcake=$imgcake&text=$text&size=$size&price=$price&amount=$amount&sum=$sum&payment_status=payondelivery&status=userorder';

    await Dio().get(url).then((value) {
      if (value.toString() == 'true') {
        // updateQtyGas(amount, gas_id);
        clearOrderSQLite();

        //notificationtoShop(user_name);
      } else {
        normalDialog(context, 'ไม่สามารถสั่งซื้อได้กรุณาลองใหม่');
      }
    });
  }

  Future<Null> clearOrderSQLite() async {
    await SQLiteHlper().deleteAllData().then(
      (value) {
        normalDialog2(
            context, "สั่งซื้อสำเร็จ", "รอรับสินค้าตรวจสอบการสั่งซื้อ");
        readSQLite();
      },
    );
  }

  Future<Null> readSQLite() async {
    var object = await SQLiteHlper().readAllDataFormSQLite();
    print('object length ==> ${object.length}');
    if (object.length != 0) {
      for (var model in object) {
        String sumString = model.sum;
        int sumInt = int.parse(sumString);
        setState(() {
          status = false;
          cartModels = object;
          total = total + sumInt;

          // gas_id = model.gas_id;
          // amount = model.amount;
        });
      }
    } else {
      setState(() {
        status = true;
      });
    }
  }
}
