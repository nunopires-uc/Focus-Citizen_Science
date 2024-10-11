/*
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String?> getUserStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userStatus = prefs.getString('userStatus');
  print("==On Load Check ==");
  print(userStatus);
  return userStatus;
}

Future<bool> setUserStatus(String userStatus) async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('userStatus', userStatus);
  return true;
}


class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {

  @override
  void initState(){
    super.initState();
    loadPage();
  }


  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
 */
