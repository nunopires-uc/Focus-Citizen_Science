import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool isWeb;
    try{
      if(Platform.isAndroid) {
        isWeb = false;
      } else {
        isWeb = true;
      }
    } catch(e){
      isWeb = true;
    }

    if((Platform.isAndroid) || (width < 600)){
      return Container(
        child: Text("Android"),
      );
    }else if(isWeb){
      return Container(
        child: Text("Web"),
      );
    }
    return Container(child: Text("Error"),);
  }
}

