import 'package:flutter/material.dart';


class GradientButton extends StatelessWidget {
  final String text;
  final Color c1;
  final Color c2;
  final Color c3;

  GradientButton(this.text, this.c1, this.c2, this.c3);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    c1, c2, c3,
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.all(16.0),
                primary: Colors.white,
                textStyle: const TextStyle(fontSize: 20),
              ),
              onPressed: () {},
              child: Text(text),
            ),
          ),
        ],
      ),
    );
  }
}
