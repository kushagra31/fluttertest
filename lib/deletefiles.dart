
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/Desination.dart';
import 'package:fluttertest/MakeCall.dart';
import 'package:fluttertest/files.dart';

class deletefiles extends StatefulWidget {
  Destination destination;

  deletefiles(this.destination);
  @override
  _deletefilesState createState() => _deletefilesState(destination);
}
Future url(String a) async {
  final ref = FirebaseStorage.instance.ref().child(a);

  return ref;
}
class _deletefilesState extends State<deletefiles> {
  Destination destination;
  _deletefilesState(this.destination);
  TextEditingController filenamecontroller;
  TextEditingController descriptioncontroller;
  TargetPlatform platform;
  void initState() {
    descriptioncontroller= new TextEditingController();
    filenamecontroller = new TextEditingController();
  }
  @override
  Widget build(BuildContext context) {
    MakeCall m = new MakeCall();
    final databaseReference = FirebaseDatabase.instance
        .reference()
        .child("Circulars")
        .child("files");
    return Scaffold(
        appBar: AppBar(
          title: Text(""),
          backgroundColor: widget.destination.color,
        ),
        body: FutureBuilder(
            future: m.firebaseCalls(),
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              switch (snapshot.connectionState) {
                case (ConnectionState.waiting):
                  return CircularProgressIndicator();
                  break;
                default:
                  if(snapshot.data!=null) {
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          files h = snapshot.data[index];
                          return ListTile(
                            title: Text(h.fn),
                            subtitle: Text(h.d),
                            onTap: () async {
                              StorageReference downloadurl = await url(h.fn);
                              await downloadurl.delete();
                              databaseReference.child(h.fn).remove();
                              setState(() {});
                            },
                          );
                        });
                  }
                  else{return Text("No items to display");}
              }
            }));
  }
}
