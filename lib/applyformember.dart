import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/Desination.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class applyformember extends StatefulWidget {
  Destination destination;

  applyformember(this.destination);

  @override
  _applyformemberState createState() => _applyformemberState(destination);
}

class _applyformemberState extends State<applyformember> {
  Destination destination;

  _applyformemberState(this.destination);
  FirebaseAuth auth = FirebaseAuth.instance;

  TargetPlatform platform;
  String Crisid;
  String Aadhar;
  File crisIdimage;
  File Aadharimage;

  initState() {
    Crisid ="";
    Aadhar ="";
  }

  @override
  Widget build(BuildContext context) {
    platform = Theme.of(context).platform;
    return Scaffold(
        appBar: AppBar(
          title: Text(""),
          backgroundColor: widget.destination.color,
        ),
        body: ListView(
          children: <Widget>[
            ListTile(

                title: Text("Upload Cris Id"),
                subtitle: Text(Crisid),
                onTap: () async {
                  Map<PermissionGroup, PermissionStatus> permissionResult =
                      await PermissionHandler()
                          .requestPermissions([PermissionGroup.storage]);
                  PermissionStatus permission = await PermissionHandler()
                      .checkPermissionStatus(PermissionGroup.storage);
                  if (permission == PermissionStatus.granted) {

                     File takecrisIdimage = await FilePicker.getFile(
                      type: FileType.image

                    );

                    if (takecrisIdimage != null) {
                      setState(() {
                        crisIdimage=takecrisIdimage;
                        Crisid=takecrisIdimage.path;
                      });
                    }
                  }
                }),
            ListTile(

                title: Text("Upload Aadhar Card"),
                subtitle: Text(Aadhar),
                onTap: () async {
                  Map<PermissionGroup, PermissionStatus> permissionResult =
                  await PermissionHandler()
                      .requestPermissions([PermissionGroup.storage]);
                  PermissionStatus permission = await PermissionHandler()
                      .checkPermissionStatus(PermissionGroup.storage);
                  if (permission == PermissionStatus.granted) {

                    File takeaadharimage = await FilePicker.getFile(
                        type: FileType.image

                    );

                    if (takeaadharimage != null) {
                      setState(() {
                        Aadharimage=takeaadharimage;
                        Aadhar=takeaadharimage.path;
                      });
                    }
                  }
                }),

            RaisedButton(
              child:Text("Apply for membership"),
              onPressed:() async{
                if(Aadharimage==null || crisIdimage==null){

                }
                if(Aadharimage!=null && crisIdimage!=null) {
                  FirebaseUser user = await auth.currentUser();
                  final StorageReference firebaseStorageRef =
                  FirebaseStorage
                      .instance
                      .ref()
                      .child('userdocs')
                      .child(user.uid)
                      .child('crisIdcard')
                      .child(user.uid + " crisid");
                  final StorageUploadTask task =
                  firebaseStorageRef.putFile(crisIdimage);

                  StorageTaskSnapshot t = await task.onComplete;
                  final StorageReference firebaseStorageRef1 =
                  FirebaseStorage
                      .instance
                      .ref()
                      .child('userdocs')
                      .child(user.uid)
                      .child('Aadharcard')
                      .child(user.uid + " aadharcard");
                  final StorageUploadTask task2 =
                  firebaseStorageRef1.putFile(Aadharimage);

                  StorageTaskSnapshot task1 = await task2.onComplete;

                  FirebaseDatabase.instance
                      .reference()
                      .child('users')
                      .child(user.uid)
                      .update({
                    'VId': 2,
                  });
                }
              }
            )

          ],
        ));
  }
}
