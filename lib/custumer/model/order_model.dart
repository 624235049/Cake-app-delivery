class OrderModel {
  String orderId;
  String orderDateTime;
  String cakeId;
  String userId;
  String userName;
  String size;
  String text;
  String imgcake;
  String price;
  String amount;
  String sum;
  String pickup_date;
  String status;
  String paymentStatus;
  String distance;
  String transport;

  OrderModel(
      {this.orderId,
        this.orderDateTime,
        this.cakeId,
        this.userId,
        this.userName,
        this.size,
        this.text,
        this.imgcake,
        this.price,
        this.amount,
        this.sum,
        this.pickup_date,
        this.status,
        this.paymentStatus,
        this.distance,
        this.transport});

  OrderModel.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    orderDateTime = json['order_date_time'];
    cakeId = json['cake_id'];
    userId = json['user_id'];
    userName = json['user_name'];
    size = json['size'];
    text = json['text'];
    imgcake = json['imgcake'];
    price = json['price'];
    amount = json['amount'];
    sum = json['sum'];
    pickup_date = json['pickup_date'];
    status = json['status'];
    paymentStatus = json['payment_status'];
    distance = json['distance'];
    transport = json['transport'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['order_date_time'] = this.orderDateTime;
    data['cake_id'] = this.cakeId;
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['size'] = this.size;
    data['text'] = this.text;
    data['imgcake'] = this.imgcake;
    data['price'] = this.price;
    data['amount'] = this.amount;
    data['sum'] = this.sum;
    data['sum'] = this.pickup_date;
    data['status'] = this.status;
    data['payment_status'] = this.paymentStatus;
    data['distance'] = this.distance;
    data['transport'] = this.transport;
    return data;
  }
  static List<OrderModel> fromJsonList(dynamic json) {
    List<OrderModel> OrderModels = [];
    if (json is List) {
      json.forEach((item) {
        OrderModels.add(OrderModel.fromJson(item));
      });
    } else if (json is Map) {
      OrderModels.add(OrderModel.fromJson(json));
    }
    return OrderModels;
  }

}