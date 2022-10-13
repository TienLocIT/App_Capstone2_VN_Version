// // @dart=2.9
// import 'package:animated_text_kit/animated_text_kit.dart';
// import 'package:flutter/material.dart';
// import 'package:connectivity/connectivity.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:green_big_5/Network/defindQuestionNetwork.dart';
// import 'package:green_big_5/Network/userNetwork.dart';
// import 'package:green_big_5/pages/Question.dart';
// import 'package:green_big_5/utill/UserSecureStorage.dart';
// import 'package:hexcolor/hexcolor.dart';
// import 'package:green_big_5/model/userModel.dart';
// class DefineQuestionPage extends StatefulWidget {
//   const DefineQuestionPage({Key key}) : super(key: key);
//   @override
//   _DefineQuestionPageState createState() => _DefineQuestionPageState();
// }
//
// class _DefineQuestionPageState extends State<DefineQuestionPage> {
//   String answer="";
//   bool thankYou=false;
//   int length;
//   Future<userModel> userInformation;
//   final _phoneNumber=UserSecureStorage.getUserValue();
//   Color colorButtonAnswer(String text){
//     if(answer==text){
//       return HexColor("#29BB89");
//     }
//     return Colors.white;
//     // if(snapshot.data.user.questions[length-1].questionsDate[dem].answer==text){
//     //     return HexColor("#29BB89");
//     // }
//     // return Colors.white;
//   }
//   Color colorAnswer(String text){
//     if(answer==text){
//       return Colors.white;
//     }
//     return HexColor("#29BB89");
//     // if(snapshot.data.user.questions[length-1].questionsDate[dem].answer==text){
//     //   return Colors.white;
//     // }
//     // return HexColor("#29BB89");
//   }
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     userInformation=userNetwork().getUser("0889192932");
//     userInformation.then((value){
//         length=value.defindQuestion.length-1;
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//         child: Scaffold(
//           body: SafeArea(
//             child: ListView(
//               children: [
//                   Container(
//                     width: MediaQuery.of(context).size.width,
//                     height: MediaQuery.of(context).size.height,
//                     child:FutureBuilder<userModel>(
//                       future: userInformation,
//                       builder: (BuildContext context,AsyncSnapshot<userModel> snapshot){
//                         if(snapshot.hasData){
//                           if(thankYou==false){
//                             return Column(
//                               children: [
//                                 firstView(snapshot),
//                                 SizedBox(height: 40.0,),
//                                 questionView(snapshot),
//                               ],
//                             );
//                           }
//                           else{
//                             return Stack(
//                               children: [
//                                 Column(
//                                   children: [
//                                     firstView(snapshot),
//                                     SizedBox(height: 40.0,),
//                                     questionView(snapshot),
//                                   ],
//                                 ),
//                                 Container(
//                                   decoration: BoxDecoration(
//                                     color: Colors.black.withOpacity(0.3)
//                                   ),
//                                   child: Center(
//                                     child: Column(
//                                       crossAxisAlignment:CrossAxisAlignment.center,
//                                       mainAxisAlignment:MainAxisAlignment.center,
//                                       children: [
//                                         DefaultTextStyle(
//                                           style:const TextStyle(
//                                                         fontSize: 18.0,
//                                                         fontWeight: FontWeight.bold,
//                                                         color: Colors.white
//                                            ),
//                                           child: AnimatedTextKit(
//                                             isRepeatingAnimation: true,
//                                             animatedTexts: [
//                                                 TyperAnimatedText("Thank you for answer question",speed: Duration(microseconds: 100000))
//                                             ],
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 )
//                               ],
//                             );
//                           }
//
//                         }
//                         else{
//                           return Center(
//                             child: CircularProgressIndicator(),
//                           );
//                         }
//                       },
//                     ),
//                   )
//               ],
//             ),
//           ),
//         ), onWillPop: ()async=>false);
//   }
//   Widget firstView(AsyncSnapshot<userModel> snapshot){
//       if(snapshot.hasData){
//         return Container(
//           padding: EdgeInsets.only(top: 20,left: 10,right: 20,bottom: 10),
//           height: 70.0,
//           width: MediaQuery.of(context).size.width,
//           decoration: BoxDecoration(
//             boxShadow: [
//               BoxShadow(
//                   color: Colors.grey.withOpacity(0.5),
//                   spreadRadius: 5,
//                   blurRadius: 7,
//                   offset:  Offset(0,0.2)
//               )
//             ],
//             color: HexColor("#29BB89"),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   Container(
//                     margin: EdgeInsets.only(right: 10.0),
//                     width: 40.0,
//                     height: 40.0,
//                     decoration: BoxDecoration(
//                         image: DecorationImage(
//                           image: AssetImage("assets/image/user.png"),
//                           fit: BoxFit.cover,
//                         ),
//                         borderRadius: BorderRadius.circular(150.0),
//                         border: Border.all(
//                           color: Colors.white,
//                           width: 5.0,
//                         )
//                     ),
//                   ),
//                   Text(snapshot.data.displayName,style: GoogleFonts.roboto(
//                       textStyle: TextStyle(
//                           fontWeight: FontWeight.w700,
//                           fontSize: 17.0,
//                           color: Colors.white
//                       )
//                   ),)
//                 ],
//               ),
//               Text("Quizz",style:GoogleFonts.roboto(
//                   textStyle: TextStyle(
//                     fontSize: 14.0,
//                     fontWeight: FontWeight.w500,
//                     color: Colors.white,
//                   )
//               )
//               )
//             ],
//           ),
//         );
//       }
//       else{
//         return Container(
//           child: Center(
//             child: CircularProgressIndicator(),
//           ),
//         );
//       }
//   }
//   Widget questionView(AsyncSnapshot<userModel> snapshot){
//     final id=snapshot.data.defindQuestion[length].id;
//     final phoneNumber=snapshot.data.phoneNumber;
//     final questionDefind=snapshot.data.defindQuestion[length].question;
//         return Container(
//           child: Column(
//               children: [
//                 question(snapshot),
//                 SizedBox(height: 30.0,),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     option(id, questionDefind, phoneNumber,"Yes",100.0),
//                     SizedBox(width: 20.0,),
//                     option(id, questionDefind, phoneNumber,"No",100.0)
//                   ],
//                 ),
//                 SizedBox(height: 30.0,),
//                 option(id,questionDefind,phoneNumber,"Skip",250.0)
//               ],
//           ),
//         );
//   }
//   Widget question(AsyncSnapshot<userModel> snapshot){
//     return Container(
//       padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
//       child: Container(
//         height: 250.0,
//         width: 370.0,
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//             color: Colors.amberAccent[200],
//             borderRadius: BorderRadius.circular(8.0),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.5),
//                 spreadRadius: 5,
//                 blurRadius: 7,
//                 offset: Offset(0, 3),
//               )
//             ]
//         ),
//         child: Center(
//           child: Text(
//             snapshot.data.defindQuestion[length].question,
//             textAlign: TextAlign.center,
//             overflow: TextOverflow.ellipsis,
//             maxLines: 4,
//             style: TextStyle(
//               color: HexColor("#545151"),
//               fontWeight: FontWeight.w700,
//               fontSize: 21.0,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//   Widget option(final id,final question,final phoneNumber,final text,final width){
//     return Container(
//       width: width,
//       height: 50.0,
//       child: OutlinedButton(
//         onPressed: ()async{
//           if(text=="skip"){
//             _phoneNumber.then((value){
//               defindQuestionNetwork().postAnswer(id, value,"none", length, question);
//             });
//             Navigator.push(context,MaterialPageRoute(builder: (context)=>Question()));
//           }
//           else {
//             _phoneNumber.then((value) {
//               defindQuestionNetwork().postAnswer(
//                   id, value, text, length, question);
//             });
//             setState(() {
//               thankYou=true;
//               answer=text;
//             });
//             await Future.delayed(const Duration(seconds: 5),(){});
//             Navigator.push(context,MaterialPageRoute(builder: (context)=>Question()));
//           }
//         },
//         style: OutlinedButton.styleFrom(
//             backgroundColor:colorButtonAnswer(text),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8.0),
//             ),
//             side: BorderSide(
//               color: HexColor("#29BB89"),
//             )
//         ),
//         child: Text(
//           text,
//           textAlign: TextAlign.center,
//           overflow: TextOverflow.ellipsis,
//           maxLines: 2,
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: colorAnswer(text),
//             fontSize: 20.0,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
