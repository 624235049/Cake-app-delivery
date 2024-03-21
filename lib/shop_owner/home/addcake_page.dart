import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:appbirthdaycake/config/api.dart';
import 'package:appbirthdaycake/config/approute.dart';
import 'package:appbirthdaycake/custumer/model/cake_n_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/src/multipart_file.dart';
import 'package:path/path.dart';

class AddCakePage extends StatefulWidget {
  const AddCakePage({Key key}) : super(key: key);

  @override
  State<AddCakePage> createState() => _AddCakePageState();
}

class _AddCakePageState extends State<AddCakePage> {
  var sizecontroller = TextEditingController();
  var quantitycontroller = TextEditingController();
  var pricecontroller = TextEditingController();
  var namecontroller = TextEditingController();
  var Descontroller = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String cn_price, product_photo, size_id;
  File file;
  List<CakeNModel> CakeNModels = [];

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
            Navigator.pushNamed(context, AppRoute.HomeShopOwnerRoute);
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
                        ? Image.asset('assets/images/galary.png')
                        : Container(
                            height: 400, width: 400, child: Image.file(file))),
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
                              color: Colors.blue,
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
                              color: Colors.blue,
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
                    controller: namecontroller,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'CakeName',
                      hintText: 'Enter CakeName',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(
                          color: Colors
                              .blue.shade100), // กำหนดสีให้กับตัวอักษร Label
                      hintStyle: TextStyle(
                          color: Colors
                              .blue.shade100), // กำหนดสีให้กับตัวอักษร Hint
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
                    controller: Descontroller,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Details',
                      hintText: 'Enter Details',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(
                          color: Colors
                              .blue.shade100), // กำหนดสีให้กับตัวอักษร Label
                      hintStyle: TextStyle(
                          color: Colors
                              .blue.shade100), // กำหนดสีให้กับตัวอักษร Hint
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
                    controller: pricecontroller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Price',
                      hintText: 'Enter price',
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(
                          color: Colors
                              .blue.shade100), // กำหนดสีให้กับตัวอักษร Label
                      hintStyle: TextStyle(
                          color: Colors
                              .blue.shade100), // กำหนดสีให้กับตัวอักษร Hint
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
                        final isValidFrom = formKey.currentState.validate();
                        if (isValidFrom) {
                          if (file != null ||
                              pricecontroller.toString().isEmpty) {
                            uplodeimageandsave();
                            Navigator.pop(context);
                          }
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("กรุณาตรวจสอบข้อมูล"),
                                actions: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors
                                          .pink.shade100, // สีปุ่มเป็นสีชมพู
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("OK"),
                                  ),
                                ],
                              );
                            },
                          );
                        }
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

  Future<Null> uplodeimageandsave() async {
    var cn_price = pricecontroller.text;
    var cakename = namecontroller.text;
    var details = Descontroller.text;
    Random random = Random();
    int i = random.nextInt(100000);

    String nameimage = 'no$i.jpg';
    String url = '${API.BASE_URL}/flutterapi/src/saveimage.php';

    try {
      Map<String, dynamic> map = Map();
      map['file'] =
          await MultipartFile.fromFile(file.path, filename: nameimage);
      FormData formData = FormData.fromMap(map);

      await Dio().post(url, data: formData).then((value) async {
        String cn_images = '$nameimage';
        String urlInsert =
            '${API.BASE_URL}/flutterapi/src/addCake.php?isAdd=true&cn_cakename=$cakename&cn_desc=$details&cn_price=$cn_price&cn_images=$cn_images&size_id=size_id';
        await Dio().get(urlInsert).then((value) {
          showDialog(
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('เสร็จสิ้น'),
                content: Text('การอัปโหลดและบันทึกเสร็จสิ้น'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // ปิด Dialog
                    },
                    child: Text('ตกลง'),
                  ),
                ],
              );
            },
          );
          print('it is : {$cn_images,} and {${cn_price}');
        });
      });
    } catch (e) {}
  }
} //end
