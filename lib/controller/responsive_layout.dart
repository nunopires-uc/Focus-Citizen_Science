import 'package:flutter/material.dart';
import 'dart:io' show Platform;



class ResponsiveLayout extends StatelessWidget {

  final Widget mobileBody;
  final Widget desktopBody;


  ResponsiveLayout({required this.mobileBody, required this.desktopBody});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) {
          if((Platform.isAndroid) || (constraints.maxWidth < 600)){
            return mobileBody;
          }else{
            return desktopBody;
          }
        });
  }
}