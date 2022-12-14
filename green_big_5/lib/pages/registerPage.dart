// @dart=2.9
import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:green_big_5/Network/registerNetwork.dart';
import 'package:green_big_5/pages/Question.dart';
import 'package:green_big_5/pages/loginPages.dart';
import 'package:green_big_5/utill/UserSecureStorage.dart';

import 'failConnect.dart';
class registerPage extends StatefulWidget {
  const registerPage({Key key}) : super(key: key);

  @override
  _registerPageState createState() => _registerPageState();
}

class _registerPageState extends State<registerPage> {
  bool submitConnection;
  bool connection;
  final Connectivity _connectivity=Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final _phoneNumber=TextEditingController();
  final _fullName=TextEditingController();
  final _displayName=TextEditingController();
  final _password=TextEditingController();
  final _repassword=TextEditingController();
  bool _autofocus=false;
  String textAlert="";
  String errorHave="";
  bool secureText=true;
  bool secureTextAnother=true;
  IconData iconPassword=Icons.visibility;
  IconData iconRePassword=Icons.visibility;
  final _formKey=GlobalKey<FormState>();

  int _locationValue = 1;
  int _genderValue = 1;
  int _ageValue = 1;
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
        onWillPop: ()async=>false,
        child: GestureDetector(
          onTap: ()=>FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: Colors.white,
            body: ListView(
              children: [
                SafeArea(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            firstView(context),
                            midView(context),
                            TextFieldView(context),
                            SizedBox(height: 10,),
                            TextAlert(context),
                            SizedBox(height: 30.0,),
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
          "Ch??o m???ng,",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28.0
          ),
        ),
        Text(
          "????ng k?? ????? ti???p t???c!",
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
            controller: _fullName,
              validator: (value){
                if(value==null||value.isEmpty){
                  return 'Xin vui l??ng nh???p t??n c???a b???n';
                }
                else{
                  return null;
                }
              },
              decoration: InputDecoration(
                counterText: "",
                labelStyle: TextStyle(
                ),
                border: OutlineInputBorder(
                  borderRadius:BorderRadius.all(Radius.circular(10.0)),
                ),
                hintText: "T??n ?????y ?????",
                labelText: "T??n ?????y ?????",
              )
          ),
          SizedBox(height: 10,),
          TextFormField(
              maxLength: 12,
              controller: _displayName,
              validator: (value){
                if(value==null||value.isEmpty){
                  return 'Xin vui l??ng nh???p t??n hi???n th???';
                }
                else{
                  return null;
                }
              },
              decoration: InputDecoration(
                counterText: "",
                labelStyle: TextStyle(
                ),
                border: OutlineInputBorder(
                  borderRadius:BorderRadius.all(Radius.circular(10.0)),
                ),
                hintText: "T??n hi???n th???",
                labelText: "T??n hi???n th???",
              )
          ),
          SizedBox(height: 10,),
          TextFormField(
            controller: _phoneNumber,
              validator: (value){
                if(value==null||value.isEmpty){
                  return 'Xin vui l??ng nh???p s??? ??i???n tho???i';
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
                hintText: "S??? ??i???n tho???i",
                labelText: "S??? ??i???n tho???i",
              )
          ),
          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
            child: Row(
              children: <Widget>[
                Text("V??? tr??:"),
                Radio<int>(
                  value: 1,
                  groupValue: _locationValue,
                  onChanged: (value){
                    setState(() {
                      _locationValue = value;
                    });
                  },
                ),
                Text("Th??nh ph???"),
                Radio<int>(
                  value: 2,
                  groupValue: _locationValue,
                  onChanged: (value){
                    setState(() {
                      _locationValue = value;
                    });
                  },
                ),
                Text("N??ng th??n"),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
            child: Row(
              children: <Widget>[
                Text("Gi???i t??nh:  "),
                Radio<int>(
                  value: 1,
                  groupValue: _genderValue,
                  onChanged: (value){
                    setState(() {
                      _genderValue = value;
                    });
                  },
                ),
                Text("Nam gi???i"),
                Radio<int>(
                  value: 2,
                  groupValue: _genderValue,
                  onChanged: (value){
                    setState(() {
                      _genderValue = value;
                    });
                  },
                ),
                Text("N??? gi???i"),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: <Widget>[
                    Text("Tu???i:        "),
                    Radio<int>(
                      value: 1,
                      groupValue: _ageValue,
                      onChanged: (value){
                        setState(() {
                          _ageValue = value;
                        });
                      },
                    ),
                    Text("< 20"),
                    Radio<int>(
                      value: 2,
                      groupValue: _ageValue,
                      onChanged: (value){
                        setState(() {
                          _ageValue = value;
                        });
                      },
                    ),
                    Text("20 - 30"),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text("                "),
                    Radio<int>(
                      value: 4,
                      groupValue: _ageValue,
                      onChanged: (value){
                        setState(() {
                          _ageValue = value;
                        });
                      },
                    ),
                    Text("> 40"),
                    Radio<int>(
                      value: 3,
                      groupValue: _ageValue,
                      onChanged: (value){
                        setState(() {
                          _ageValue = value;
                        });
                      },
                    ),
                    Text("30 - 40"),
                  ],
                )
              ],
            ),
          ),
          TextFormField(
            maxLength: 15,
            controller: _password,
              validator: (value){
                if(value==null||value.isEmpty){
                  return 'Xin vui l??ng nh???p m???t kh???u';
                }
                else{
                  return null;
                }
              },
              obscureText: secureText,
              decoration: InputDecoration(
                counterText: "",
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
                hintText: "M???t kh???u",
                labelText: "M???t kh???u",
              )
          ),
          SizedBox(height: 10,),
          TextFormField(
            autofocus: _autofocus,
            maxLength: 15,
            controller: _repassword,
              validator: (value){
                if(value==null||value.isEmpty){
                  return 'Xin m???i nh???p l???i x??c nh???n m???t kh???u';
                }
                else{
                  return null;
                }
              },
              obscureText: secureTextAnother,
              decoration: InputDecoration(
                counterText: "",
                suffixIcon: IconButton(
                  icon: Icon(iconRePassword),
                  onPressed: (){
                      securePasswordAnother(context);
                  },
                ),
                labelStyle: TextStyle(
                ),
                border: OutlineInputBorder(
                  borderRadius:BorderRadius.all(Radius.circular(10.0)),
                ),
                hintText: "X??c nh???n m???t kh???u",
                labelText: "X??c nh???n m???t kh???u",
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
                if(connection==true){
                  SignUp(context);
                }
                else{
                  setState(() {
                    submitConnection=false;
                    textAlert="Xin vui l??ng ki???m tra k???t n???i...";
                  });
                }
                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(content: Text('Processing Data')),
                // );

              }
            },
            child: Text(
              "????ng k??",
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
            Text("???? c?? t??i kho???n?",style:
            GoogleFonts.roboto(
                textStyle: TextStyle(
                  fontSize: 17,
                  fontWeight:FontWeight.w700,
                  color: HexColor("#C4C4C4"),
                )
            ),
            ),
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                  builder: (context)=>loginPage()
                ));
              },
              child: Text(
                "????ng nh???p",
                style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                        color: HexColor("#29BB89"),
                        fontSize: 17,
                        fontWeight: FontWeight.w700
                    )
                ),
              ),
            )
          ],
        )
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
  void SignUp(BuildContext context){
    if(_password.text.trim()!=_repassword.text.trim()){
      setState(() {
        submitConnection=false;
        textAlert="M???t kh???u v?? x??c nh???n m???t kh???u kh??ng tr??ng nhau";
        _autofocus=true;
        _password.clear();
        _repassword.clear();
      });
    }
    else {
      Future error = postRegister(_phoneNumber.text, _fullName.text,_displayName.text, _locationValue, _genderValue, _ageValue, _password.text);
      setState(() {
        submitConnection=true;
        textAlert="Xin vui l??ng ch??? trong gi??y l??t.....";
      });
      error.then((value) {
        setState(() {
          errorHave=value["error"];
        });
        if(errorHave=="No"){
          UserSecureStorage.setUserValue(_phoneNumber.text.trim());
          Navigator.push(context, MaterialPageRoute(
               builder: (context)=>Question()
           ));
        }else{
          setState(() {
            submitConnection=false;
            textAlert=value["error"];
          });
        }
      });
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
  void securePasswordAnother(BuildContext context){
    setState(() {
      if(secureTextAnother==true){
        iconRePassword=Icons.visibility_off;
        secureTextAnother=false;
      }
      else{
        iconRePassword=Icons.visibility;
        secureTextAnother=true;
      }
    });
  }
  Future postRegister(String phoneNumber,String fullName,String displayName, int location, int gender, int age, String password)=>
      registerNetwork().postRegister(phoneNumber, fullName,displayName, location, gender, age, password);
  Future<void> _updateConnectionStatus(ConnectivityResult result) async{
    switch(result){
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
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
