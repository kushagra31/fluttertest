import 'package:flutter/material.dart';
import 'package:fluttertest/Dashboard.dart';
import 'package:fluttertest/Desination.dart';
import 'package:fluttertest/HomePage.dart';
import 'package:fluttertest/Profile.dart';
import 'package:fluttertest/applyformember.dart';
import 'package:fluttertest/deletefiles.dart';
import 'package:fluttertest/downloadfiles.dart';
import 'package:fluttertest/mobilenumber.dart';
import 'package:fluttertest/updatedetails.dart';
import 'package:fluttertest/updateemployeeid.dart';
import 'package:fluttertest/updatemembershipstatus.dart';
import 'package:fluttertest/uploadfiles.dart';
import 'package:fluttertest/userslist.dart';

class DestinationView extends StatefulWidget {

  DestinationView({ Key key, this.destination ,this.onNavigation,this.navigatorKey,this.displayname}) : super(key: key);

  final Destination destination;
  final VoidCallback onNavigation;
  final Key navigatorKey;
  final Map displayname;

  @override
  _DestinationViewState createState() => _DestinationViewState(destination,displayname);

}
class ViewNavigatorObserver extends NavigatorObserver {
  ViewNavigatorObserver(this.onNavigation);

  final VoidCallback onNavigation;

  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    onNavigation();
  }
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    onNavigation();
  }
}

class _DestinationViewState extends State<DestinationView> {


   Map displayname;
  _DestinationViewState(this.destination,this.displayname);
  final Destination destination;
  @override
  Widget build(BuildContext context) {

      return Navigator(
        key: widget.navigatorKey,
        observers: <NavigatorObserver>[
          ViewNavigatorObserver(widget.onNavigation),
        ],
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(
            settings: settings,
            // ignore: missing_return
            builder: (BuildContext context) {
              switch (settings.name) {
                case '/':
                  return navigation(destination.index);
                case '/update':
                  return updatedetails(widget.destination);
                case '/updateemp':
                  return updateemployeeid(widget.destination);
                case'/mobilenumber':
                  return mobilenumber(widget.destination);
                case'/uploadfiles':
                  return uploadfiles(widget.destination);
                case'/downloadfiles':
                  return downloadfiles(widget.destination);
                case'/deletefiles':
                  return deletefiles(widget.destination);
                case'/userslist':
                  return userslist();
                case'/applyformember':
                  return applyformember(widget.destination);
                case'/updatemembershipstatus':
                  return updatemembershipstatus();
              }
            },
          );
        },
      );
    }

   Widget navigation(int index){
     switch(destination.index){
       case 0:
         return HomePage(destination: widget.destination,displayname: displayname);
         break;

       case 1:
         return Dashboard(destination: widget.destination);
         break;

       case 2:
         return Profile(destination: widget.destination,displayname: displayname);
         break;

     }
   }
  }

