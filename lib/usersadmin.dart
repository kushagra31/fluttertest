
import 'package:flutter/material.dart';
class usersadmin extends StatefulWidget {
  @override
  _usersadminState createState() => _usersadminState();
}

class _usersadminState extends State<usersadmin> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          ListTile(
            title: Text("Non Validated Users"),
            onTap: () async {
              Navigator.pushNamed(context, '/userslist',arguments: 0);
            },
          ),
          ListTile(
            title: Text("Validated Non Members"),
            onTap: () async {
              Navigator.pushNamed(context, '/userslist',arguments: 1);
            },
          ),
          ListTile(
            title: Text("Members"),
            onTap: () async {
              Navigator.pushNamed(context, '/userslist',arguments: 2);
            },
          )
        ],
      ),
    );
  }
}
