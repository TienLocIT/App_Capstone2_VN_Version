// // @dart=2.9
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:green_big_5/Network/defindQuestionNetwork.dart';
// import 'package:green_big_5/Network/userNetwork.dart';
// import 'package:green_big_5/model/userModel.dart';
// import 'package:green_big_5/utill/UserSecureStorage.dart';
// import 'package:hexcolor/hexcolor.dart';
//
// import 'Question.dart';
// import 'defindQuestion.dart';
// class defindQuestionStart extends StatefulWidget {
//   const defindQuestionStart({Key key}) : super(key: key);
//
//   @override
//   _defindQuestionStartState createState() => _defindQuestionStartState();
// }
//
// class _defindQuestionStartState extends State<defindQuestionStart> {
//   Future<userModel> userInformation;
//   final _phoneNumber=UserSecureStorage.getUserValue();
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _phoneNumber.then((value){
//       userInformation=userNetwork().getUser(value);
//     });
//
//   }
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: ()async=>false,
//       child: SafeArea(
//         child: Scaffold(
//           body: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Container(
//                 child: Image(image: AssetImage("assets/image/logo_green.png"),),
//               ),
//               textWidget("Surprise!!!!",50),
//               SizedBox(
//                 height: 45.0,
//               ),
//               textWidget("You have a new question!!!",25),
//               SizedBox(height: 25.0,),
//               textWidget("Do you want answer the question?",23),
//               SizedBox(height: 25.0,),
//               yesnoView(context)
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//   Widget textWidget(String text,double fontSize){
//     return Container(
//       child: Text(text,textAlign:TextAlign.center,style: TextStyle(
//         fontSize: fontSize,
//         fontWeight:FontWeight.w700,
//         color: HexColor("#29BB89"),
//       ),),
//     );
//   }
//   Widget yesnoView(BuildContext context){
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Container(
//           height: 50.0,
//           width: 100.0,
//           child: ElevatedButton(onPressed: () {
//             Navigator.push(context, MaterialPageRoute(builder: (context)=>DefineQuestionPage()));
//           },
//             style: ButtonStyle(
//                 backgroundColor: MaterialStateProperty.all<Color>(HexColor("#2FBB89"))
//             ),
//             child: Text("Yes",style: GoogleFonts.roboto(
//                 textStyle: TextStyle(
//                     fontSize: 18.0,
//                     color: Colors.white
//                 )
//             )),),
//         ),
//         SizedBox(width: 20.0,),
//         Container(
//           height: 50.0,
//           width: 100.0,
//           child: ElevatedButton(onPressed: () {
//             userInformation.then((value){
//               defindQuestionNetwork().postAnswer(
//                   value.defindQuestion[value.defindQuestion.length-1].id,
//                   value.phoneNumber, "none",value.defindQuestion.length-1 ,value.defindQuestion[value.defindQuestion.length-1].question);
//             });
//             Navigator.push(context,MaterialPageRoute(builder: (context)=>Question()));
//           },
//             style: ButtonStyle(
//                 backgroundColor: MaterialStateProperty.all<Color>(HexColor("#2FBB89"))
//             ),
//             child: Text("No",style: GoogleFonts.roboto(
//                 textStyle: TextStyle(
//                     fontSize: 18.0,
//                     color: Colors.white
//                 )
//             )),),
//         ),
//       ],
//     );
//   }
// }