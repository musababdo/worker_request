
import 'dart:convert';

import 'package:binaslik/constants.dart';
import 'package:binaslik/screens/details.dart';
import 'package:binaslik/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class People extends StatefulWidget {
  static String id='people';

  @override
  State<People> createState() => _PeopleState();
}

class _PeopleState extends State<People> {

  String? depart;

  late SharedPreferences preferences;
  Future getPeople() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      //print(preferences.getString("id"));
    });
    var url = Uri.parse('http://192.168.43.66/binaslik/display_people.php');
    var response = await http.post(url, body: {
      "depart": preferences.getString("depart"),
    });
    var data = json.decode(response.body);
    return data;
  }

  getDepart() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      depart = preferences.getString("depart");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDepart();
    getPeople();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double appBarHeight = AppBar().preferredSize.height;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return WillPopScope(
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
              depart!,
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
          body: FutureBuilder(
            future: getPeople(),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              try {
                if(snapshot.data.length > 0 ){
                  return snapshot.hasData ?
                  ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        List list = snapshot.data;
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: screenHeight * .18,
                            child: GestureDetector(
                              onTap:(){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Details(list: list,index: index,),),);
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)
                                ),
                                elevation: 8,
                                child:Row(
                                  //mainAxisAlignment:MainAxisAlignment.start ,
                                  children: <Widget>[
                                    ClipRRect(
                                      borderRadius: new BorderRadius.only(
                                        topLeft: const Radius.circular(20),
                                        bottomLeft: const Radius.circular(20),
                                      ),
                                      child:FadeInImage.assetNetwork(
                                        image: list[index]['images'],
                                        placeholder: 'images/loader.gif',
                                        height: MediaQuery.of(context).size.height * 0.4,
                                        width: MediaQuery.of(context).size.width * 0.4,
                                        imageErrorBuilder: (context, error, stackTrace) {
                                          return Image.asset('images/loader.gif',
                                              width: MediaQuery.of(context).size.width / 3,
                                              fit: BoxFit.contain);
                                        },
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Padding(padding: const EdgeInsets.only(left:10)),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Text(
                                        list[index]['name'],
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      })
                      : new Center(
                    child: new CircularProgressIndicator(),
                  );
                }else{
                  return Container(
                    height: screenHeight -
                        (screenHeight * .08) -
                        appBarHeight -
                        statusBarHeight,
                    child: Center(
                      child: Text('لايوجد',
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      ),
                    ),
                  );
                }
              }catch(e){
                return new Center(
                  child: new CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
