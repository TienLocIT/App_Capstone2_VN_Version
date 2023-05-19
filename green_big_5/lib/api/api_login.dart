
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
  Future login(String username,String password) async {
    final url=Uri.parse("https://greenbigfive-2.herokuapp.com/admin/user");
    Map<String, String> headers = {"Content-type": "application/json"};
    final msg = convert.jsonEncode({"username":username,"password":password});
    http.Response response=await http.post(url,headers:headers,body: msg);
    var body=response.body;
    var data=convert.jsonDecode(body);
    return data;
}
