// @dart=2.9
import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:green_big_5/Network/changeDisplayNameNetwork.dart';
import 'package:green_big_5/Network/userNetwork.dart';
import 'package:green_big_5/model/userModel.dart';
import 'package:green_big_5/pages/userProfile.dart';
import 'package:green_big_5/utill/UserSecureStorage.dart';

import '../Network/addressUpdate.dart';
import 'failConnect.dart';
class changeDisplayName extends StatefulWidget {
  const changeDisplayName({Key key}) : super(key: key);
  @override
  _changeDisplayNameState createState() => _changeDisplayNameState();
}

class _changeDisplayNameState extends State<changeDisplayName> {
  final _phoneNumber=UserSecureStorage.getUserValue();
  Future<userModel> user=userNetwork().getUser('0932478783');
  bool changeSuccess=true;
  String textAlert="";
  bool connection=true;
  final _formKey=GlobalKey<FormState>();
  final displayName=TextEditingController();
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }
    if (!mounted) {
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
    _phoneNumber.then((value){
      setState(() {
        user=userNetwork().getUser(value);
        Timer.periodic(new Duration(seconds: 10), (timer) {
          //debugPrint(timer.tick.toString());
          postAddress(value);
        });
      });
    });
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
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
      return RefreshIndicator(
        onRefresh: ()async{},
        child: Scaffold(
          body: SafeArea(
            child: ListView(
              children: [
                FutureBuilder<userModel>(
                  future: user,
                  builder: (BuildContext context,AsyncSnapshot<userModel> snapshot){
                    if(snapshot.hasData){
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          FirstView(context,snapshot),
                          TextFieldDisplayName(context),
                          Notificationinput(context),
                          submitButton(context),
                          SizedBox(height: 10,),
                          TextAlert(context)
                        ],
                      );
                    }
                    else{
                      return Container(
                          width:MediaQuery.of(context).size.width,
                          height:MediaQuery.of(context).size.height,
                          child:Center(
                              child:CircularProgressIndicator()
                          )
                      );
                    }
                  },

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
  Widget FirstView(BuildContext context,AsyncSnapshot<userModel> snapshot){
    return Container(
      margin: EdgeInsets.only(top: 70),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(36.0, 0, 36.0, 25.0),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 10.0),
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0,3)
                        )
                      ],
                      image: DecorationImage(
                        image: AssetImage("assets/image/user.png"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(150.0),
                      border: Border.all(
                        color: Colors.white,
                        width: 5.0,
                      )
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Chào mừng",style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: HexColor("#9F9F9F")
                        )
                    ),
                    ),
                    Text(snapshot.data.displayName,style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: HexColor("#3C3838")
                        )
                    ),)
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(27, 0, 27, 50),
            child: Divider(
              thickness: 1,
              color: HexColor("#9F9F9F"),
            ),
          )
        ],
      ),
    );
  }
  Widget TextFieldDisplayName(BuildContext context){
    return Container(
      margin: EdgeInsets.only(top: 25),
      padding: EdgeInsets.only(left: 36,right: 36),
      child: Center(
        child: Form(
          key: _formKey,
          child: TextFormField(
            controller: displayName,
            maxLength: 12,
            validator: (value){
              if(value==null||value.trim().isEmpty){
                return "Xin vui lòng nhập tên hiển thị";
              }
              else{
                return null;
              }
            },
            style: GoogleFonts.roboto(
              textStyle: TextStyle(
                fontSize: 18
              )
            ),

          decoration: InputDecoration(
            counterText: "",
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: HexColor("#29BB89"),width: 1.0,style: BorderStyle.solid)
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black,width: 1.0,style: BorderStyle.solid)
            ),
            hintText: "Tên hiển thị của bạn",
              hintStyle: GoogleFonts.roboto(textStyle: TextStyle(fontSize: 18,fontWeight: FontWeight.w500,color: HexColor("#9F9F9F").withOpacity(0.5)))
          ),
          ),
        ),
      ),
    );
  }
  Widget Notificationinput(BuildContext context){
    return Container(
      margin: EdgeInsets.only(top: 5.0),
      padding: EdgeInsets.only(left: 36,right: 36),
      child: Column(
        children: [
          Text("Bạn có thể chọn tên của mình làm tên người dùng trên Green Big 5. Nếu bạn làm như vậy, mọi người sẽ có thể tìm thấy bạn",
          style: GoogleFonts.roboto(
            textStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: HexColor("#868383")
            )
          ),
          ),
          SizedBox(height: 10.0,),
          Text(" You can use a-z, 0-9 and underscores.",
            style: GoogleFonts.roboto(
                textStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: HexColor("#868383")
                )
            ),
          ),
        ],
      ),
    );
  }
  Widget submitButton(BuildContext context){
    return Container(
      margin: EdgeInsets.only(top:50),
     width: MediaQuery.of(context).size.width,
      child: Center(
        child: Container(
          height: 50,
          width: 100,
          child: ElevatedButton(
            onPressed: (){
              if(_formKey.currentState.validate()){
                if(connection==true){
                  submitChangeDisplay();
                }
                else{
                  setState(() {
                    textAlert="Vui lòng kiểm tra kết nối";
                  });
              }
              }

            },
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor: MaterialStateProperty.all<Color>(HexColor("#2FBB89").withOpacity(0.5)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    )
                )
            ),
            child: Text("Submit",style: GoogleFonts.roboto(
              textStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18
              )
            ),),
          ),
        ),
      ),
    );
  }
  Widget TextAlert(BuildContext context) {
    if (changeSuccess == true) {
      return Container(
        child: Center(
          child: DefaultTextStyle(
              style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.w300
              ),
              child: AnimatedTextKit(
                  animatedTexts: [
                    WavyAnimatedText(
                        textAlert, speed: Duration(milliseconds: 50)),
                  ],
                  isRepeatingAnimation: true,
                  repeatForever: true
              )
          ),
        ),
      );
    }
    else {
      return Container(
        child: Center(
          child: Text(
            textAlert, style: GoogleFonts.roboto(
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
  void submitChangeDisplay(){
    _phoneNumber.then((value){
      setState(() {
        textAlert="Vui lòng đợi vài giây......";
      });
      Future doneWork=changeDisplayNameNetwork().changeDisplayNameMethod(displayName.text, value);
      doneWork.then((value){
        if(value["error"]=="No") {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => userProfile()));
        }
        else{
          setState(() {
            textAlert=value["error"];
          });
        }
      });
    });

  }

  String Address = 'Da Nang';
  String Country = 'Viet Nam';

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> GetAddressFromLatLong(Position position)async {
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    Address = '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}';
    Country = '${place.country}';
    setState(()  {
    });
  }

  Future postAddress(String phoneNumber) async{
    Position position = await _getGeoLocationPosition();
    GetAddressFromLatLong(position);
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

    Placemark place = placemarks[0];
    Address = '${place.street}, ${place.administrativeArea}';
    Country = '${place.postalCode}, ${place.country}';
    setState(() {
      String address = Address + " " + Country;
      print(address);
      addressUpdate().postAddress(phoneNumber, address);
    });
  }
}
