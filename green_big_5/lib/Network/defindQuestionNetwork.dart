import 'dart:convert';

import 'package:green_big_5/utill/Verification.dart';
import 'package:http/http.dart' as http;
class defindQuestionNetwork{
  Future postAnswer(final id,final phoneNumber,final answer,final index,final question)async{
      final url=Uri.parse("http://192.168.1.11:5000/users/postAnswerDefine");
      final key=Validation.KeyPostUser;
      await http.post(url,headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },body:jsonEncode(<String,String>{
        "phoneNumber":phoneNumber,
        "question":question,
        "id":id,
        "answer":answer,
        "index":index,
        "key":key
      }));
  }
}