
import 'dart:convert';

import 'package:binaslik/constants.dart';
import 'package:binaslik/models/search.dart';
import 'package:binaslik/screens/login.dart';
import 'package:binaslik/screens/people.dart';
import 'package:binaslik/screens/profile/profile_screen.dart';
import 'package:binaslik/screens/works/display_works.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  static String id='home';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String? name,phone;
  int? value;

  var selectedName;
  List myData=[];

  List<Search> _list = [];
  List<Search> _search = [];
  var loading = false;

  Future getAllWork() async{
    setState(() {
      loading = true;
    });
    var url = Uri.parse('http://192.168.43.66/binaslik/display_all_work.php');
    var response = await http.get(url);
    var data= json.decode(response.body);
    setState(() {
      for (Map i in data) {
        _list.add(Search.formJson(i));
        loading = false;
      }
    });
  }

  TextEditingController controller = new TextEditingController();

  onSearch(String text) async {
    _search.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _list.forEach((f) {
      if (f.depart.contains(text) || f.id.toString().contains(text))
        _search.add(f);
    });

    setState(() {});
  }

  late SharedPreferences mpreferences;
  getData() async{
    mpreferences = await SharedPreferences.getInstance();
    setState(() {
      name  = mpreferences.getString("name");
      phone = mpreferences.getString("phone");
    });
  }

  Future getProfile() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value") ;
      if ((preferences.getInt("value") == 1)) {
        //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => confirmnow()));
        Navigator.pushNamed(context, ProfileScreen.id);
      }else{
        myDialog();
      }
    });
  }

  Future getMyWork() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value") ;
      if ((preferences.getInt("value") == 1)) {
        //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => confirmnow()));
        Navigator.pushNamed(context, DisplayWork.id);
      }else{
        myDialog();
      }
    });
  }

  myDialog(){
    showModalBottomSheet(context: context, builder: (context){
      return WillPopScope(
        onWillPop:(){
          Navigator.pop(context);
          return Future.value(false);
        },
        child: SafeArea(
            child: Container(
              color: Color(0xFF737373),
              height: 180,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Text("تنبيه",style: GoogleFonts.cairo(
                      textStyle: TextStyle(
                        fontSize: 22,
                      ),
                    ),),
                    const SizedBox(height:8),
                    Text('ليس لديك حساب قم بعمل حساب الأن ',style: GoogleFonts.cairo(
                      textStyle: TextStyle(
                        fontSize: 18,
                      ),
                    ),),
                    const SizedBox(height:10),
                    Padding(
                      padding: const EdgeInsets.only(left: 25,right: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          MaterialButton(
                            onPressed: () {
                              setState(() {
                                Navigator.of(context).pop();
                              });
                            },
                            child: Text('الغاء',
                              style: GoogleFonts.cairo(
                                textStyle: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () {
                              setState(() {
                                Navigator.pushNamed(context, Login.id).then((_){
                                  Navigator.of(context).pop();
                                });
                              });
                            },
                            child: Text('موافق',
                              style: GoogleFonts.cairo(
                                textStyle: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
        ),
      );
    });
  }

  late SharedPreferences pref;
  saveDepart(String depart) async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      pref.setString("depart", depart);
    });
  }

  Future<void> signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.remove("nationality");
      preferences.remove("name");
      preferences.remove("phone");
      preferences.remove("value");
      preferences.clear();
      Fluttertoast.showToast(
          msg: "تم تسجيل الخروج",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
      );
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    getAllWork();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double appBarHeight = AppBar().preferredSize.height;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return SafeArea(
      child: WillPopScope(
        onWillPop:(){
          SystemNavigator.pop();
          return Future.value(false);
        },
        child: Scaffold(
          drawer: new Drawer(
            child: ListView(
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                      color: kMainColor,
                    ),
                    accountName: Text(name !=null?name!:"Your name here",style: TextStyle(color:Colors.white,fontSize: 20),),
                    accountEmail: Text(phone !=null?phone!:"Your phone here",style: TextStyle(color:Colors.white,fontSize: 20),),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    color: Colors.white,
                    child: Column(children: <Widget>[
                      ListTile(
                        dense: true,
                        title: Text("الملف الشخصي", style: TextStyle(color: Colors.black),),
                        leading: Icon(Icons.person),
                        onTap: (){
                          Navigator.pop(context);
                          getProfile();
                        },
                      ),
                      ListTile(
                        dense: true,
                        title: Text("اعمالي", style: TextStyle(color: Colors.black),),
                        leading: Icon(Icons.calendar_month),
                        onTap: (){
                          Navigator.pop(context);
                          getMyWork();
                        },
                      ),
                      ListTile(
                        dense: true,
                        title: Text("تسجيل خروج", style: TextStyle(color: Colors.black),),
                        leading: Icon(Icons.logout),
                        onTap: (){
                          Navigator.pop(context);
                          signOut();
                        },
                      ),

                    ],),
                  ),
                ]
            ),
          ),
          appBar: AppBar(
            backgroundColor: kMainColor,
            elevation: 0,
            title: Text(
              'الرئيسيه',
              style: GoogleFonts.cairo(
                textStyle: TextStyle(
                    color: Colors.white
                ),
              ),
            ),
          ),
          body: Container(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: Card(
                    child: ListTile(
                      leading: Icon(Icons.search),
                      title: TextField(
                        controller: controller,
                        onChanged: onSearch,
                        decoration: InputDecoration(
                            hintText: "بحث عن قسم", border: InputBorder.none),),
                      trailing: IconButton(
                        onPressed: () {
                          controller.clear();
                          onSearch('');
                        },
                        icon: Icon(Icons.cancel),
                      ),
                    ),
                  ),
                ),
                loading
                    ? Center(
                  child: CircularProgressIndicator(),
                )
                    : Expanded(
                  child: _search.length != 0 || controller.text.isNotEmpty
                      ? ListView.builder(
                    itemCount: _search.length,
                    itemBuilder: (context, i) {
                      final b = _search[i];
                      List list = _search;
                      return Padding(
                        padding: EdgeInsets.fromLTRB(7, 5, 7, 0),
                        child: GestureDetector(
                          onTap:(){
                            //Navigator.push(context, MaterialPageRoute(builder: (context) => Details(list: list,index: index,),),);
                            Navigator.pushNamed(context, People.id);
                            saveDepart(b.depart);
                          },
                          child: new Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)
                            ),
                            elevation: 9,
                            color: Colors.white,
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                height: MediaQuery.of(context).size.height * .1,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10,top: 10,bottom: 10),
                                  child: Text(
                                    b.depart,
                                    style: GoogleFonts.cairo(
                                      textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                      : ListView.builder(
                    itemCount: _list.length,
                    itemBuilder: (context, i) {
                      final a = _list[i];
                      List list = _list;
                      return Padding(
                        padding: EdgeInsets.fromLTRB(7, 5, 7, 0),
                        child: GestureDetector(
                          onTap:(){
                            //Navigator.push(context, MaterialPageRoute(builder: (context) => Details(list: list,index: index,),),);
                            Navigator.pushNamed(context, People.id);
                            saveDepart(a.depart);
                          },
                          child: new Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)
                            ),
                            elevation: 9,
                            color: Colors.white,
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                height: MediaQuery.of(context).size.height * .1,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10,top: 10,bottom: 10),
                                  child: Text(
                                    a.depart,
                                    style: GoogleFonts.cairo(
                                      textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
