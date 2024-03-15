import 'dart:convert';

CakeNModel cakeNModelFromJson(String str) =>
    CakeNModel.fromJson(json.decode(str));

String cakeNModelToJson(CakeNModel data) => json.encode(data.toJson());

class CakeNModel {
  List<Cakens> cakens;

  CakeNModel({this.cakens});

  CakeNModel.fromJson(Map<String, dynamic> json) {
    if (json['cakens'] != null) {
      cakens = <Cakens>[];
      json['cakens'].forEach((v) {
        cakens.add(new Cakens.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.cakens != null) {
      data['cakens'] = this.cakens.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cakens {
  dynamic cnId;
  String cnCakename;
  String cnDesc;
  String cnPrice;
  String cnImages;
  dynamic sizeId;

  Cakens({
    this.cnId,
    this.cnCakename,
    this.cnDesc,
    this.cnPrice,
    this.cnImages,
    this.sizeId,
  });

  Cakens.fromJson(Map<String, dynamic> json) {
    cnId = json['cn_id'];
    cnCakename = json['cn_cakename'];
    cnDesc = json['cn_desc'];
    cnPrice = json['cn_price'];
    cnImages = json['cn_images'];
    sizeId = json['size_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cn_id'] = this.cnId;
    data['cn_cakename'] = this.cnCakename;
    data['cn_desc'] = this.cnDesc;
    data['cn_price'] = this.cnPrice;
    data['cn_images'] = this.cnImages;
    data['size_id'] = this.sizeId;
    return data;
  }
}
