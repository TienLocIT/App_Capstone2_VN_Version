import 'dart:convert';

// ignore: import_of_legacy_library_into_null_safe
import "package:http/http.dart" as http;
import 'package:green_big_5/utill/Verification.dart';
class answerNetwork{
  Future postAnswer(String phoneNumber,String id,String question,String answer,String index,String dem) async{
    final url=Uri.parse("http://192.168.50.198:5000/users/postAnswer");
    final key=Validation.KeyPostUser;
    var response = await http.post(
      url,
      body: jsonEncode({
        "phoneNumber":phoneNumber,
        "key":key,
        "id":id,
        "question":question,
        "answer":answer,
        "index":index,
        "dem":dem,
      }),
    );
    print(jsonEncode(<String,dynamic>{
      "phoneNumber":phoneNumber,
      "key":key,
      "id":id,
      "question":question,
      "answer":answer,
      "index":index,
      "dem":dem,
    }));
    await http.post(url,body: response.body);
  }
}