
import 'dart:async';
import 'dart:convert';

import 'package:binaslik/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../constants.dart';

class Register extends StatefulWidget {
  static String id='register';

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  int _state=0;
  var selectedName;
  List myData=[];

  DateTime currentdate=new DateTime.now();
  String? formatdate;

  Future getDepart() async {
    var url = Uri.parse('http://192.168.43.66/binaslik/display_depart.php');
    var response = await http.get(url);
    var jsonBody=response.body;
    var data=json.decode(jsonBody);
    setState(() {
      myData=data;
    });
    return data;
  }

  TextEditingController name        = new TextEditingController();
  TextEditingController phone       = new TextEditingController();
  TextEditingController password    = new TextEditingController();
  TextEditingController nationality = new TextEditingController();
  TextEditingController address     = new TextEditingController();
  TextEditingController about       = new TextEditingController();

  Future register() async{
    var url = Uri.parse('http://192.168.43.66/binaslik/register.php');
    var response=await http.post(url, body: {
      "name"        : name.text.trim(),
      "phone"       : phone.text.trim(),
      "password"    : password.text.trim(),
      "nationality" : nationality.text.trim(),
      "address"     : address.text.trim(),
      "about"       : about.text.trim(),
      "depart"      : selectedName,
      "date"        : formatdate
    });
    //json.decode(response.body);
    if(response.body.isNotEmpty) {
      json.decode(response.body);
    }
  }

  bool _validate = false;
  bool _secureText = true;
  void showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  String? _errorMessage(String hint) {
    if(hint=="الأسم"){
      return 'الرجاء ادخال الأسم';
    }else if(hint=="رقم الهاتف"){
      return 'الرجاء ادخال رقم الهاتف';
    }else if(hint=="كلمه المرور"){
      return 'الرجاء ادخال كلمه المرور';
    }else if(hint=="الرقم الوطني"){
      return 'الرجاء ادخال الرقم الوطني';
    }else if(hint=="العنوان"){
      return 'الرجاء ادخال العنوان';
    }else if(hint=="نبذه عني"){
      return 'الرجاء ادخال النبذه';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDepart();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    formatdate=new DateFormat('yyyy.MM.dd hh:mm:ss aaa').format(currentdate);
    return Form(
      key: _globalKey,
      child: SafeArea(
        child: WillPopScope(
          onWillPop:(){
            Navigator.popAndPushNamed(context, Login.id);
            return Future.value(false);
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: kMainColor,
              elevation: 0,
              title: Text(
                'انشاء حساب',
                style: GoogleFonts.cairo(
                  textStyle: TextStyle(
                      color: Colors.white
                  ),
                ),
              ),
              leading: GestureDetector(
                onTap: () {
                  //Navigator.pushNamed(context, Home.id);
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                child: Column(
                  children: [
                    SizedBox(
                      height: height * .05,
                    ),
                    TextFormField(
                      validator:(value) {
                        if (value!.isEmpty) {
                          return _errorMessage("الأسم");
                          // ignore: missing_return
                        }
                      },
                      controller: name,
                      decoration: InputDecoration(
                          icon: Icon(Icons.person,color: kMainColor,),
                          hintStyle: TextStyle(color: Colors.blue),
                          hintText: "الأسم"
                      ),
                    ),
                    SizedBox(height: 5,),
                    TextFormField(
                      validator:(value) {
                        if (value!.isEmpty) {
                          return _errorMessage("رقم الهاتف");
                          // ignore: missing_return
                        }
                      },
                      controller: phone,
                      keyboardType:TextInputType.phone,
                      decoration: InputDecoration(
                          icon: Icon(Icons.phone,color: kMainColor,),
                          hintStyle: TextStyle(color: Colors.blue),
                          hintText: "رقم الهاتف"
                      ),
                    ),
                    SizedBox(height: 5,),
                    TextFormField(
                      validator:(value) {
                        if (value!.isEmpty) {
                          return _errorMessage("كلمه المرور");
                          // ignore: missing_return
                        }
                      },
                      controller: password,
                      obscureText: _secureText,
                      decoration: InputDecoration(
                          icon: Icon(Icons.lock,color: kMainColor,),
                          suffixIcon: IconButton(
                            onPressed: showHide,
                            icon: Icon(_secureText
                                ? Icons.visibility_off
                                : Icons.visibility),
                          ),
                          hintStyle: TextStyle(color: Colors.blue),
                          hintText: "كلمه المرور"
                      ),
                    ),
                    SizedBox(height: 5,),
                    TextFormField(
                      validator:(value) {
                        if (value!.isEmpty) {
                          return _errorMessage("الرقم الوطني");
                          // ignore: missing_return
                        }
                      },
                      controller: nationality,
                      keyboardType:TextInputType.number,
                      decoration: InputDecoration(
                          icon: Icon(Icons.info,color: kMainColor,),
                          hintStyle: TextStyle(color: Colors.blue),
                          hintText: "الرقم الوطني"
                      ),
                    ),
                    SizedBox(height: 5,),
                    TextFormField(
                      validator:(value) {
                        if (value!.isEmpty) {
                          return _errorMessage("العنوان");
                          // ignore: missing_return
                        }
                      },
                      controller: address,
                      decoration: InputDecoration(
                          icon: Icon(Icons.info,color: kMainColor,),
                          hintStyle: TextStyle(color: Colors.blue),
                          hintText: "العنوان"
                      ),
                    ),
                    SizedBox(height: 5,),
                    TextFormField(
                      validator:(value) {
                        if (value!.isEmpty) {
                          return _errorMessage("نبذه عني");
                          // ignore: missing_return
                        }
                      },
                      controller: about,
                      decoration: InputDecoration(
                          icon: Icon(Icons.info,color: kMainColor,),
                          hintStyle: TextStyle(color: Colors.blue),
                          hintText: "نبذه عني"
                      ),
                    ),
                    SizedBox(height: 5,),
                    DropdownButtonHideUnderline(
                      child: DropdownButton(
                        value: selectedName,
                        hint: Text('اختر القسم'),
                        items: myData.map(( map){
                          return DropdownMenuItem(
                            child: Text(map['dep_name']),
                            value: map['dep_name'],
                          );
                        }).toList(),
                        onChanged:(value){
                          setState(() {
                            selectedName=value;
                          });
                        },
                      ),
                    ),
                    SizedBox(height: 5,),
                    Padding(
                      padding: const EdgeInsets.only(left: 15,right: 15,bottom: 8,top: 8),
                      child: Builder(
                        builder: (context) => ElevatedButton(
                          onPressed: () {
                            if (_state == 0) {
                              animateButton();
                            }

                            if (_globalKey.currentState!.validate()){
                              _globalKey.currentState!.save();
                              try{
                                register();
                                Fluttertoast.showToast(
                                    msg: "تم الحفظ بنجاح",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: kMainColor,
                                    textColor: Colors.white,
                                    fontSize: 16.0
                                );
                                Navigator.popAndPushNamed(context, Login.id);
                              }on PlatformException catch(e){

                              }
                            }else{
                              setState(() {
                                _state = 0;
                              });
                            }
                          },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kMainColor,
                            ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20,right: 20,bottom: 5,top: 5),
                            child: Center(
                                child:setUpButtonChild()
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 5,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.popAndPushNamed(context, Login.id);
                          },
                          child: Text(
                            'تسجيل دخول   ',
                            style: GoogleFonts.cairo(
                              textStyle: TextStyle(
                                fontSize: 16,
                                color: kMainColor,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          'لديك حساب ؟',
                          style: GoogleFonts.cairo(
                            textStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget? setUpButtonChild() {
    if (_state == 0) {
      return new Text(
        "أنشاء الحساب",
        style: GoogleFonts.cairo(
          textStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    } else if (_state == 1) {
      return CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      );
    }
  }

  void animateButton() {
    setState(() {
      _state = 1;
    });

    Timer(Duration(milliseconds: 3300), () {
      setState(() {
        _state = 0;
      });
    });
  }
}
