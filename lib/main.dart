
import 'package:binaslik/screens/home.dart';
import 'package:binaslik/screens/login.dart';
import 'package:binaslik/screens/people.dart';
import 'package:binaslik/screens/profile/profile_screen.dart';
import 'package:binaslik/screens/register.dart';
import 'package:binaslik/screens/spalshscreen.dart';
import 'package:binaslik/screens/works/add_work.dart';
import 'package:binaslik/screens/works/display_works.dart';
import 'package:binaslik/screens/works/edit_work.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        Login.id: (context) => Login(),
        Register.id: (context) => Register(),
        Home.id: (context) => Home(),
        DisplayWork.id: (context) => DisplayWork(),
        AddWork.id: (context) => AddWork(),
        ProfileScreen.id: (context) => ProfileScreen(),
        People.id: (context) => People(),
      },
    );
  }
}
