import 'dart:convert';
import 'package:green_big_5/utill/Verification.dart';
import 'package:http/http.dart' as http;

class registerNetwork {
  Future postRegister(String phoneNumber, String fullName,String displayName, int location, int gender, int age,
      String password) async {
    var Key = Validation.Key;
    var url = Uri.parse("http://192.168.1.11:5000/users/register");
    var response = await http.post(
      url,
      headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "phoneNumber": phoneNumber,
          "fullName": fullName,
          "displayName": displayName,
          "addressLive": location,
          "gender": gender,
          "age": age,
          "key": Key,
          "password": password
        }),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    else {
      throw Exception("Error");
    }
  }
}