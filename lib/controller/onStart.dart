import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class onStart{

  String? uid;
  double? globalVersion;

  onStart({required this.uid}){
    updateVersion();

  }

  Future<void> updateVersion() async{
    final prefs = await SharedPreferences.getInstance();
    globalVersion = prefs.getDouble('_globalversion') ?? 1.0;
  }

  Future<void> getGlobalVersion() async{
    final prefs = await SharedPreferences.getInstance();
    DocumentSnapshot versionController = await FirebaseFirestore.instance.collection('app_config').doc('versionController').get();
    DocumentSnapshot currentUser = await FirebaseFirestore.instance.collection('xusers').doc(uid).get();

    await prefs.setString('_user', currentUser['name']);
    await prefs.setString('_org', currentUser['organization']);

    if(versionController['version'] > globalVersion){
      //Call all page updaters
      await prefs.setString('_globalversion', versionController['version']);
    }

  }

}
