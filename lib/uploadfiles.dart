
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/Desination.dart';
import 'package:permission_handler/permission_handler.dart';

class uploadfiles extends StatefulWidget {
  Destination destination;

  uploadfiles(this.destination);
  @override
  _uploadfilesState createState() => _uploadfilesState(destination);
}

class _uploadfilesState extends State<uploadfiles> {
  Destination destination;

  _uploadfilesState(this.destination);

  TextEditingController filenamecontroller;
  TextEditingController descriptioncontroller;
  final GlobalKey<FormState> _registerFormKey1 = GlobalKey<FormState>();
  TargetPlatform platform;
  bool _autovalidate = false;
  void initState() {
    descriptioncontroller= new TextEditingController();
    filenamecontroller = new TextEditingController();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(""),
          backgroundColor: Colors.lightGreen,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Form(
                key: _registerFormKey1,
                autovalidate: _autovalidate,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'File Name',
                          hintText: "circular.jpg",
                        ),
                        controller: filenamecontroller,

                        // ignore: missing_return
                        validator: (value) {
                          if (value.length < 3) {
                            return "Please enter a valid file name.";
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'File Description',
                          hintText: "",
                        ),
                        controller: descriptioncontroller,

                        // ignore: missing_return
                        validator: (value) {
                          if (value.length < 10) {
                            return "Please enter description";
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        child: Text(" Upload files "),
                        onPressed: () async {
                          if (_registerFormKey1.currentState.validate()) {
                            String filename=filenamecontroller.text;
                            String description=descriptioncontroller.text;
                            print(filename);
                            Map<PermissionGroup, PermissionStatus>
                            permissionResult = await PermissionHandler()
                                .requestPermissions(
                                [PermissionGroup.storage]);
                            PermissionStatus permission =
                            await PermissionHandler().checkPermissionStatus(
                                PermissionGroup.storage);
                            if (permission == PermissionStatus.granted) {
                              File file = await FilePicker.getFile();
                              if (file != null) {
                                final StorageReference firebaseStorageRef =
                                FirebaseStorage
                                    .instance
                                    .ref()
                                    .child(filename);
                                final StorageUploadTask task =
                                firebaseStorageRef.putFile(file);
                                double sie =await file.length()/1024;
                                int size=sie.round();
                                StorageTaskSnapshot task1=await task.onComplete;

                                FirebaseDatabase.instance
                                    .reference()
                                    .child('Circulars')
                                    .child('files')
                                    .child(filename)
                                    .update({
                                  "fn":filename,
                                  "d":description,
                                  "s":size.toString()+"kb",
                                  "T":DateTime.now().millisecondsSinceEpoch
                                });
                                setState(() {
                                  Scaffold.of(context).showSnackBar(SnackBar(content: Text("File uploaded to storage")));
                                });
                              }
                            }
                          }
                          else {
                            setState(() {
                              _autovalidate=true;
                            });
                          }
                        },
                      ),
                    )
                  ],
                )),
          ),
        ));
  }
}
