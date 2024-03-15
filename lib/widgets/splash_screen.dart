import 'package:appbirthdaycake/Login/login_page.dart';
import 'package:appbirthdaycake/config/api.dart';
import 'package:appbirthdaycake/config/approute.dart';
import 'package:appbirthdaycake/widgets/dialog.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkPreference();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pop();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
//        }
//      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(25),
              child: SizedBox(),
            ),
            Container(
              margin: EdgeInsets.all(25),
              child: Image.asset(
                'assets/images/7025560.png',
                width: 400,
              ),
            ),
            Container(
              margin: EdgeInsets.all(25),
              child: FittedBox(
                child:  Text(
                  '2019 \u00a9  BirthDay Cake. All Rights Reserved',
                  style: TextStyle(
                    fontSize: 11,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Null> checkPreference() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String chooseType = preferences.getString(API().keyType);

      if (chooseType != null && chooseType.isNotEmpty) {
        if (chooseType == 'Customer') {
          Navigator.pushNamedAndRemoveUntil(context, AppRoute.HomeRoute, (route) => false);
          print("preferense customer success");
        } else if (chooseType == 'Admin') {
          Navigator.pushNamedAndRemoveUntil(context, AppRoute.HomeShopOwnerRoute, (route) => false);
          print("preferense adminn success");
        } else {
          normalDialog(context, 'Error user Type!');
        }
      }
    } catch (e) {
    }
  }
}
