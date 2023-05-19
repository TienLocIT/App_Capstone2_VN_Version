import 'dart:convert';

import "package:http/http.dart" as http;
import 'package:green_big_5/model/userModel.dart';
import 'package:green_big_5/utill/Verification.dart';
class userNetwork{
  Future<userModel> getUser(String phoneNumber) async {
      String key=Validation.KeyGetUser;
      var url=Uri.parse("http://192.168.50.198:5000/users/getUser?phoneNumber=$phoneNumber&key=$key");
      var response=await http.get(url);
      print('abc : ${response}');
      if(response.statusCode==200){
        return userModel.fromJson(jsonDecode(response.body));
      }
      else{
        throw Exception("error");
      }
  }
}