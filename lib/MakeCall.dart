import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertest/files.dart';
import 'package:fluttertest/users.dart';

class MakeCall{

  List<files> listItems= new List<files>();
  List<users> userslist = new List<users>();

  Future<List<files>> firebaseCalls () async{

    await FirebaseDatabase.instance.reference().child("Circulars").child("files")
    .once().then((DataSnapshot datasnapshot){
      var result= datasnapshot.value.values as Iterable;
      for(var value in result){
        listItems.add(new files.fromJson(value));
      }
    });


    return listItems;
  }
  Future<List<users>> usersfirebaseCalls () async{

    await FirebaseDatabase.instance.reference().child("users")
        .orderByChild('VId')
        .equalTo(0)
        .once().then((DataSnapshot datasnapshot){
      var result= datasnapshot.value.values as Iterable;
      for(var value in result){
        userslist.add(new users.fromJson(value));
      }
    });


    return userslist;
  }
  Future<List<users>> usersfirebaseCalls1 () async{

    await FirebaseDatabase.instance.reference().child("users")
        .orderByChild('VId')
        .equalTo(2)
        .once().then((DataSnapshot datasnapshot){
      var result= datasnapshot.value.values as Iterable;
      for(var value in result){
        userslist.add(new users.fromJson(value));
      }
    });


    return userslist;
  }
}