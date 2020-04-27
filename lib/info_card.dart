import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {

  Function onPressed;

  InfoCard({

    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(

      child: Column(
        children: <Widget>[
          ListTile(
            onTap: onPressed,

            title: Text(
              "INFORMATION",

              style: TextStyle(
               fontSize: 15.0,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          ListTile(
            onTap: onPressed,

            title: Text(
              "Help & feedback",
              style: TextStyle(


              ),
            ),
          ),
          ListTile(

            title: Text(
              "About app",
              style: TextStyle(


              ),
            ),
          ),
          ListTile(

            title: Text(
              "Version",
              style: TextStyle(


              ),
            ),
          ),

        ],
      ),
    );
  }
}