import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertest/Desination.dart';
import 'package:fluttertest/main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pie_chart/pie_chart.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key key, this.destination}) : super(key: key);
  final Destination destination;

  @override
  State<StatefulWidget> createState() {
    return _Dashboard(destination);
  }
}

Future<String> url1() async {
  final ref =
      FirebaseStorage.instance.ref().child('application finite automata.pdf');
// no need of the file extension, the name will do fine.
  var url = await ref.getDownloadURL();
  print(url);
  return url;
}

class _Dashboard extends State<Dashboard> {
  final Destination destination;

  _Dashboard(this.destination);

  TargetPlatform platform;

  Map<String, double> dataMap = new Map();

  List list = new List();
  List list1 = new List();
  List list2 = new List();
  List list3 = new List();

  initState() {
    FlutterDownloader.initialize();
  }

  Future _askUser() async {
    final dbref1 = FirebaseDatabase.instance.reference().child("users");

    DataSnapshot dbref =
        await dbref1.orderByChild('VId').equalTo(0).once();

    DataSnapshot a =
        await dbref1.orderByChild('VId').equalTo(1).once();

    DataSnapshot a1 =
        await dbref1.orderByChild('VId').equalTo(2).once();
    DataSnapshot a2 =
    await dbref1.orderByChild('VId').equalTo(3).once();

    list.clear();
    list1.clear();
    list2.clear();
    list3.clear();


    Map<dynamic, dynamic> values = await dbref.value;
    Map<dynamic, dynamic> values1 = await a.value;
    Map<dynamic, dynamic> values2 = await a1.value;
    Map<dynamic, dynamic> values3 = await a2.value;
if(values!=null) {
  values.forEach((key, values) {
    list.add(values);
  });
}
if(values1!=null) {
  values1.forEach((key1, values2) {
    list1.add(values2);
  });
}
 if(values2!=null) {
  values2.forEach((key1, values2) {
    list2.add(values2);
  });
 }
 if(values3!=null) {
   values3.forEach((key1, values2) {
     list3.add(values2);
   });
 }
    if(list==null){list.add("");}
    if(list1==null){list1.add("");}
    if(list3==null){list3.add("");}

    Map<String, double> dataMap = new Map();
    dataMap.putIfAbsent("Non Validated Users", () => list.length.roundToDouble());
    dataMap.putIfAbsent("Non Members", () => list1.length.roundToDouble()+list2.length.roundToDouble());
    dataMap.putIfAbsent("Members", () => list3.length.roundToDouble());


    return dataMap;
  }

  @override
  Widget build(BuildContext context) {
    platform = Theme.of(context).platform;
    return Scaffold(
        body: Container(
            decoration:BoxDecoration(gradient:SIGNUP_BACKGROUND),
            alignment: Alignment.center,
            child: Container(
              decoration:BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 15,
                        spreadRadius: 0,
                        offset: Offset(0.0,16.0))
                  ],
                  borderRadius: new BorderRadius.circular(12.0),
                  gradient: LinearGradient(
                      begin: FractionalOffset(0.0,0.4),
                      end:FractionalOffset(0.9,0.7),
                      stops: [
                        0.2,
                        1
                      ],
                      colors: <Color>[
                        Color(0xffFFC3A0),
                        Color(0xffFFAFBD)
                      ])),
              child: Column(
                mainAxisSize:MainAxisSize.min,

                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top:30.0,left:8.0,right:8.0,bottom:8.0),
                    child: Image.asset(
                        '/images/cevalogo.jpg',
                        width: 100.0,
                        height: 100.0,
                        fit:BoxFit.cover
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top:8.0,left:28.0,right:28.0,bottom:8.0),
                    child: FlatButton(
                      child: Text(
                        "STATISTICS",
                        textAlign: TextAlign.center,
                          style:TextStyle(
                              fontWeight: FontWeight.bold,
                              color:Color(0xff353535),
                              fontSize: 18.0,
                              fontFamily:'Montserrat'

                          )
                      ),
                      onPressed: () {
                        return showDialog(
                            context: context,
                            child: SimpleDialog(
                              children: <Widget>[
                                Container(
                                  height: 300.0,
                                  // Change as per your requirement
                                  width: 300.0,
                                  child: FutureBuilder(
                                    future: _askUser(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot snapshot) {
                                      dataMap = snapshot.data;
                                      switch (snapshot.connectionState) {
                                        case ConnectionState.waiting:
                                          return new Text('Loading....');
                                        default:
                                          if (snapshot.hasError)
                                            return new Text(
                                                'Error: ${snapshot.error}');
                                          else
                                            return PieChart(
                                              dataMap: dataMap,
                                              decimalPlaces: 2,
                                            );
                                      }
                                    },
                                  ),
                                )
                              ],
                            ));
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FlatButton(
                      child: Text("ELECTED MEMBERS",
                          textAlign: TextAlign.center,
                          style:TextStyle(
                              fontWeight: FontWeight.bold,
                              color:Color(0xff353535),
                              fontSize: 18.0,
                              fontFamily:'Montserrat'

                          )),
                      onPressed: () {},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:8.0,left:8.0,right:8.0,bottom:30.0),
                    child: FlatButton(
                      child: Text("INVOICE",
                          textAlign: TextAlign.center,style:TextStyle(
                              fontWeight: FontWeight.bold,
                              color:Color(0xff353535),
                              fontSize: 18.0,
                              fontFamily:'Montserrat'

                          )),
                      onPressed: () async {
                        Map<PermissionGroup, PermissionStatus>
                            permissionResult = await PermissionHandler()
                                .requestPermissions([PermissionGroup.storage]);
                        PermissionStatus permission = await PermissionHandler()
                            .checkPermissionStatus(PermissionGroup.storage);
                        if (permission == PermissionStatus.granted) {
                          Future<String> _findLocalPath() async {
                            final directory = platform == TargetPlatform.android
                                ? await getExternalStorageDirectory()
                                : await getApplicationDocumentsDirectory();
                            print(directory.path);
                            return directory.path;
                          }

                          String url = await url1();
                          var _localPath = (await _findLocalPath());

                          String taskId = await FlutterDownloader.enqueue(
                            url: url,
                            savedDir: _localPath,
                            showNotification: true,
                            // show download progress in status bar (for Android)
                            openFileFromNotification:
                                true, // click on notification to open downloaded file (for Android)
                          );
                          FlutterDownloader.open(taskId: taskId);
                        }
                      },
                    ),
                  ),
                ]),
            )
        ));
  }
}
