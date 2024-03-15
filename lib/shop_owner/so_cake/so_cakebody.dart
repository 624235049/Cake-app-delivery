import 'package:appbirthdaycake/config/api.dart';
import 'package:appbirthdaycake/config/approute.dart';
import 'package:appbirthdaycake/custumer/model/cake_n_model.dart';
import 'package:appbirthdaycake/services/network.dart';
import 'package:appbirthdaycake/style.dart';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';

class SOCakeBody extends StatefulWidget {
  @override
  _SOCakeBodyState createState() => _SOCakeBodyState();
}

class _SOCakeBodyState extends State<SOCakeBody> {
  List<Cakens> cakens = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        child: Container(
          child: FutureBuilder<CakeNModel>(
            future: NetworkService().getAllCakeNDio(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                cakens = snapshot.data.cakens;
                return GridView.builder(
                  padding: EdgeInsets.all(10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: cakens.length,
                  itemBuilder: (context, index) {
                    var cake = cakens[index];
                    return Material(
                      child: InkWell(
                        onTap: () {
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20)),
                                  child: Image(
                                    image: NetworkImage(
                                        API.CN_IMAGE + cake.cnImages),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text('ชื่อเค้ก : '+ cake.cnCakename),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        Navigator.pushNamed(context, AppRoute.EditCakeRoute , arguments: cake );
                                        // โค้ดสำหรับแก้ไขข้อมูล
                                      },
                                      icon: Icon(Icons.edit),
                                      label: Text('Edit'),
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.blue,
                                      ),
                                    ),
                                    ElevatedButton.icon(
                                      onPressed: () =>
                                        deleteCake(cakens[index]),
                                        // โค้ดสำหรับลบข้อมูล
                                      icon: Icon(Icons.delete_forever),
                                      label: Text(''),
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.red.shade400,
                                        fixedSize: Size(40, 36),
                                      ),
                                    ),
                                  ],
                                )
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
  Future<Null> deleteCake(Cakens cakens) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Style().showTitleH2T(
            'คุณต้องการลบเค้กก้อนที่ ${cakens.cnId} \tใช่ไหม ?'),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors
                      .pink.shade100, // สีปุ่มเป็นสีชมพู
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  String url =
                      '${API.BASE_URL}/flutterapi/src/DeleteCakeWhereorderId.php?isAdd=true&cn_id=${cakens.cnId}';
                  await Dio().get(url).then((value) {
                    Navigator.pop(context);
                    //readWaterProduct();
                  });
                },
                child: Text(
                  'ยืนยัน',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors
                      .pink.shade100, // สีปุ่มเป็นสีชมพู
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'ยกเลิก',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
