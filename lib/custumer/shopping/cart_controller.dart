import 'package:appbirthdaycake/custumer/model/cake_n_model.dart';
import 'package:appbirthdaycake/custumer/model/cart_model.dart';
import 'package:appbirthdaycake/custumer/shopping/cart_repo.dart';
import 'package:get/get.dart';

class CartController extends GetxController{
  final CartRepo cartRepo;
  CartController({this.cartRepo});
  Map<String, CartModel> _items={};


  void addItem(CakeNModel cake, String amount){
  //   _items.putIfAbsent(cake.id, () => CartModel(
  //       id: cake.id,
  //       cake_id:cake.cake_id,
  //       cake_size:cake.cake_size,
  //       this.cake_img,
  //       this.cake_date,
  //       this.cake_text,
  //       this.price,
  //       this.amount,
  //       this.sum,
  //       this.time
  //   ));
   }

}