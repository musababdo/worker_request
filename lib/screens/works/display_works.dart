
import 'dart:convert';

import 'package:binaslik/constants.dart';
import 'package:binaslik/screens/home.dart';
import 'package:binaslik/screens/works/add_work.dart';
import 'package:binaslik/screens/works/edit_work.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DisplayWork extends StatefulWidget {
  static String id='displaywork';

  @override
  State<DisplayWork> createState() => _DisplayWorkState();
}

class _DisplayWorkState extends State<DisplayWork> {

  late SharedPreferences preferences;
  Future getMyWork() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      // print("///////////////////////");
      // print(preferences.getString("nationality"));
      // print("///////////////////////");
    });
    var url = Uri.parse('http://192.168.43.66/binaslik/display_mywork.php');
    var response = await http.post(url, body: {
      "nationality": preferences.getString("nationality"),
    });
    var data = json.decode(response.body);
    return data;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMyWork();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double appBarHeight = AppBar().preferredSize.height;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return SafeArea(
      child: WillPopScope(
        onWillPop:(){
          Navigator.popAndPushNamed(context, Home.id);
          return Future.value(false);
        },
        child: Scaffold(
          floatingActionButton: new FloatingActionButton(
            onPressed:(){
              Navigator.pushNamed(context, AddWork.id);
            } ,
            child: new Icon(Icons.add,color: Colors.white,),
            backgroundColor: kMainColor,
          ),
          appBar: AppBar(
            backgroundColor: kMainColor,
            elevation: 0,
            title: Text(
              'اعمالي',
              style: GoogleFonts.cairo(
                textStyle: TextStyle(
                    color: Colors.white
                ),
              ),
            ),
            leading: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, Home.id);
                //Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
          body: FutureBuilder(
            future: getMyWork(),
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
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              elevation: 8,
                              child:Row(
                                mainAxisAlignment:MainAxisAlignment.end ,
                                children: <Widget>[
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(right:20),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => EditWork(list: list,index: index,),),);
                                              },
                                              child: Icon(
                                                Icons.edit,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              showDialog(context: context,
                                                  builder: (context){
                                                    return AlertDialog(
                                                      content: Text('هل انت متأكد من انك تريد مسح هذا العقار'),
                                                      actions: <Widget>[
                                                        ElevatedButton(
                                                            onPressed: (){
                                                              Navigator.of(context).pop();
                                                            },
                                                            child: Text("لا")
                                                        ),
                                                        ElevatedButton(
                                                            onPressed: (){
                                                              setState(() {
                                                                var url = Uri.parse('http://192.168.43.66/binaslik/delete_work.php');
                                                                http.post(url,body: {
                                                                  'id' : list[index]['id'],
                                                                });
                                                                Navigator.of(context).pop();
                                                              });
                                                            },
                                                            child: Text("نعم")
                                                        ),
                                                      ],
                                                    );
                                                  }
                                              );
                                            },
                                            child: Icon(
                                              Icons.delete,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Padding(padding: const EdgeInsets.only(right:15)),
                                  ClipRRect(
                                    borderRadius: new BorderRadius.only(
                                      topRight: const Radius.circular(20),
                                      bottomRight: const Radius.circular(20),
                                    ),
                                    child:FadeInImage.assetNetwork(
                                      image: list[index]['images'],
                                      placeholder: 'images/loader.gif',
                                      width: MediaQuery.of(context).size.width / 3,
                                      imageErrorBuilder: (context, error, stackTrace) {
                                        return Image.asset('images/loader.gif',
                                            width: MediaQuery.of(context).size.width / 3,
                                            fit: BoxFit.contain);
                                      },
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  //Padding(padding: const EdgeInsets.only(right:15)),
                                ],
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
                            fontSize: 30
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
  placeImage(){
    return Image.asset("images/place.png",
      height: MediaQuery.of(context).size.height * 0.4,
      fit: BoxFit.contain,
    );
  }
}
