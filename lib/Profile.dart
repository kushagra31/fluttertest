import 'dart:io'as io ;
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/Desination.dart';
import 'package:fluttertest/main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'info_card.dart';

class Profile extends StatefulWidget {
  final Map displayname;

  const Profile({Key key, this.destination, this.displayname})
      : super(key: key);
  final Destination destination;

  @override
  State<StatefulWidget> createState() {
    return _Profile(destination, displayname);
  }
}

class _Profile extends State<Profile> with AutomaticKeepAliveClientMixin {
  FirebaseAuth auth;
  final Destination destination;
  final Map displayname;
  ImageProvider image;
  TargetPlatform platform;
  _Profile(this.destination, this.displayname);


  initState() {
    auth = FirebaseAuth.instance;
     imageProvider().then((onValue){
       image=onValue;
     });
  }
  Future<ImageProvider> imageProvider() async{
    PermissionStatus permission =
        await PermissionHandler()
        .checkPermissionStatus(
        PermissionGroup.storage);
    if (permission == PermissionStatus.granted) {
      Future<String> _findLocalPath() async {
        final directory = platform ==
            TargetPlatform.android
            ? await getExternalStorageDirectory()
            : await getApplicationDocumentsDirectory();
        return directory.path;
      }
      File file;
      if(await File(await _findLocalPath() +"/"+displayname['uid'] +" profileimage.jpg").exists()) {
        file = File(await _findLocalPath() + "/" + displayname['uid'] +
            " profileimage.jpg");
      }
    if(file==null){
        return AssetImage("/images/books.jpg");
      }
      return FileImage(file);

  }
    return AssetImage("/images/books.jpg");
  }

  Future<List> getsnap() async {
    FirebaseUser user = await auth.currentUser();
    String uid = user.uid;
    List result = new List();
    await FirebaseDatabase.instance
        .reference()
        .child("users")
        .child(uid)
        .once()
        .then((onValue) {
      Map<dynamic, dynamic> values = onValue.value;
      values.forEach((key, values) {
        result.add(values);
      });
    });

    return result;
  }

  @override
  Widget build(BuildContext context1) {
    if(displayname["VId"]==3) {
      return buildqmember(displayname["em"], "", "");
    }else{
      return buildq(displayname["em"], "", "");

    }
  }

  Widget buildq(String email, String phone, String url) {


    platform = Theme.of(context).platform;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(destination.title,style: TextStyle(color: Colors.black),),
          backgroundColor: widget.destination.color,
        ),
        backgroundColor: Colors.white,
        body: Container(
          decoration:BoxDecoration(
            gradient:SIGNUP_BACKGROUND
          ),
          child: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  Card(
                      color: Colors.white,
                      elevation: 0,
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                height: 70,
                                width: 70,
                                  child:
                                         CircleAvatar(
                                                  child: GestureDetector(
                                                  onTap: () async {
                                                Map<PermissionGroup, PermissionStatus>
                                                permissionResult = await PermissionHandler()
                                                    .requestPermissions(
                                                    [PermissionGroup.storage]);
                                                PermissionStatus permission =
                                                    await PermissionHandler()
                                                    .checkPermissionStatus(
                                                    PermissionGroup.storage);
                                                if (permission == PermissionStatus.granted) {
                                                  Future<String> _findLocalPath() async {
                                                    final directory = platform ==
                                                        TargetPlatform.android
                                                        ? await getExternalStorageDirectory()
                                                        : await getApplicationDocumentsDirectory();
                                                    return directory.path;
                                                  }
                                                  File file = await FilePicker.getFile(
                                                    type: FileType.image,
                                                    fileExtension: ".jpg",
                                                  );

                                                  if (file != null) {
                                                    File file1=  file.copySync(await _findLocalPath()+"/"+displayname['uid'] +" profileimage.jpg");
                                                    setState((){
                                                      image=FileImage(file);
                                                    });
                                                  }
                                                }
                                                },
                                                  ),
                                              radius: 30,
                                              backgroundImage: image,
                                              backgroundColor: Colors.lightGreen,
                                              foregroundColor: Colors.lightGreen,
                                            )




                            ),
                          ),
                          Expanded(
                              child: ListTile(
                                title: Text(
                                  displayname["N"],
                                ),
                                subtitle:
                                Text("Employee Id: " +
                                    displayname["EId"].toString()),
                              )),
                        ],
                      )),
                  Card(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            "ACCOUNT",
                            style: TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text("Signed in as: " + displayname["em"]),
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.pushNamed(context, '/mobilenumber',
                                arguments: displayname);
                          },
                          subtitle: Text(displayname["PN"].toString()),
                          title: Text(
                            "Mobile number",
                            style: TextStyle(),
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            Navigator.pushNamed(context, '/applyformember',
                                arguments: displayname);
                          },
                          title: Text(
                            "Apply for membership",
                            style: TextStyle(),
                          ),
                        ),
                        ListTile(
                          onTap: () {
                            auth.signOut();
                            Navigator.of(context, rootNavigator: true)
                                .pushNamedAndRemoveUntil(
                                '/signin', (Route<dynamic> route) => false);
                          },
                          title: Text(
                            "Log out",
                            style: TextStyle(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  InfoCard(),
                ],
              ),
            ),
          ),
        ));
  }
  Widget buildqmember(String email, String phone, String url) {
    platform = Theme.of(context).platform;
    return Scaffold(
        appBar: AppBar(
          title: Text(destination.title),
          backgroundColor: destination.color,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Card(
                    color: Colors.white,
                    elevation: 0,
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              height: 70,
                              width: 70,
                              child:
                              CircleAvatar(
                                child: GestureDetector(
                                  onTap: () async {
                                    Map<PermissionGroup, PermissionStatus>
                                    permissionResult = await PermissionHandler()
                                        .requestPermissions(
                                        [PermissionGroup.storage]);
                                    PermissionStatus permission =
                                    await PermissionHandler()
                                        .checkPermissionStatus(
                                        PermissionGroup.storage);
                                    if (permission == PermissionStatus.granted) {
                                      Future<String> _findLocalPath() async {
                                        final directory = platform ==
                                            TargetPlatform.android
                                            ? await getExternalStorageDirectory()
                                            : await getApplicationDocumentsDirectory();
                                        return directory.path;
                                      }
                                      File file = await FilePicker.getFile(
                                        type: FileType.image,
                                        fileExtension: ".jpg",
                                      );

                                      if (file != null) {
                                        File file1=  file.copySync(await _findLocalPath()+"/"+displayname['uid'] +" profileimage.jpg");
                                        setState((){
                                          image=FileImage(file);
                                        });
                                      }
                                    }
                                  },
                                ),
                                radius: 30,
                                backgroundImage: image,
                                backgroundColor: destination
                                    .color,
                                foregroundColor: destination
                                    .color,
                              )




                          ),
                        ),
                        Expanded(
                            child: ListTile(
                              title: Text(
                                displayname["N"],
                              ),
                              subtitle:
                              Text("Employee Id: " +
                                  displayname["EId"].toString()),
                            )),
                      ],
                    )),
                Card(
                  elevation: 0,
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          "ACCOUNT",
                          style: TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text("Signed in as: " + displayname["em"]),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, '/mobilenumber',
                              arguments: displayname);
                        },
                        subtitle: Text(displayname["PN"].toString()),
                        title: Text(
                          "Mobile number",
                          style: TextStyle(),
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          auth.signOut();
                          Navigator.of(context, rootNavigator: true)
                              .pushNamedAndRemoveUntil(
                              '/signin', (Route<dynamic> route) => false);
                        },
                        title: Text(
                          "Log out",
                          style: TextStyle(),
                        ),
                      ),
                    ],
                  ),
                ),
                InfoCard(),
              ],
            ),
          ),
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
