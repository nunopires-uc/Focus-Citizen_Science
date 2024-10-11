import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import '../models/FirebaseFile.dart';
import 'dart:io';

class DownloadApi{
  static Future<List<String>> getDownloadLinks(List<Reference> refs) =>
      Future.wait(refs.map((ref) => ref.getDownloadURL()).toList());


  static Future<List<FirebaseFile>> listAll(String path) async{
    final ref = FirebaseStorage.instance.ref(path);
    final result = await ref.listAll();

    final urls = await getDownloadLinks(result.items);

    return urls.asMap().map((key, value){
      final ref = result.items[key];
      final name = ref.name;
      final file = FirebaseFile(ref: ref, name: name, url: value);
      return MapEntry(key, file);
    }).values.toList();
  }

  static Future downloadFile(Reference ref) async{
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/${ref.name}');

    await ref.writeToFile(file);




  }
}