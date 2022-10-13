import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:green_big_5/utill/Verification.dart';
class questionsNetwork{
  Future postQuestionsAndGetUsers(String phoneNumber) async {
     var key=Validation.KeyPostUser;
    var url = Uri.parse("http://192.168.1.11:5000/users/postQuestions");
     var response = await http.post(
       url,
       headers: <String, String>{
         'Content-Type': 'application/json; charset=UTF-8',
       },
       body: jsonEncode({
         "phoneNumber": phoneNumber,
         "key": key
       }),
     );
     await http.post(url, body:response.body);

    // if(response.statusCode==200){
    //   return userModel.fromJson(jsonDecode(response.body));
    // }
    // else{
    //   throw Exception("Error");
    // }
  }
}