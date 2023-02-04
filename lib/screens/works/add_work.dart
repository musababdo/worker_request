
import 'dart:convert';
import 'dart:io';

import 'package:binaslik/constants.dart';
import 'package:binaslik/screens/works/display_works.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class AddWork extends StatefulWidget {
  static String id='addwork';

  @override
  State<AddWork> createState() => _AddWorkState();
}

class _AddWorkState extends State<AddWork> {

  final ImagePicker _picker = ImagePicker();
  File? _image;
  String? nationality;

  DateTime currentdate=new DateTime.now();
  String? formatdate;

  Future saveWork() async{
    try{
      List<int> imageBytes = _image!.readAsBytesSync();
      String baseimage = base64Encode(imageBytes);
      var url = Uri.parse('http://192.168.43.66/binaslik/save_work.php');
      var response=await http.post(url, body: {
        "image" : baseimage,
        "n_id"  : nationality,
        "date"  : formatdate
      });
      json.decode(response.body);
    }catch(e){

    }
  }

  late SharedPreferences preferences;
  Future getNationality() async{
    preferences = await SharedPreferences.getInstance();
    setState(() {
      nationality = preferences.getString("nationality");
      print(nationality);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNationality();
  }

  @override
  Widget build(BuildContext context) {
    formatdate=new DateFormat('yyyy.MM.dd hh:mm:ss aaa').format(currentdate);
    final double screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: WillPopScope(
        onWillPop:(){
          Navigator.popAndPushNamed(context, DisplayWork.id);
          return Future.value(false);
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: kMainColor,
            elevation: 0,
            title: Text(
              'أضافه عمل',
              style: GoogleFonts.cairo(
                textStyle: TextStyle(
                    color: Colors.white
                ),
              ),
            ),
            leading: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, DisplayWork.id);
                //Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(right: 10,left: 10),
              child: Column(
                children: [
                  SizedBox(
                    height:screenHeight * .07,
                  ),
                  GestureDetector(
                    onTap:(){
                      _optionsDialogBox();
                    },
                    child: _image == null
                        ? new Stack(
                      children: <Widget>[
                        new Center(
                          child: new CircleAvatar(
                            radius: 80.0,
                            backgroundColor: kMainColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 45),
                          child: new Center(
                            child: new Image.asset("images/camera.png"),
                          ),
                        ),

                      ],
                    ): new Container(
                        height: 190.0,
                        width: 190.0,
                        child:Image.file(_image!)
                    ),
                  ),
                  SizedBox(
                    height:screenHeight * .03,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      saveWork();
                      Fluttertoast.showToast(
                          msg: "تمت الأضافه بنجاح",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                      Navigator.pushNamed(context, DisplayWork.id);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kMainColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20,right: 20,bottom: 5,top: 5),
                      child: Center(
                          child:Text(
                            "حفظ",
                            style: GoogleFonts.cairo(
                              textStyle: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Future<void> _optionsDialogBox() {
    return showDialog(context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Row(
                      children: <Widget>[
                        new Icon(Icons.camera_alt),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                        ),
                        new Text('ألتقط صوره')
                      ],
                    ),
                    onTap: openCamera,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: Row(
                      children: <Widget>[
                        new Icon(Icons.camera),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                        ),
                        new Text('أختر من الصور الموجوده')
                      ],
                    ),
                    onTap: openGallery,
                  ),
                ],
              ),
            ),
          );
        });
  }
  void openGallery()async{
    PickedFile? gallery = await _picker.getImage(source: ImageSource.gallery);
    final File file_gallery = File(gallery!.path);
    setState(() {
      Navigator.pop(context);
      _image=file_gallery;
    });
  }
  void openCamera()async{
    PickedFile? camera = await _picker.getImage(source: ImageSource.camera);
    final File file_camera = File(camera!.path);
    setState(() {
      Navigator.pop(context);
      _image=file_camera;
    });
  }
}
