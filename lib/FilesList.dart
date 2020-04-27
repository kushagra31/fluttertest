import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertest/files.dart';

class FilesList{
  List<files> fileslist;

  FilesList({this.fileslist});

  factory FilesList.fromJSON(Map<dynamic,dynamic> json){
    return FilesList(
        fileslist: parserecipes(json)
    );
  }
  static List<files> parserecipes(recipeJSON){
    var rList=recipeJSON['files'] as List;
    List<files> recipeList=rList.map((data) => files.fromJson(data)).toList();
    return recipeList;

  }

}
