import 'dart:typed_data';
import 'package:appbirthdaycake/config/approute.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio;
import 'package:http_parser/http_parser.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;
import 'package:appbirthdaycake/config/api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

class SignaturePage extends StatefulWidget {
  const SignaturePage({Key key}) : super(key: key);

  @override
  _SignaturePageState createState() => _SignaturePageState();
}

class _SignaturePageState extends State<SignaturePage> {
  final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Signature Pad',
          style: TextStyle(color: Colors.blue[100]),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.blue[100],
          ),
          onPressed: () {
            Navigator.pushNamed(context, AppRoute.HomeOrderRoute);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SfSignaturePad(
              key: _signaturePadKey,
              backgroundColor: Colors.white,
              strokeColor: Colors.black,
              minimumStrokeWidth: 1.0,
              maximumStrokeWidth: 4.0,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.red.shade300), // เปลี่ยนสีพื้นหลังเป็นสีแดง
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white)),
                onPressed: () {
                  _signaturePadKey.currentState?.clear();
                },
                child: Text('Clear'),
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.blue.shade100), // เปลี่ยนสีพื้นหลังเป็นสีแดง
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white)),
                onPressed: () async {
                  ui.Image image =
                  await _signaturePadKey.currentState.toImage(pixelRatio: 3.0);
                  ByteData byteData = await image.toByteData(
                    format: ui.ImageByteFormat.png,
                  );
                  if (byteData != null) {
                    Uint8List imageData = byteData.buffer.asUint8List();
                    bool isEmpty = _isSignatureEmpty(imageData);
                    if (!isEmpty) {
                      Uint8List resizedImageData =
                      await _resizeImage(imageData, 800, 800);
                      await _saveSignature(resizedImageData);
                    } else {
                      print('Signature is empty');
                    }
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<Uint8List> _resizeImage(
      Uint8List imageData,
      int maxWidth,
      int maxHeight,
      ) async {
    img.Image image = img.decodeImage(imageData);
    img.Image resizedImage = img.copyResize(
      image,
      width: maxWidth,
      height: maxHeight,
    );
    Uint8List resizedImageData = Uint8List.fromList(img.encodePng(resizedImage));
    return resizedImageData;
  }

  bool _isSignatureEmpty(Uint8List imageData) {
    bool isEmpty = true;
    for (int i = 0; i < imageData.length; i++) {
      if (imageData[i] != 0) {
        isEmpty = false;
        break;
      }
    }
    return isEmpty;
  }

  Future<void> _saveSignature(Uint8List imageData) async {
    String fileName = DateTime.now().toIso8601String();
    String url = '${API.BASE_URL}/flutterapi/src/savesignature.php';
    try {
      // สร้างไฟล์ MultipartFile จาก Uint8List โดยใช้ http_parser
      MultipartFile file = MultipartFile.fromBytes(
        imageData,
        filename: '$fileName.png',
        contentType: MediaType('image', 'png'),
      );

      // ส่งไฟล์ภาพไปยังเซิร์ฟเวอร์โดยใช้ dio
      FormData formData = FormData.fromMap({
        'file': file,
      });
      Response response = await Dio().post(url, data: formData);

      if (response.statusCode == 200) {
        // บันทึกลายเซ็นลงในฐานข้อมูลโดยใช้ dio
        String path = '${API.BASE_URL}/flutterapi/src/addSignature.php?isAdd=true&snt_imge=$fileName.png';
        Response dioResponse = await Dio().get(path);
        if (dioResponse.statusCode == 200) {
          print('Saved signature: $fileName');
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('สำเร็จแล้ว',),
                content: Text('บันทึกลายเซ็นเรียบร้อยแล้ว'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                actions: [
                  TextButton(
                    child: Text('ปิด'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
        } else {
          print('Failed to save signature: ${dioResponse.statusCode}');
        }
      } else {
        print('Failed to upload image: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to save signature: $e');
    }
  }


}
