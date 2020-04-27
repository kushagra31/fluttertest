import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/Desination.dart';
import 'package:fluttertest/main.dart';

class HomePage extends StatefulWidget {
  final Map displayname;

  const HomePage({Key key, this.destination, this.displayname})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomePageState(destination, displayname);
  }

  final Destination destination;
}

class _HomePageState extends State<HomePage> {
  final Destination destination;
  final Map displayname;

  _HomePageState(this.destination, this.displayname);

  TextEditingController filenamecontroller;
  TextEditingController descriptioncontroller;
  FirebaseAuth auth = FirebaseAuth.instance;
  TargetPlatform platform;

  Future<String> url(String a) async {
    final ref = FirebaseStorage.instance.ref().child(a);
    var url = await ref.getDownloadURL();
    print(url);
    return url;
  }

  void initState() {
    descriptioncontroller = new TextEditingController();
    filenamecontroller = new TextEditingController();
  }

  Future getsnap() async {
    Map<dynamic, dynamic> values;
    await FirebaseDatabase.instance
        .reference()
        .child("Circulars")
        .once()
        .then((onValue) {
      values = onValue.value;
    });

    return values;
  }
  Future getsnap1() async {
    FirebaseUser user= await FirebaseAuth.instance.currentUser();
    Map<dynamic, dynamic> values;
    await FirebaseDatabase.instance
        .reference()
        .child("users")
    .child(user.uid)

        .once()
        .then((onValue) {
      values = onValue.value;
    });

    return values["VId"];
  }

  @override
  Widget build(BuildContext context) {
    platform = Theme.of(context).platform;
    switch (displayname['VId']) {
      case (0):
        return Scaffold(

          backgroundColor: Colors.white,
            appBar: AppBar(
              leading:Icon(Icons.wc,color:Colors.black,size: 30,),
              title: Text("CEVA",style: TextStyle(color: Colors.black),),
              elevation:0,
              backgroundColor: Colors.white70,
            ),
            body: Container(
              child: Center(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: Text(
                          "Validation Pending",
                          style: TextStyle(fontSize: 24.0,color:Colors.black),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: FlatButton(
                          child: Text("Update Details"),

                          textColor:  Theme
                            .of(context)
                            .primaryColor,
                          onPressed: () async {
                            int validationId = await getsnap1();
                            if (validationId == 0) {
                              Navigator.pushNamed(context, '/update',
                                  arguments: displayname);
                            } else {
                              RestartWidget.restartApp(context);
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: FlatButton(
                          child: Text("Update EmployeeId"),
                          textColor: Theme
                              .of(context)
                              .primaryColor,

                          onPressed: () async {
                            int validationId = await getsnap1();
                            if (validationId == 0) {
                              Navigator.pushNamed(context, '/updateemp',
                                  arguments: displayname);
                            } else {
                              RestartWidget.restartApp(context);
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ));
        break;
      case (1):
        //Validated Non Member
        return Scaffold(
            appBar: AppBar(
              title: Text(""),
              backgroundColor: widget.destination.color,
            ),
            body: Column(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text("Circulars"),
                  onPressed: () async {
                    Navigator.pushNamed(context, '/downloadfiles',
                        arguments: displayname);
                  },
                ),
              )
            ]));
        break;
      case (2):
        //Applied for membership
        return Scaffold(
            appBar: AppBar(
              title: Text(""),
              backgroundColor: widget.destination.color,
            ),
            body: Column(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text("Circulars"),
                  onPressed: () async {
                    Navigator.pushNamed(context, '/downloadfiles',
                        arguments: displayname);
                  },
                ),
              )
            ]));
        break;
      case (3):
        //Member
        return Scaffold(
            appBar: AppBar(
              title: Text(""),
              backgroundColor: widget.destination.color,
            ),
            body: Column(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text("Circulars"),
                  onPressed: () async {
                    Navigator.pushNamed(context, '/downloadfiles',
                        arguments: displayname);
                  },
                ),
              )
            ]));
        break;
      case (4):
        //Admin
        return Scaffold(

            body: Container(
              alignment:Alignment.centerRight,
              decoration:BoxDecoration(gradient: SIGNUP_BACKGROUND),
              child: Column(
                  children: [

                    Container(
                      margin: const EdgeInsets.only(right: 16.0),
                      child: Row(
                        children: <Widget>[
                          InkWell(
                              child: Container(
                                  padding:EdgeInsets.symmetric(horizontal: 36.0,vertical: 16.0),
                                  decoration:BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 15,
                                            spreadRadius: 0,
                                            offset: Offset(0.0,32.0))
                                      ],
                                      borderRadius: new BorderRadius.circular(36.0),
                                      gradient: LinearGradient(
                                          begin: FractionalOffset.centerLeft,
                                          stops: [
                                            0.2,
                                            1
                                          ],
                                          colors: <Color>[
                                            Color(0xff000000),
                                            Color(0xff434343)
                                          ])),
                                  child: Text("Upload Circulars",
                                      style: TextStyle(
                                          color: Color(0xffF1EA94),
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Montserrat'
                                      ))
                              ),


                              onTap: () async {
                                Navigator.pushNamed(context, '/uploadfiles',
                                    arguments: displayname);

                              }),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top:8.0,right: 32.0),
                      child: Row(
                        children: <Widget>[
                          InkWell(
                              child: Container(
                                  padding:EdgeInsets.symmetric(horizontal: 36.0,vertical: 16.0),
                                  decoration:BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 15,
                                            spreadRadius: 0,
                                            offset: Offset(0.0,32.0))
                                      ],
                                      borderRadius: new BorderRadius.circular(36.0),
                                      gradient: LinearGradient(
                                          begin: FractionalOffset.centerLeft,
                                          stops: [
                                            0.2,
                                            1
                                          ],
                                          colors: <Color>[
                                            Color(0xff000000),
                                            Color(0xff434343)
                                          ])),
                                  child: Text("Download Circulars",
                                      style: TextStyle(
                                          color: Color(0xffF1EA94),
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Montserrat'
                                      ))
                              ),


                              onTap: () async {Navigator.pushNamed(context, '/downloadfiles',
                                  arguments: displayname);

                              }),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top:8.0,right: 16.0),
                      child: Row(
                        children: <Widget>[
                          InkWell(
                              child: Container(
                                  padding:EdgeInsets.symmetric(horizontal: 36.0,vertical: 16.0),
                                  decoration:BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 15,
                                            spreadRadius: 0,
                                            offset: Offset(0.0,32.0))
                                      ],
                                      borderRadius: new BorderRadius.circular(36.0),
                                      gradient: LinearGradient(
                                          begin: FractionalOffset.centerLeft,
                                          stops: [
                                            0.2,
                                            1
                                          ],
                                          colors: <Color>[
                                            Color(0xff000000),
                                            Color(0xff434343)
                                          ])),
                                  child: Text("Delete Circulars",
                                      style: TextStyle(
                                          color: Color(0xffF1EA94),
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Montserrat'
                                      ))
                              ),


                              onTap: () async {Navigator.pushNamed(context, '/deletefiles',
                                  arguments: displayname);
                              }),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top:8.0,right: 32.0),
                      child: Row(
                        children: <Widget>[
                          InkWell(
                              child: Container(
                                  padding:EdgeInsets.symmetric(horizontal: 36.0,vertical: 16.0),
                                  decoration:BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 15,
                                            spreadRadius: 0,
                                            offset: Offset(0.0,32.0))
                                      ],
                                      borderRadius: new BorderRadius.circular(36.0),
                                      gradient: LinearGradient(
                                          begin: FractionalOffset.centerLeft,
                                          stops: [
                                            0.2,
                                            1
                                          ],
                                          colors: <Color>[
                                            Color(0xff000000),
                                            Color(0xff434343)
                                          ])),
                                  child: Text("Validate Users",
                                      style: TextStyle(
                                          color: Color(0xffF1EA94),
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Montserrat'
                                      ))
                              ),


                              onTap: () async {
                                Navigator.pushNamed(context, '/userslist');

                              }),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top:8.0,right: 16.0),
                      child: Row(
                        children: <Widget>[
                          InkWell(
                              child: Container(
                                  padding:EdgeInsets.symmetric(horizontal: 36.0,vertical: 16.0),
                                  decoration:BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 15,
                                            spreadRadius: 0,
                                            offset: Offset(0.0,32.0))
                                      ],
                                      borderRadius: new BorderRadius.circular(36.0),
                                      gradient: LinearGradient(
                                          begin: FractionalOffset.centerLeft,
                                          stops: [
                                            0.2,
                                            1
                                          ],
                                          colors: <Color>[
                                            Color(0xff000000),
                                            Color(0xff434343)
                                          ])),
                                  child: Text("Update Membership Status",
                                      style: TextStyle(
                                          color: Color(0xffF1EA94),
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Montserrat'
                                      ))
                              ),


                              onTap: () async {
                                Navigator.pushNamed(context, '/updatemembershipstatus');

                              }),
                        ],
                      ),
                    ),

              ]),
            ));
        break;
    }
  }
}
