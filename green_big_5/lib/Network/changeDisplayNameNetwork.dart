import 'dart:convert';

import 'package:green_big_5/utill/Verification.dart';
// ignore: import_of_legacy_library_into_null_safe
import "package:http/http.dart" as http;
class changeDisplayNameNetwork {
  Future changeDisplayNameMethod(String displayName, String phoneNumber) async {
    var url =Uri.parse("http://192.168.1.11:5000/users/changeDisplayName");
    var key = Validation.KeyChangeDisplayName;
    var response=await http.post(url, body:{
      "phoneNumber": phoneNumber,
      "key": key,
      "displayName": displayName
    });
    if(response.statusCode==200){
      return jsonDecode(response.body);
    }
    else{
      throw Exception("Error");
    }
  }
}