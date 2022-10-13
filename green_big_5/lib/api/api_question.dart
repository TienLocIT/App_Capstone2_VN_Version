import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
 question()async{
  final url=Uri.parse("https://192.168.1.11:5000/admin/questions");

  http.Response response=await http.get(url);
  var body=response.body;
  var data=convert.jsonDecode(body);
  var dataList=data.toList();
  return dataList;
}
questionPost(List answer,String id)async{
 final url=Uri.parse("http://192.168.1.11:5000/admin/questions?id=$id");
 var answerResult=[];
 for(var i=0;i<=answer.length-1;i++){
  String json=convert.jsonEncode(answer[i]);
  answerResult.add(json);
 }
 Map<String, String> headers = {"Content-type": "application/json"};
 final msg = convert.jsonEncode(answerResult);
 http.Response response=await http.post(url,headers:headers,body:msg);
 var body=response.body;
 var data=convert.jsonDecode(body);
 return data;
}