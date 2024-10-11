import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyButtonTheme extends StatefulWidget {
  final String buttonText;
  final FaIcon faIcon;
  final Color mycolor;
  //const ButtonTheme({Key? key, required this.buttonText}) : super(key: key);
  MyButtonTheme({required this.buttonText, required this.faIcon, required this.mycolor});

  @override
  State<MyButtonTheme> createState() => _ButtonThemeState();
}

class _ButtonThemeState extends State<MyButtonTheme> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Container(
        padding: const EdgeInsets.only(left:8.0, right: 8.0, top: 0, bottom: 0),
        width: double.infinity,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            primary: widget.mycolor,
            onPrimary: Colors.black,
            minimumSize: Size(double.infinity, 50),
          ),
          icon: widget.faIcon,
          //FaIcon(FontAwesomeIcons.google, color: Colors.red,),
          label: Text(widget.buttonText),
          onPressed: () {

          },
        ),
      ),
    );
  }
}
