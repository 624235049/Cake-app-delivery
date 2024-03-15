import 'dart:ffi';
import 'dart:ui' as ui;
import 'package:intl/intl.dart';
import 'package:appbirthdaycake/config/api.dart';
import 'package:appbirthdaycake/config/approute.dart';
import 'package:appbirthdaycake/custumer/model/Cake_size_model.dart';
import 'package:appbirthdaycake/custumer/model/cake_n_model.dart';
import 'package:appbirthdaycake/custumer/model/cart_model.dart';
import 'package:appbirthdaycake/services/network.dart';
import 'package:appbirthdaycake/widgets/dialog.dart';
import 'package:appbirthdaycake/helper/sqlite.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CakeDetail extends StatefulWidget {
  //final CakegeneralModel cakegeneralModel;
  //CakeDetail({Key key, this.cakegeneralModel}) : super(key: key);

  @override
  State<CakeDetail> createState() => _CakeDetailState();
}

class _CakeDetailState extends State<CakeDetail> {
  //CakeSize _cs;
  List<CartModel> cartModels = [];
  Cakens _cn;
  String img;
  String selectedCakeSize;
  String selectedCakeFlavor;
  String sizeIds;
  String pricecake;
  int _quantiy = 0;
  String pickupdate;
  var cake_date = TextEditingController();
  var size_cake = TextEditingController();
  var cake_detail = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TextEditingController dateController = TextEditingController();
  int sizeId;
  List<CakeSize> cakesizes = [];

  @override
  Void initSate() {
    cake_date.dispose();
    size_cake.dispose();
    cake_detail.dispose();
    _cn = Cakens();
    //_cs = CakeSize();
    super.initState();
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("2lbs"), value: "2lbs"),
      DropdownMenuItem(child: Text("3lbs"), value: "3lbs"),
      DropdownMenuItem(child: Text("4lbs"), value: "4lbs"),
      DropdownMenuItem(child: Text("5lbs"), value: "5lbs"),
    ];
    return menuItems;
  }

  List<DropdownMenuItem<String>> get dropdownCake {
    List<DropdownMenuItem<String>> flavorItems = [
      DropdownMenuItem(child: const Text("ช็อกโกแลต"), value: "ช็อกโกแลต"),
      DropdownMenuItem(child: Text("วานิลา"), value: "วานิลา"),
      DropdownMenuItem(child: Text("ผลไม้"), value: "ผลไม้"),
    ];
    return flavorItems;
  }

  @override
  Widget build(BuildContext context) {
    Object arguments = ModalRoute.of(context).settings.arguments;
    if (arguments is Cakens) {
      _cn = arguments;
    }
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // IconButton(onPressed: () {
                // }, icon: Icon(Icons.arrow_back_ios_new),
                // ),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoute.CartRoute);
                  },
                  icon: Icon(Icons.shopping_cart_outlined),
                ),
                IconButton(
                  onPressed: () {
                    // Share.share('Welcome to เค้กสั่งได้');
                    // Share.share(
                    //     'https://github.com/624235048/appbirthdaycake/blob/master/assets/images/share.jpg?raw=true');
                  },
                  icon: Icon(
                    Icons.share,
                    color: Colors.red,
                  ),
                )
              ],
            ),
            elevation: 0,
            bottom: PreferredSize(
                child: Container(
                  //margin: EdgeInsets.only(left: 26)
                  child: Center(
                      child: Text(
                    'Cake Order Details',
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  )),
                  width: double.maxFinite,
                  padding: EdgeInsets.only(top: 5, bottom: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      )),
                ),
                preferredSize: ui.Size.fromHeight(0)),
            pinned: true,
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Colors.blue.shade200,
                child: Image.network(
                  API.CN_IMAGE + _cn.cnImages,
                  width: double.maxFinite,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        'รายละเอียดเค้ก',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(
                    _cn.cnDesc,
                    style: TextStyle(
                      //color: Colors.pink,
                      fontSize: 18,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        'รสชาติเค้ก',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 350,
                  child: DropdownButtonFormField(
                    value: selectedCakeFlavor,
                    items: dropdownCake,
                    onChanged: (String value) {
                      setState(() {
                        selectedCakeFlavor = value;
                      });
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        'ขนาดเค้ก',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 350,
                  child: DropdownButtonFormField(
                    value: selectedCakeSize,
                    items: dropdownItems,
                    onChanged: (String value) {
                      setState(() {
                        selectedCakeSize = value;
                        switch (selectedCakeSize) {
                          case "2lbs":
                            pricecake = _cn.cnPrice;
                            break;

                          case "3lbs":
                            int price = int.parse(_cn.cnPrice) + 100;
                            pricecake = price.toString();
                            break;

                          case "4lbs":
                            int price = int.parse(_cn.cnPrice) + 200;
                            pricecake = price.toString();
                            break;

                          case "5lbs":
                            int price = int.parse(_cn.cnPrice) + 300;
                            pricecake = price.toString();
                            break;

                          default:
                            pricecake = "";
                            break;
                        }
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    children: [
                      Text(
                        'เวลานัดรับเค้ก',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                birthDayFormField(),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    children: [
                      Text(
                        'ข้อความหน้าเค้ก',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: TextFormField(
                      controller: cake_detail,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        //hintText: 'Text',
                        //icon: Icon(Icons.email)
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.only(
                    left: 25,
                    right: 25,
                    top: 25,
                    bottom: 25,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (_quantiy > 0) {
                              _quantiy--;
                            }
                          });
                        },
                        child: Icon(Icons.remove),
                      ),
                      Text("$_quantiy"),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (_quantiy < 20) {
                              _quantiy++;
                            }
                          });
                        },
                        child: Icon(Icons.add),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 200,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      //print('price = $pricecake');
                      //addOrderToCart();
                      if (sizeId.toString().isEmpty ||
                          cake_detail.toString().isEmpty ||
                          _quantiy != 0) {
                        addOrderToCart();
                        Navigator.pop(context);
                      } else {
                        normalDialog2(context, "กรุณาตรวจสอบคำสั่งซื้อ", "");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.blue[500], shape: StadiumBorder()),
                    child: Text(
                      pricecake != null
                          ? "${pricecake.toString()} THB || Add Order"
                          : "0 THB || Add To Cart",
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<Null> addOrderToCart() async {
    String cn_id = _cn.cnId.toString();
    String cn_img = _cn.cnImages;
    String cn_size = selectedCakeSize;
    String date = DateFormat('yyyy-MM-dd ').format(_selectedDate);
    String pickup = dateController.text;
    String cn_text = cake_detail.text;
    String cn_cakeflavor = selectedCakeFlavor;
    String cn_price = pricecake.toString();
    int priceInt = int.parse(cn_price);
    int sumInt = priceInt * _quantiy;
    String sum = sumInt.toString();

    Map<String, dynamic> map = Map();
    map['cake_id'] = cn_id;
    map['cake_size'] = cn_size;
    map['cake_img'] = cn_img;
    map['cake_date'] = date;
    map['pickup_date'] = pickup;
    map['cake_text'] = cn_text;
    map['cake_flavor'] = cn_cakeflavor;
    map['amount'] = _quantiy.toString();
    map['price'] = cn_price;
    map['sum'] = sum;
    print("price is ==>>> $cn_price");
    // print('map ==> ${map.toString()}');
    CartModel cartModel = CartModel.fromJson(map);

    var object = await SQLiteHlper().readAllDataFormSQLite();
    print('object lenght == ${object.length}');

    if (object.length == 0) {
      await SQLiteHlper().insertDataToSQLite(cartModel).then((value) => {
            print('insert Sucess'),
            normalDialog2(context, "เพิ่มสินค้าในตะกร้า", "สำเร็จ"),
          });
    } else {
      String brandSQLite = object[0].cake_id;
      if (brandSQLite.isNotEmpty) {
        await SQLiteHlper().insertDataToSQLite(cartModel).then((value) => {
              print('insert Sucess'),
              //showToast("Insert Sucess")
            });
      } else {
        normalDialog(context, 'รายการสั่งซื้อผิดพลาด !');
      }
    }
  }

  Widget birthDayFormField() {
    return Container(
      color: Colors.blue[50],
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: TextFormField(
        validator: (value) {
          if (value.toString().isEmpty) {
            return 'กรุณาเลือก ว/ด/ปี ที่นัดรับ';
          }
          return null; // คืนค่า null หากไม่มี error
        },
        decoration: InputDecoration(
          //labelText: "เลือกวัน",
          hintText: "เลือกวันส่ง",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: const OutlineInputBorder(borderSide: BorderSide(width: 0.2)),
          suffixIcon: IconButton(
            icon: const Icon(Icons.calendar_today, color: Colors.blue),
            onPressed: () {
              selectDate(context);
            },
          ),
        ),
        controller: dateController,
        readOnly: true,
      ),
    );
  }

  //select Calender dd/mm/yyyy
  void selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        dateController.text =
            '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}';
      });
    }
  }
}
