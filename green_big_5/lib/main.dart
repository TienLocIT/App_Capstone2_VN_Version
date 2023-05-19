//@dart=2.9
import 'package:flutter/material.dart';
import 'package:green_big_5/pages/loading.dart';
import 'package:green_big_5/pages/loginPages.dart';
import 'package:green_big_5/utill/UserSecureStorage.dart';
import 'package:permission_handler/permission_handler.dart';

import 'model/userModel.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final _phoneNumber=UserSecureStorage.getUserValue();
  _phoneNumber.then((value){
    print(value);
    if(value!=null){
      runApp(MaterialApp(
        home: loadingMain(),
      ));
    }
    else {
      runApp(MaterialApp(
        home: loginPage(),
      ));
    }
  });
}




