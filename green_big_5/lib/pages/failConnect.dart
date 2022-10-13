// ignore: file_names
// @dart=2.9
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
class failConnect extends StatefulWidget {
  const failConnect({Key key}) : super(key: key);

  @override
  _failConnectState createState() => _failConnectState();
}

class _failConnectState extends State<failConnect> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 50),
              child: Lottie.asset("assets/animation/69023-world-map-blue.json"),
            ),
            Text("Oops",style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.w700,
                    color: HexColor("#000000")
                )
            ),
            SizedBox(height: 16,),
              Text("Kết nối thất bại",style:  TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: HexColor("#C4C4C4")
                )
            ,),
            SizedBox(height: 150,),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(left: 10,right: 10),
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
                  setState(() {

                  });
                },
                child: Text(
                  "Làm mới",
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
          ],
        ),
      ),
    );
  }
}
