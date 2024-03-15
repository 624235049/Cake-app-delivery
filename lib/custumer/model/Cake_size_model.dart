class CakeSize {
  int sizeId;
  String cnSize;

  CakeSize({this.sizeId, this.cnSize});

  CakeSize.fromJson(Map<String, dynamic> json) {
    sizeId = json['size_id'];
    cnSize = json['cn_size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['size_id'] = this.sizeId;
    data['cn_size'] = this.cnSize;
    return data;
  }

  static List<CakeSize> fromJsonList(dynamic json) {
    List<CakeSize> cakeSizes = [];
    if (json is List) {
      json.forEach((item) {
        cakeSizes.add(CakeSize.fromJson(item));
      });
    } else if (json is Map) {
      cakeSizes.add(CakeSize.fromJson(json));
    }
    return cakeSizes;
  }
}