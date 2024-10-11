import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Storage{
  final firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;


  Future<String> uploadFile(String filePath, String fileName, String ProjectFolder) async{
    File file = File(filePath);
    try{
      await storage.ref(ProjectFolder + '/$fileName').putFile(file);
      return await storage.ref(ProjectFolder + '/$fileName').getDownloadURL();
    }on firebase_core.FirebaseException catch (e){
      print(e);
    }
    return '';
  }

  Future<firebase_storage.ListResult> listFiles() async{
    firebase_storage.ListResult results = await storage.ref('test').listAll();
    results.items.forEach((firebase_storage.Reference ref) {
      print('Found File: $ref');
    });
    return results;
  }

  Future<String> downloadURL(String imageName, String ProjectFolder) async{
    String downloadURL = await storage.ref('$ProjectFolder/$imageName').getDownloadURL();
    return downloadURL;
  }

}