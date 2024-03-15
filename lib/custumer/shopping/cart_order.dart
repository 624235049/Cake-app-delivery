import 'package:appbirthdaycake/config/api.dart';
import 'package:appbirthdaycake/custumer/model/cake_n_model.dart';
import 'package:appbirthdaycake/custumer/model/cart_model.dart';
import 'package:appbirthdaycake/helper/sqlite.dart';
import 'package:flutter/material.dart';

class CartOrderPage extends StatefulWidget {
  const CartOrderPage({Key key}) : super(key: key);

  @override
  State<CartOrderPage> createState() => _CartOrderPageState();
}

class _CartOrderPageState extends State<CartOrderPage> {
  List<CartModel> cartModels = [];
  List<int> listamounts = [];
  CakeNModel cakens;
  int total = 0;
  int quantityInt = 0;
  bool status = true;

  @override
  void initState() {
    super.initState();
    readSQLite();
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
            "You Cart",
            style: TextStyle(color: Colors.blue.shade300),
          ),
        ),
      ),
      body: buildcontents(),
    );
  }

  Widget buildcontents() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: SingleChildScrollView(
        child: Column(
          children: [
            buildlistCake(),
          ],
        ),
      ),
    );
  }

  Widget buildlistCake() => ListView.builder(
        itemCount: cartModels.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Dismissible(
              direction: DismissDirection.endToStart,
              onDismissed: (direction) async {
                int id = cartModels[index].id;
                int price =
                    int.parse(cartModels[index].price); // ราคาของสินค้าที่จะลบ
                print('You Click delete id = $id');
                await SQLiteHlper().deleteDataWhereId(id).then(
                  (value) {
                    print('delete Success id =$id');
                    setState(() {
                      total -= price; // ลบราคาสินค้าที่ถูกลบออกจากค่า total
                    });
                    readSQLite();
                  },
                );
              },
              background: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.blue.shade200,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    Spacer(),
                    Icon(
                      Icons.delete_forever,
                      color: Colors.redAccent,
                    ),
                  ],
                ),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 88,
                    child: AspectRatio(
                      aspectRatio: 0.88,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Image.network(
                            API.CN_IMAGE + cartModels[index].cake_img),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    // เพิ่ม Expanded widget เพื่อให้ Column ขยายตามพื้นที่ที่เหลือ
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'หมายเลขเค้ก : ${cartModels[index].cake_id}',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.blue.shade200),
                          maxLines: 2,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "ขนาด : ${cartModels[index].cake_size}",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.blue.shade200),
                          maxLines: 2,
                        ),
                        Text(
                          "ข้อความบนเค้ก : ${cartModels[index].cake_text}",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.blue.shade200),
                          maxLines: 2,
                        ),
                        Text(
                          "วันที่นัดรับ : ${cartModels[index].pickup_date}",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.blue.shade200),
                          maxLines: 2,
                        ),
                        SizedBox(height: 10),
                        Text.rich(
                          TextSpan(
                              text: "${cartModels[index].price} ฿",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                              children: [
                                TextSpan(
                                  text: " x${cartModels[index].amount}",
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ]),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      );

  Future<Null> readSQLite() async {
    var object = await SQLiteHlper().readAllDataFormSQLite();
    print('object length ==> ${object.length}');
    int newTotal = 0; // สร้างตัวแปรใหม่เพื่อเก็บค่า total ที่ถูกคำนวณใหม่
    if (object.length != 0) {
      for (var model in object) {
        String sumString = model.sum;
        int sumInt = int.parse(sumString);
        newTotal += sumInt; // เพิ่มราคาสินค้าลงในตัวแปร newTotal
      }
    }
    setState(() {
      status = object.isEmpty; // ถ้า object ว่างเปล่าก็ให้ status เป็น true
      cartModels = object;
      total = newTotal; // กำหนดค่า total ให้เท่ากับ newTotal
    });
  }
}
