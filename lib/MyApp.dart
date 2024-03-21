import 'package:appbirthdaycake/Login/login_page.dart';
import 'package:appbirthdaycake/config/approute.dart';
import 'package:appbirthdaycake/custumer/HomeScreen/homepage.dart';
import 'package:appbirthdaycake/shop_owner/home/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:appbirthdaycake/config/appsetting.dart';
import 'config/api.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus.unfocus();
        }
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: AppRoute().getAll,
        theme: ThemeData(primaryColor: Colors.blue.shade100),
        builder: (context, child) => ResponsiveWrapper.builder(
            BouncingScrollWrapper.builder(context, child),
            breakpoints: [
              ResponsiveBreakpoint.resize(240, name: MOBILE),
              ResponsiveBreakpoint.resize(650, name: TABLET),
            ]),
        home: FutureBuilder(
          future: SharedPreferences.getInstance(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container(color: Colors.white);
            }
            final preferences = snapshot.data;
            final token =
                preferences.getString(AppSetting.userNameSetting ?? '');
            final chooseType = preferences.getString(API().keyType ?? '');

            if (token != null) {
              if (chooseType == 'Customer') {
                return HomePage();
              } else if (chooseType == 'ShopOwner') {
                return HomeShopOwner();
              } else {
                print('Invalid chooseType');
              }
            }
            return LoginPage();
          },
        ),
      ),
    );
  }
}
