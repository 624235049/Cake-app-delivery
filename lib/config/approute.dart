import 'package:appbirthdaycake/Login/login_page.dart';
import 'package:appbirthdaycake/Register/register.dart';
import 'package:appbirthdaycake/custumer/HomeScreen/homepage.dart';
import 'package:appbirthdaycake/custumer/HomeScreen/logout.dart';
import 'package:appbirthdaycake/custumer/HomeScreen/profile.dart';
import 'package:appbirthdaycake/custumer/cakepage/cake_detail.dart';
import 'package:appbirthdaycake/custumer/cakepage/cake_ds.dart';
import 'package:appbirthdaycake/custumer/cakepage/cake_page.dart';
import 'package:appbirthdaycake/custumer/mappage.dart';
import 'package:appbirthdaycake/custumer/payment/peymentpage.dart';
import 'package:appbirthdaycake/custumer/review/review_page.dart';
import 'package:appbirthdaycake/custumer/shopping/cart_body.dart';
import 'package:appbirthdaycake/custumer/shopping/history_page.dart';
import 'package:appbirthdaycake/shop_owner/home/addcake_page.dart';
import 'package:appbirthdaycake/shop_owner/home/editcake_page.dart';
import 'package:appbirthdaycake/shop_owner/home/homescreen.dart';
import 'package:appbirthdaycake/shop_owner/order/home_shop.dart';
import 'package:appbirthdaycake/shop_owner/order/mapdelivery.dart';
import 'package:appbirthdaycake/shop_owner/order/order_cakecomfrim.dart';
import 'package:appbirthdaycake/shop_owner/order/order_delivery.dart';
import 'package:appbirthdaycake/shop_owner/order/order_detail.dart';
import 'package:appbirthdaycake/shop_owner/order/shop_order.dart';
import 'package:appbirthdaycake/shop_owner/signature/signature_page.dart';
import 'package:appbirthdaycake/shop_owner/so_cake/so_cakepage.dart';
import 'package:flutter/cupertino.dart';

import '../custumer/HomeScreen/Editmap.dart';

class AppRoute {
  static const LoginRoute = "Login";
  static const RegisterRoute = "Register";
  static const HomeRoute = "HomePage";
  static const TypeCakeRoute = "TypeCakePage";
  static const CakeRoute = "CakePage";
  static const CakeDetailRoute = "CakeDetail";
  static const CakeDesignRoute = "CakeDesign";
  static const SOCakeRoute = "SOCake";
  static const HomeShopOwnerRoute = "HomeOS";
  static const ProfileRoute = "Profile";
  static const LogoutRoute = "Logout";
  static const CartRoute = "Cart";
  static const PeymentRoute = "Peyment";
  static const MapRoute = "Map";
  static const HistoryRoute = "History";
  static const ReviewRoute = "Review";
  static const orderRoute = "Order";
  static const AddCakeRoute = "AddCake";
  static const orderDetailRoute = "orderdetail";
  static const ShopOrderRoute = "ShopOrder";
  static const EditCakeRoute = "Editcake";
  static const HomeOrderRoute = "HomeOrder";
  static const OrderDeriveryRoute = "OrderDerivery";
  static const SignatureRoute = "Signature";
  static const MapDeliveryRoute = "MapDelivery";
  static const EditLatLng = "EditLatLng";

  final _route = <String, WidgetBuilder>{
    LoginRoute: (context) => LoginPage(),
    RegisterRoute: (context) => RegisterPage(),
    HomeRoute: (context) => HomePage(),
    CakeRoute: (context) => CakePage(),
    CakeDetailRoute: (context) => CakeDetail(),
    CakeDesignRoute: (context) => CakeDesignPage(),
    SOCakeRoute: (context) => SOCakePage(),
    HomeShopOwnerRoute: (context) => HomeShopOwner(),
    ProfileRoute: (context) => AccountPage(),
    CartRoute: (context) => CartBody(),
    PeymentRoute: (context) => PayMentPage(),
    MapRoute: (context) => MapPage(),
    HistoryRoute: (context) => HistoryPage(),
    ReviewRoute: (context) => ReviewPage(),
    orderRoute: (context) => OrderPage(),
    AddCakeRoute: (context) => AddCakePage(),
    orderDetailRoute: (context) => OrderDetailPage(),
    ShopOrderRoute: (context) => ShopOrderPage(),
    EditCakeRoute: (context) => EditCakePage(),
    HomeOrderRoute: (context) => HomeShopPage(),
    OrderDeriveryRoute: (context) => OrderliveryPage(),
    SignatureRoute: (context) => SignaturePage(),
    MapDeliveryRoute: (context) => FollowMapCustomerPage(),
    EditLatLng: (context) => EditMapPage(),
  };
  get getAll => _route;
}
