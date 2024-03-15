class ReviewModel {
  int rv_id;
  String score;
  String user_name;

  ReviewModel({this.rv_id, this.score,this.user_name});

  ReviewModel.fromJson(Map<String, dynamic> json) {
      rv_id = json['rv_id'];
      score = json['score'];
      user_name = json['user_name'];
  }

  Map<String, dynamic> toJson()  {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['rv_id'] = this.rv_id;
  data['score'] = this.score;
  data['user_name'] = this.user_name;
  return data;
  }
}