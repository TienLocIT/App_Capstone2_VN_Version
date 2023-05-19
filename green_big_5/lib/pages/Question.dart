// @dart=2.9
import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:green_big_5/model/questionModel1.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:green_big_5/Network/answerNetwork.dart';
import 'package:green_big_5/Network/questionsNetwork.dart';
import 'package:green_big_5/Network/userNetwork.dart';
import 'package:green_big_5/model/userModel.dart';
import 'package:green_big_5/pages/failConnect.dart';
import 'package:green_big_5/pages/userProfile.dart';
import 'package:green_big_5/utill/UserSecureStorage.dart';

import '../Network/addressUpdate.dart';
class Question extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}
class _HomeState extends State<Question> {
  List<questionModel> listQuestion=[];
  FlutterLocalNotificationsPlugin notificationFlugin=FlutterLocalNotificationsPlugin();
  bool connection;
  final Connectivity _connectivity=Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  var dem=0;
  Color colos=Colors.red;
  final _phoneNumber=UserSecureStorage.getUserValue();
  Future<userModel> userInformation;
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
  Color colorButtonAnswer(String text,AsyncSnapshot<userModel> snapshot,var length){
    if(listQuestion[dem].answer==text){
      return HexColor("#29BB89");
    }
    return Colors.white;
    // if(snapshot.data.user.questions[length-1].questionsDate[dem].answer==text){
    //     return HexColor("#29BB89");
    // }
    // return Colors.white;
  }
  Color colorAnswer(String text,AsyncSnapshot<userModel> snapshot,var length){
    if(listQuestion[dem].answer==text){
      return Colors.white;
    }
    return HexColor("#29BB89");
    // if(snapshot.data.user.questions[length-1].questionsDate[dem].answer==text){
    //   return Colors.white;
    // }
    // return HexColor("#29BB89");
  }
  _postQuestion() {
    _phoneNumber.then((value) {
      questionsNetwork().postQuestionsAndGetUsers(value);
    });
  }
  _getUser(){
    _phoneNumber.then((valuePhone) {
      setState(() {
        // Timer.periodic(new Duration(seconds: 10), (timer) {
        //   //debugPrint(timer.tick.toString());
        //   postAddress(valuePhone);
        // });
        userInformation=userNetwork().getUser(valuePhone);
        userInformation.then((value){
          // final length=value.user.questions.length-1;
          // print(value.user.questions[length].questionsDate[0].question);
          final length=value.questions.length-1;
          for(var i=0;i<value.questions[length].questionsDate.length;i++){
             var questionModelItem=new questionModel(value.questions[length].questionsDate[i].question, value.questions[length].questionsDate[i].answer);
             listQuestion.add(questionModelItem);
          }
          // var date=DateTime.parse(value.questions[value.questions.length-1].dateTime);
          // displayNotification(date.add(Duration(hours: 24)));
        });
      });
    });
  }
  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    // tz.initializeTimeZones();
    // initilazeSetting();
    _postQuestion();
    _getUser();
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
      return RefreshIndicator(
        onRefresh: _refreshPage,
        child: WillPopScope(
          onWillPop:  ()async=>false,
          child: Scaffold(
            body: SafeArea(
              child: ListView(
                children: [
                  Container(
                    child: FutureBuilder<userModel>(
                      future: userInformation,
                      builder: (BuildContext context,AsyncSnapshot<userModel> snapshot){
                        if(snapshot.hasError) {
                          return Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        else if(snapshot.hasData) {
                          if(snapshot.data.questions.length==null){
                            return Container(
                                child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          else {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  FirstView(context, snapshot),
                                  SizedBox(height: 40.0,),
                                  questionsView(context, snapshot,
                                      snapshot.data.questions.length),
                                  SizedBox(height: 10.0,),
                                  numberQuestionsView(context),
                                  SizedBox(height: 20.0,),
                                  AnswerView(context, snapshot, snapshot.data.questions.length),

                                  BottomView(context),
                                ],
                              );
                          }
                        }
                        else{
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            child: Center(
                                child:CircularProgressIndicator()
                            ),
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items:[
                BottomNavigationBarItem(icon: Container( height:20,child: Image.asset("assets/icons/Vector.png",color: HexColor("#29BB89"))),label: ""),
                BottomNavigationBarItem(icon: Container( height:20,child: Image.asset("assets/icons/Vector2.png")),label:"")
              ],
              onTap: (int index)=>_navigatorToScreens(index),
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
    if(snapshot.hasData){
      return Container(
        padding: EdgeInsets.only(top: 20,left: 10,right: 20,bottom: 10),
        height: 70.0,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset:  Offset(0,0.2)
            )
          ],
          color: HexColor("#29BB89"),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 10.0),
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
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
                Text(snapshot.data.displayName,style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 17.0,
                        color: Colors.white
                    )
                ),)
              ],
            ),
            Text("Câu hỏi",style:GoogleFonts.roboto(
                textStyle: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                )
            )
            )
          ],
        ),
      );
    }
    else{
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

  }
  Widget questionsView(BuildContext context,AsyncSnapshot<userModel> snapshot,var lenght){
    if(snapshot.hasData){
      return Container(
        padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
        child: Container(
          height: 250.0,
          width: 370.0,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.amberAccent[200],
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                )
              ]
          ),
          child: Center(
            child: Text(
              listQuestion[dem].question,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 4,
              style: TextStyle(
                color: HexColor("#545151"),
                fontWeight: FontWeight.w700,
                fontSize: 21.0,
              ),
            ),
          ),
        ),
      );
    }
    else{
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

  }
  Widget numberQuestionsView(BuildContext context){
    return Container(
      padding: EdgeInsets.all(5),
      width: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: HexColor("#29BB89"),
          width: 1.0,
        )
      ),
      child: Center(
        child: Text(
          "${dem+1}/${listQuestion.length}",
          style: GoogleFonts.roboto(
            textStyle: TextStyle(
              color: HexColor("#29BB89")
            )
          ),
        ),
      ),
    );
  }
  Widget AnswerView(BuildContext context,AsyncSnapshot<userModel> snapshot,var lenght){
    if(snapshot.hasData){
      return Container(
        height: 120.0,
        padding:EdgeInsets.fromLTRB(40, 0, 40, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AnswerCard(context,snapshot,"Có",lenght),
            AnswerCard(context,snapshot, "Không",lenght),
          ],
        ),
      );
    }
    else{
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

  }
  Widget AnswerCard(BuildContext context,AsyncSnapshot<userModel> snapshot,String text,var length){
    final id=snapshot.data.questions[length-1].id;
    final question=snapshot.data.questions[length-1].questionsDate[dem].question;
    final answer=text;
    final index=(length-1).toString();
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50.0,
      child: OutlinedButton(
        onPressed: (){
            _phoneNumber.then((value) {
              answerNetwork().postAnswer(value, id, question, answer, index, dem.toString());
              setState(() {
                listQuestion[dem].answer=text;
                // userInformation=userNetwork().getUser(value);
              });
            });
        },
        style: OutlinedButton.styleFrom(
            backgroundColor:colorButtonAnswer(text, snapshot, length),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            side: BorderSide(
              color: HexColor("#29BB89"),
            )
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colorAnswer(text, snapshot, length),
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }
  Widget BottomView(BuildContext context){
    if(listQuestion.length<=1){
      return Container();
    }
    else{
      if(dem==0){
        return Column(
          children: [
            SizedBox(height: 10.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ButtonNext(context),
              ],
            ),
          ],
        );
      }
      else if(dem==4){
        return Column(
          children: [
            SizedBox(height: 10.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ButtonBack(context),
              ],
            ),
          ],
        );
      }
      else{
        return Column(
          children: [
            SizedBox(height: 10.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ButtonBack(context),
                ButtonNext(context),
              ],
            ),
          ],
        );
      }
    }
  }
  Widget ButtonBack(BuildContext context){
    return MaterialButton(
        color: HexColor("#29BB89"),
        textColor: Colors.white,
        child: Icon(
          Icons.arrow_back,
          size: 40,
        ),
        shape: CircleBorder(),
        onPressed: () {
        setState(() {
            if(dem>0 && dem<=4){
              setState(() {
                dem--;
              });
            }
        });
        }
    );
  }
  Widget ButtonNext(BuildContext context){
     return  MaterialButton(
         color: HexColor("#29BB89"),
         textColor: Colors.white,
         child: Icon(
           Icons.arrow_forward,
           size: 40,
         ),
         shape: CircleBorder(),
         onPressed: () {
             if(dem<4 &&dem>=0) {
               setState(() {
                 dem++;
               });
             }
         }
     );
  }
  void _navigatorToScreens(index){
       if(index==1){
        Navigator.push(context, MaterialPageRoute(
            builder: (context)=>userProfile()
        ));
      }
  }
  Future postAnswer(String phoneNumber,String id,String question,String answer,var index,var dem)=>
       answerNetwork().postAnswer(phoneNumber, id, question, answer, index, dem);
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
  // Future<void> displayNotification(DateTime dateTime){
  //   notificationFlugin.zonedSchedule(
  //       0,
  //       "Your questions is update",
  //       "Let's open the app",
  //       tz.TZDateTime.from(dateTime, tz.local),
  //       NotificationDetails(
  //         android: AndroidNotificationDetails(
  //             'channel id', 'channel name', 'channel description'),
  //       ),
  //       uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
  //       androidAllowWhileIdle: true);
  // }
  // void initilazeSetting() async{
  //   var initilizeAndroid=AndroidInitializationSettings("logo_green");
  //   var initilizeSetting=InitializationSettings(android: initilizeAndroid);
  //   await notificationFlugin.initialize(initilizeSetting,
  //   onSelectNotification: _onclickNotification);
  // }
  Future _refreshPage() async{
      await Future.delayed(Duration(milliseconds: 5000));
      _phoneNumber.then((value){
        setState(() {
          userInformation=userNetwork().getUser(value);
        });
      });
  }
  Future _onclickNotification(String payload) async{
    await Navigator.push(context, MaterialPageRoute(
         builder: (context)=>Question())
     );
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
