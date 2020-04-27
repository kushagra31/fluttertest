import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertest/MakeCall.dart';
import 'package:fluttertest/users.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
class updatemembershipstatus extends StatefulWidget {
  @override
  _updatemembershipstatusState createState() => _updatemembershipstatusState();
}
Future<String> url1(String a) async {
  final StorageReference firebaseStorageRef =
  FirebaseStorage
      .instance
      .ref()
      .child('userdocs')
      .child(a)
      .child('crisIdcard')
      .child(a + " crisid");
// no need of the file extension, the name will do fine.
  var url = await firebaseStorageRef.getDownloadURL();
  print(url);
  return url;
}
Future<String> url2(String a) async {
  final StorageReference firebaseStorageRef1 =
  FirebaseStorage
      .instance
      .ref()
      .child('userdocs')
      .child(a)
      .child('Aadharcard')
      .child(a + " aadharcard");
// no need of the file extension, the name will do fine.
  var url = await firebaseStorageRef1.getDownloadURL();
  print(url);
  return url;
}

class _updatemembershipstatusState extends State<updatemembershipstatus> {

  TargetPlatform platform;
  @override
  Widget build(BuildContext context) {

    MakeCall m = new MakeCall();
    platform = Theme.of(context).platform;
    return Scaffold(
        appBar: AppBar(
          title: Text(""),

        ),
        body: FutureBuilder(
            future: m.usersfirebaseCalls1(),
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return CircularProgressIndicator();
                  break;
                default:if(snapshot.data!=null) {
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        users h = snapshot.data[index];
                        return Card(
                            child: Column(
                                children: [
                                  Text(h.N.toString()),
                                  Text(h.em),
                                  Text(h.VId.toString()),
                                  Text(h.PN.toString()),
                                  Text(h.EId.toString()),
                                  Text(h.L.toString()),
                                  Text(h.G.toString()),
                                  Row(
                                      children: <Widget>[
                                        RaisedButton(
                                          child: (Text("Verify CrisId")),
                                          onPressed: () async {
                                            Map<
                                                PermissionGroup,
                                                PermissionStatus>
                                            permissionResult = await PermissionHandler()
                                                .requestPermissions([
                                              PermissionGroup.storage
                                            ]);
                                            PermissionStatus permission = await PermissionHandler()
                                                .checkPermissionStatus(
                                                PermissionGroup
                                                    .storage);
                                            if (permission ==
                                                PermissionStatus.granted) {
                                              Future<
                                                  String> _findLocalPath() async {
                                                final directory = platform ==
                                                    TargetPlatform.android
                                                    ? await getExternalStorageDirectory()
                                                    : await getApplicationDocumentsDirectory();
                                                return directory.path;
                                              }

                                              String downloadurl = await url1(
                                                  h.uid);
                                              var _localPath = (await _findLocalPath());

                                              await FlutterDownloader.enqueue(
                                                fileName: h.uid + " crisId",
                                                url: downloadurl,
                                                savedDir: _localPath,
                                                showNotification: true,
                                                // show download progress in status bar (for Android)
                                                openFileFromNotification:
                                                true, // click on notification to open downloaded file (for Android)
                                              ).then((onValue) {
                                                FlutterDownloader.open(
                                                    taskId: onValue);
                                              });
                                            }
                                          },),
                                        RaisedButton(
                                          child: (Text("Verify Aadhar")),
                                          onPressed: () async {
                                            Map<
                                                PermissionGroup,
                                                PermissionStatus>
                                            permissionResult = await PermissionHandler()
                                                .requestPermissions([
                                              PermissionGroup.storage
                                            ]);
                                            PermissionStatus permission = await PermissionHandler()
                                                .checkPermissionStatus(
                                                PermissionGroup
                                                    .storage);
                                            if (permission ==
                                                PermissionStatus.granted) {
                                              Future<
                                                  String> _findLocalPath() async {
                                                final directory = platform ==
                                                    TargetPlatform.android
                                                    ? await getExternalStorageDirectory()
                                                    : await getApplicationDocumentsDirectory();
                                                return directory.path;
                                              }

                                              String downloadurl = await url2(
                                                  h.uid);
                                              var _localPath = (await _findLocalPath());

                                              await FlutterDownloader.enqueue(
                                                fileName: h.uid + " aadhar",
                                                url: downloadurl,
                                                savedDir: _localPath,
                                                showNotification: true,
                                                // show download progress in status bar (for Android)
                                                openFileFromNotification:
                                                true, // click on notification to open downloaded file (for Android)
                                              ).then((onValue) {
                                                FlutterDownloader.open(
                                                    taskId: onValue);
                                              });
                                            }
                                          },),
                                      ]),
                                  RaisedButton(
                                    child: Text("Validate"),
                                    onPressed: () async {
                                      await FirebaseDatabase.instance
                                          .reference()
                                          .child("users")
                                          .child(h.uid)
                                          .update({
                                        "VId": 3,
                                        "MTS":DateTime.now().millisecondsSinceEpoch
                                      }

                                      );
                                      setState(() {});
                                    },)
                                ]
                            )

                        );
                      });
                }else{
              return Text("No items to display");
              }

              }
            }));
  }
}
