
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertest/Desination.dart';
import 'package:fluttertest/MakeCall.dart';
import 'package:fluttertest/files.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pie_chart/pie_chart.dart';

class downloadfiles extends StatefulWidget {
  Destination destination;

  downloadfiles(this.destination);
  @override
  _downloadfilesState createState() => _downloadfilesState(destination);
}
Future<String> url(String a) async {
  final ref = FirebaseStorage.instance.ref().child(a);
// no need of the file extension, the name will do fine.
  var url = await ref.getDownloadURL();
  print(url);
  return url;
}
Future<String> url1() async {
  final ref =
  FirebaseStorage.instance.ref().child('application finite automata.pdf');
// no need of the file extension, the name will do fine.
  var url = await ref.getDownloadURL();
  print(url);
  return url;
}
class _downloadfilesState extends State<downloadfiles> {

  Destination destination;
  _downloadfilesState(this.destination);
  TextEditingController filenamecontroller;
  TextEditingController descriptioncontroller;
  TargetPlatform platform;

  initState() {
    descriptioncontroller= new TextEditingController();
    filenamecontroller = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    MakeCall m = new MakeCall();

    platform = Theme.of(context).platform;
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
                          return Card(
                              child:ListTile(
                                title: Text(h.fn),
                                subtitle: Text(h.d),
                                trailing: Text(h.s.toString()),
                                leading:Text(h.T.toString()),
                            onTap: () async {
                              Map<PermissionGroup, PermissionStatus>
                              permissionResult = await PermissionHandler()
                                  .requestPermissions([
                                PermissionGroup.storage
                              ]);
                              PermissionStatus permission = await PermissionHandler()
                                  .checkPermissionStatus(PermissionGroup
                                  .storage);
                              if (permission == PermissionStatus.granted) {
                                Future<String> _findLocalPath() async {
                                  final directory = platform ==
                                      TargetPlatform.android
                                      ? await getExternalStorageDirectory()
                                      : await getApplicationDocumentsDirectory();
                                  return directory.path;
                                }

                                String downloadurl = await url(h.fn);
                                var _localPath = (await _findLocalPath());

                                await FlutterDownloader.enqueue(
                                  fileName: h.fn,
                                  url: downloadurl,
                                  savedDir: _localPath,
                                  showNotification: true,
                                  // show download progress in status bar (for Android)
                                  openFileFromNotification:
                                  true, // click on notification to open downloaded file (for Android)
                                ).then((onValue) {
                                  FlutterDownloader.open(taskId: onValue);
                                });
                              }
                            },
                          ));
                        });
                  }
                  else{
                    return Text("No items to display");
                  }
                  }
            }));
  }
}
