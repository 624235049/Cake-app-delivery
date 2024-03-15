class CartModel {
  int id;
  String cake_id;
  String cake_size;
  String cake_img;
  String cake_date;
  String cake_text;
  String cake_flavor;
  String amount;
  String price;
  String sum;
  String pickup_date;
  String distance;
  String transport;

  CartModel(
      {this.id,
      this.cake_id,
      this.cake_size,
      this.cake_img,
      this.cake_date,
      this.cake_text,
      this.cake_flavor,
      this.price,
      this.amount,
      this.sum,
      this.pickup_date,
      this.distance,
      this.transport});

  CartModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cake_id = json['cake_id'];
    cake_size = json['cake_size'];
    cake_img = json['cake_img'];
    cake_date = json['cake_date'];
    cake_text = json['cake_text'];
    cake_flavor = json['cake_flavor'];
    amount = json['amount'];
    price = json['price'];
    sum = json['sum'];
    pickup_date = json['pickup_date'];
    distance = json['distance'];
    transport = json['transport'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cake_id'] = this.cake_id;
    data['cake_size'] = this.cake_size;
    data['cake_img'] = this.cake_img;
    data['cake_date'] = this.cake_date;
    data['cake_text'] = this.cake_text;
    data['cake_flavor'] = this.cake_flavor;
    data['amount'] = this.amount;
    data['price'] = this.price;
    data['sum'] = this.sum;
    data['pickup_date'] = this.pickup_date;
    data['distance'] = this.distance;
    data['transport'] = this.transport;
    return data;
  }
}
