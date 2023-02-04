
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Details extends StatefulWidget {
  final List list;
  final int index;
  Details({required this.list,required this.index});
  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {

  String? name,phone,address,about,depart,images;
  //final Uri _url = Uri.parse();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name    =  widget.list[widget.index]['name'];
    phone   =  widget.list[widget.index]['phone'];
    address =  widget.list[widget.index]['address'];
    about   =  widget.list[widget.index]['about'];
    depart  =  widget.list[widget.index]['depart'];
    images  =  widget.list[widget.index]['images'];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:(){
        Navigator.pop(context);
        return Future.value(false);
      },
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: [
                        Container(
                          height: 300.0,
                          child: new ClipRRect(
                            borderRadius: new BorderRadius.only(
                              bottomLeft: const Radius.circular(20),
                              bottomRight: const Radius.circular(20),
                            ),
                            child:Image.network(images!,fit:BoxFit.cover),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                      child: new Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)
                        ),
                        elevation: 9,
                        color: Colors.white,
                        child: Container(
                          height: MediaQuery.of(context).size.height * .1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  name!,
                                  style: TextStyle(color: Colors.black,fontSize: 18),
                                ),
                                Text(
                                  '  :  الاسم',
                                  style: TextStyle(color: Colors.black,fontSize: 20,fontWeight:FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                      child: new Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)
                        ),
                        elevation: 9,
                        color: Colors.white,
                        child: Container(
                          height: MediaQuery.of(context).size.height * .1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                GestureDetector(
                                  onTap:(){
                                    launch('tel://${phone}');
                                  },
                                  child: Text(
                                    phone!,
                                    style: TextStyle(color: Colors.black,fontSize: 18),
                                  ),
                                ),
                                Text(
                                  '  :  رقم الهاتف',
                                  style: TextStyle(color: Colors.black,fontSize: 20,fontWeight:FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                      child: new Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)
                        ),
                        elevation: 9,
                        color: Colors.white,
                        child: Container(
                          height: MediaQuery.of(context).size.height * .1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  address!,
                                  style: TextStyle(color: Colors.black,fontSize: 18),
                                ),
                                Text(
                                  '  :  العنوان',
                                  style: TextStyle(color: Colors.black,fontSize: 20,fontWeight:FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                      child: new Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)
                        ),
                        elevation: 9,
                        color: Colors.white,
                        child: Container(
                          height: MediaQuery.of(context).size.height * .1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  depart!,
                                  style: TextStyle(color: Colors.black,fontSize: 18),
                                ),
                                Text(
                                  '  :  القسم',
                                  style: TextStyle(color: Colors.black,fontSize: 20,fontWeight:FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                      child: new Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)
                        ),
                        elevation: 9,
                        color: Colors.white,
                        child: Container(
                          height: MediaQuery.of(context).size.height * .3,
                          width:  MediaQuery.of(context).size.width ,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20,left: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  '  :  نبذه',
                                  style: TextStyle(color: Colors.black,fontSize: 20,fontWeight:FontWeight.bold),
                                ),
                                Text(
                                  about!,
                                  style: TextStyle(color: Colors.black,fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Container(
                  height: MediaQuery.of(context).size.height * .1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ClipOval(
                        child: Material(
                          color: Colors.white,
                          child: GestureDetector(
                            onTap:(){
//                          Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                              builder: (context) => Home(),
//                            ),
//                          );
                              Navigator.pop(context);
                            },
                            child: SizedBox(
                              child: Icon(Icons.arrow_back,color: Colors.black),
                              height: 32,
                              width: 32,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
