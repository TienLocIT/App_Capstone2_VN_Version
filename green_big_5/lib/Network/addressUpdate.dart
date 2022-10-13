import 'dart:convert';
import "package:http/http.dart" as http;
import 'package:green_big_5/utill/Verification.dart';
class addressUpdate{
  Future postAddress(String phoneNumber,String address) async{
    final url=Uri.parse("http://192.168.1.11:5000/users/address/update");
    final key=Validation.KeyUpdateAddress;
    var response = await http.post(
      url,
      body: jsonEncode({
        "phoneNumber":phoneNumber,
        "key":key,
        "address":address,
      }),
    );
    print("address:"+address);
    print("phone:"+phoneNumber);
    await http.post(url,body: response.body);
  }
}