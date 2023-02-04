import 'package:binaslik/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:binaslik/screens/profile/body.dart';
import 'package:binaslik/screens/home.dart';

class ProfileScreen extends StatelessWidget {
  static String id = "profile";
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:(){
        Navigator.pushNamed(context, Home.id);
        return Future.value(false);
      },
      child: WillPopScope(
        onWillPop:(){
          Navigator.popAndPushNamed(context, Home.id);
          return Future.value(false);
        },
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: kMainColor,
              elevation: 0,
              title: Text(
                'الصفحه الشخصيه',
                style: GoogleFonts.cairo(
                  textStyle: TextStyle(
                      color: Colors.white
                  ),
                ),
              ),
              leading: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, Home.id);
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
            ),
            body: Body(),
          ),
        ),
      ),
    );
  }
}
