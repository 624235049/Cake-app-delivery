import 'package:appbirthdaycake/custumer/shopping/cart_controller.dart';
import 'package:appbirthdaycake/custumer/shopping/cart_repo.dart';
import 'package:get/get.dart';

Future<void> init()async{

  //repo
  Get.lazyPut(()=>CartRepo());
  
  //controllers
  Get.lazyPut(() =>CartController (cartRepo: Get.find()));
}