import 'dart:io';
import 'dart:math';

import 'package:appbirthdaycake/config/api.dart';
import 'package:appbirthdaycake/config/approute.dart';
import 'package:appbirthdaycake/custumer/model/cake_n_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditCakePage extends StatefulWidget {
  final Cakens cake;

  const EditCakePage({Key key, this.cake}) : super(key: key);

  @override
  State<EditCakePage> createState() => _EditCakePageState();
}

class _EditCakePageState extends State<EditCakePage> {
  var priceController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  dynamic cnSize;
  String cnPrice;
  String cakename , details;
  String cnImages;
  dynamic cnId;
  File file;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var arguments = ModalRoute.of(context).settings.arguments;
      if (arguments is Cakens) {
        setState(() {
          cnId = arguments.cnId;
          cakename = arguments.cnCakename;
          details = arguments.cnDesc;
          cnPrice = arguments.cnPrice;
          cnImages = arguments.cnImages;
          cnSize = arguments.sizeId;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushNamed(context, AppRoute.SOCakeRoute);
          },
        ),
        title: Text(
          'AddCake',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: 600,
                  height: 400,
                  child: file == null
                      ? Image.network(API.CN_IMAGE + cnImages,)
                      : Container(
                          height: 400,
                          width: 400,
                          child: Image.file(file),
                        ),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                        onPressed: () =>
                            chooseImage(ImageSource.camera), //เพิ่มรูป
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo,
                              color: Colors.blue.shade100,
                              size: 40,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            // Text(
                            //   'เพิ่มรูป',
                            //   style: TextStyle(
                            //       color: kPrimaryblckColor, fontSize: 14),
                            // ),
                          ],
                        )),
                    Text('||'),
                    TextButton(
                        onPressed: () =>
                            chooseImage(ImageSource.gallery), //เพิ่มรูป
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.photo_size_select_actual,
                              color: Colors.blue.shade100,
                              size: 40,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            // Text(
                            //   'เพิ่มรูป',
                            //   style: TextStyle(
                            //       color: kPrimaryblckColor, fontSize: 14),
                            // ),
                          ],
                        )),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    onChanged: (value) => cakename = value.trim(),
                    initialValue: cakename ?? '',
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'CakeName',
                      hintText: 'Enter CakeName',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(color: Colors.blue.shade100),  // กำหนดสีให้กับตัวอักษร Label
                      hintStyle: TextStyle(color: Colors.blue.shade100),   // กำหนดสีให้กับตัวอักษร Hint
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter price';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    onChanged: (value) => details = value.trim(),
                    initialValue: details ?? '',
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Details',
                      hintText: 'Enter Details',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(color: Colors.blue.shade100),  // กำหนดสีให้กับตัวอักษร Label
                      hintStyle: TextStyle(color: Colors.blue.shade100),   // กำหนดสีให้กับตัวอักษร Hint
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter Details';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    onChanged: (value) => cnPrice = value.trim(),
                    initialValue: cnPrice ?? '',
                    //controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Price',
                      hintText: 'Enter price',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(color: Colors.blue.shade100),
                      // กำหนดสีให้กับตัวอักษร Label
                      hintStyle: TextStyle(
                          color: Colors
                              .pink.shade100), // กำหนดสีให้กับตัวอักษร Hint
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter price';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              elevation: 5,
                              // Foreground color
                              onPrimary: Colors.white,
                              // Background color
                              primary: Colors.green,
                              minimumSize: Size(120, 50))
                          .copyWith(
                              elevation: ButtonStyleButton.allOrNull(2.0)),
                      onPressed: () {
                        confirmEdit();
                        //uplodeimageandsave();
                      },
                      child: Row(
                        children: [
                          Icon(Icons.check_circle_rounded),
                          SizedBox(
                            width: 5,
                          ),
                          Text('ยืนยัน'),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              elevation: 5,
                              // Foreground color
                              onPrimary: Colors.white,
                              // Background color
                              primary: Colors.red,
                              minimumSize: Size(120, 50))
                          .copyWith(
                              elevation: ButtonStyleButton.allOrNull(2.0)),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          Icon(Icons.cancel),
                          SizedBox(
                            width: 5,
                          ),
                          Text('ยกเลิก'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> confirmEdit() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('คุณต้องการเปลี่ยนแปลงรายการนี้ใช่ไหม ?'),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  primary: Colors
                      .pink.shade100, // สีปุ่มเป็นสีชมพู
                ),
                onPressed: () {
                  Navigator.pop(context);
                  editcake();
                },
                icon: Icon(
                  Icons.check,
                  color: Colors.blue.shade50,
                ),
                label: Text(
                  'ตกลง',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  primary: Colors
                      .pink.shade100, // สีปุ่มเป็นสีชมพู
                ),
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.clear,
                  color: Colors.red,
                ),
                label: Text(
                  'ยกเลิก',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Future<dynamic> editcake() async {
    Random random = Random();
    int i = random.nextInt(100000);
    String nameFile = 'No$i.jpg';
    Map<String, dynamic> map = Map();
    if (file != null) {
      map['file'] = await MultipartFile.fromFile(file.path, filename: nameFile);
    }
    FormData formData = FormData.fromMap(map);
    String urlUpload = '${API.BASE_URL}/flutterapi/src/saveimage.php';
    await Dio().post(urlUpload, data: formData).then((value) async {
      cnImages = '$nameFile';
      String url =
          '${API.BASE_URL}/flutterapi/src/editCakeWhereId.php?isAdd=true&cn_id=$cnId&cn_cakename=$cakename&cn_desc=$details&cn_price=$cnPrice&cn_images=$cnImages&size_id=$cnSize';
      await Dio().get(url).then(
        (value) {
          Navigator.pop(context);
          print('Edit Crystal Success');
          print(
              " cn_id ===> ${cnId} image ====>> ${cnImages} price ====>> ${cnPrice}");
        },
      );
    });
  }

  Future<Null> chooseImage(ImageSource imageSource) async {
    try {
      final picker = ImagePicker();
      var pickedFile = await picker.getImage(
        source: imageSource,
        maxHeight: 800.0,
        maxWidth: 800.0,
      );

      if (pickedFile != null) {
        setState(() {
          file = File(pickedFile.path);
        });
      }
    } catch (e) {
      // การจัดการข้อผิดพลาดที่คุณต้องการ
    }
  }
}
