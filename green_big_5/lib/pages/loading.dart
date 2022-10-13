//@dart=2.9
import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:green_big_5/Network/userNetwork.dart';
import 'package:green_big_5/model/userModel.dart';
import 'package:green_big_5/pages/Question.dart';
import 'package:green_big_5/pages/failConnect.dart';
import 'package:green_big_5/utill/UserSecureStorage.dart';
class loadingMain extends StatefulWidget {
  const loadingMain({Key key}) : super(key: key);

  @override
  _loadingMainState createState() => _loadingMainState();
}

class _loadingMainState extends State<loadingMain> {
  Future<userModel> user;
  bool connection;
  final _phoneNumber=UserSecureStorage.getUserValue();
  final Connectivity _connectivity=Connectivity();
  StreamSubscription<ConnectivityResult>  _connectivitySubscription;
  Future<void> initConnectivity() async {
    ConnectivityResult result=ConnectivityResult.none;
    try{
      result=await _connectivity.checkConnectivity();
    } on PlatformException catch(e){
      print(e.toString());
    }
    if(!mounted){
      return Future.value(null);
    }
    return _updateConnectionStatus(result);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    initConnectivity();
    _connectivitySubscription=_connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _phoneNumber.then((value){
      user=userNetwork().getUser(value);
      user.then((value){
            Navigator.push(context,MaterialPageRoute(builder: (context)=>Question()));
      });
    });

  }
  @override
  Widget build(BuildContext context) {
    if(connection==true){
      return WillPopScope(
          child: SafeArea(
            child: Scaffold(
              body: Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),
          onWillPop: ()async=>false);
    }
    else{
      return failConnect();
    }

  }
  Future<void> _updateConnectionStatus(ConnectivityResult result) async{
    switch(result){
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        setState(() {
          connection=true;
        });
        break;
      default:
        setState(() {
          connection=false;
        });
        break;
    }
  }
}

