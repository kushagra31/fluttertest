import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/MakeCall.dart';
import 'package:fluttertest/users.dart';
class userslist extends StatefulWidget {
  @override
  _userslistState createState() => _userslistState();
}

class _userslistState extends State<userslist> {


  @override
  Widget build(BuildContext context) {

    MakeCall m = new MakeCall();

    return Scaffold(
        appBar: AppBar(
          title: Text(""),

        ),
        body: FutureBuilder(
            future: m.usersfirebaseCalls(),
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return CircularProgressIndicator();
                  break;

                default:
if(snapshot.data!=null) {
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

                  RaisedButton(
                    child: Text("Validate"),
                    onPressed: () async {
                      await FirebaseDatabase.instance
                          .reference()
                          .child("users")
                          .child(h.uid)
                          .update({
                        "VId": 1,
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

            }
            )
    );
  }
}
