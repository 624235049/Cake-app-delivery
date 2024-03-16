class API {
  static const String BASE_URL = 'http://192.168.1.35:8080';
  String keyId = 'id';
  String keyType = 'chooseType';
  String keyName = 'name';

//cakegenerals
  static const String CAKE_N = '/flutterapi/src/getCakeAll.php?isAdd=true';
  static const String CN_IMAGE = BASE_URL + '/flutterapi/src/cake/';
  static const String CAKE_SIZE = '/flutterapi/api/cake_size';
  static const String Order = '/flutterapi/api/order_table';

  List<String> createStringArray(String string) {
    if (string.isEmpty || string.length < 2) {
      return [];
    }
    String resultString = string.substring(1, string.length - 1);
    List<String> list = resultString.split(',');
    int index = 0;
    for (var item in list) {
      list[index] = item.trim();
      index++;
    }
    return list;
  }
}
