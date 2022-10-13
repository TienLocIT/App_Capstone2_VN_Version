// @dart=2.9
import 'dart:async';
import "package:animated_text_kit/animated_text_kit.dart";
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:green_big_5/Network/addressUpdate.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:green_big_5/Network/loginNetwork.dart';
import 'package:green_big_5/pages/registerPage.dart';
import 'package:green_big_5/utill/UserSecureStorage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';


import 'failConnect.dart';
import 'loading.dart';
class loginPage extends StatefulWidget {
  const loginPage({Key key}) : super(key: key);

  @override
  _loginPageState createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {

  bool submitConnection;
   FocusNode phoneNumberFocus;
   FocusNode passwordFocus;
   bool connection;
  final Connectivity _connectivity=Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  IconData iconPassword=Icons.visibility;
  final _phoneNumber=TextEditingController();
  final _password=TextEditingController();
  bool secureText=true;
  String textAlert="";
  final _formKey=GlobalKey<FormState>();
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
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _connectivitySubscription.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    if(connection==true){
      return WillPopScope(
        onWillPop: () async =>false,
        child: GestureDetector(
          onTap: ()=>FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: Colors.white,
            body: ListView(
              children: [
                SafeArea(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(30, 30, 30, 20),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            firstView(context),
                            midView(context),
                            TextFieldView(context),
                            SizedBox(height:10.0),
                            TextAlert(context),
                            SizedBox(height: 40.0,),
                            BottomView(context),
                          ]
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    else{
      return failConnect();
    }

  }
  Widget firstView(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Chào mừng,",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28.0
          ),
        ),
        Text(
          "Đăng nhập để tiếp tục!",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 25.0,
          ),
        ),
      ],
    );
  }
  Widget midView(BuildContext context){
    return Container(child: Center(child: Image(image: AssetImage("assets/image/logo_green.png"))));
  }
  Widget TextFieldView(BuildContext context){
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            focusNode: phoneNumberFocus,
            controller: _phoneNumber,
            validator: (value){
              if(value==null||value.isEmpty){
                return 'Xin vui lòng nhập số điện thoại';
              }
              else{
                return null;
              }
            },
                maxLength: 11,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  counterText: "",
                  labelStyle: TextStyle(
                  ),
                  border: OutlineInputBorder(
                    borderRadius:BorderRadius.all(Radius.circular(10.0)),
                  ),
                  hintText: "Số điện thoại",
                  labelText: "Số điện thoại",
                )
          ),
          SizedBox(height: 10.0,),
          TextFormField(
            focusNode: passwordFocus,
            controller: _password,
            validator: (value){
              if(value==null||value.isEmpty){
                return 'Xin vui lòng nhập mật khẩu';
              }
              else{
                return null;
              }
            },
              obscureText: secureText,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                    icon: Icon(iconPassword),
                  onPressed: (){
                     securePassword(context);
                  },
                ),
                labelStyle: TextStyle(
                ),
                border: OutlineInputBorder(
                  borderRadius:BorderRadius.all(Radius.circular(10.0)),
                ),
                hintText: "Mật khẩu",
                labelText: "Mật khẩu",
              )
          ),
        ],
      ),
    );
  }
  Widget BottomView(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: new BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.white,
                blurRadius: 25.0, // soften the shadow
                spreadRadius: 7.0, //extend the shadow
                offset: Offset(
                  15.0, // Move to right horizontally
                  15.0, // Move to bottom Vertically
                ),
              )
            ],
          ),
          height: 60.0,
          child: ElevatedButton(
            onPressed: (){
              if(_formKey.currentState.validate()){
                SignIn(context);
              }
            },
            child: Text(
              "Đăng nhập",
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor: MaterialStateProperty.all<Color>(HexColor("#2FBB89")),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    )
                )
            ),
          ),
        ),
        SizedBox(height: 10.0,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Chưa có tài khoản?",style:
              GoogleFonts.roboto(
                textStyle: TextStyle(
                  fontSize: 14,
                  fontWeight:FontWeight.w700,
                  color: HexColor("#C4C4C4"),
                )
              ),
            ),
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context)=>registerPage()
                ));
              },
              child: Text(
                "Đăng ký",
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    color: HexColor("#29BB89"),
                    fontSize: 14,
                    fontWeight: FontWeight.w700
                  )
                ),
              ),
            )
          ],
        ),
        SizedBox(height: 10.0,),

      ],
    );
  }
  Widget TextAlert(BuildContext context){
    if(submitConnection==true){
      return Container(
        child: Center(
          child: DefaultTextStyle(
              style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.w300
              ),
              child:AnimatedTextKit(
                  animatedTexts: [
                    WavyAnimatedText(textAlert,speed: Duration(milliseconds: 50)),
                  ],
                  isRepeatingAnimation: true,
                  repeatForever: true
              )
          ),
        ),
      );
    }
    else{
    return Container(
    child: Center(
    child: Text(
    textAlert,style: GoogleFonts.roboto(
    textStyle: TextStyle(
    color: Colors.red,
    fontSize: 16,
    fontWeight: FontWeight.w300
    )
    ),
    ),
    ),
    );
    }

  }
  void securePassword(BuildContext context){
      setState(() {
        if(secureText==true){
          iconPassword=Icons.visibility_off;
          secureText=false;
        }
        else{
          iconPassword=Icons.visibility;
          secureText=true;
        }
      });
  }
  void SignIn(BuildContext context){
      Future errorHave=loginPostNetwork();
      setState(() {
        submitConnection=true;
        textAlert="Xin vui lòng đợi vài giây.....";
      });
      errorHave.then((value) {
        if (value["error"] == "No") {
          UserSecureStorage.setUserValue(_phoneNumber.text.trim());
          Navigator.push(context, MaterialPageRoute(
              builder: (context) => loadingMain()
          ));
        }
        else {
          setState(() {
            submitConnection=false;
            textAlert = value["error"];
          });
        }
      }
      );
  }
  Future loginPostNetwork()=>
    loginNetwork().loginPostNetwork(_phoneNumber.text.trim(), _password.text.trim());

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
