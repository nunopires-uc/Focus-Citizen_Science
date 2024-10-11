import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:projecto_fcs/controller/google_sign_in.dart';
import 'package:projecto_fcs/widgets/gradientButton.dart';
import 'package:provider/provider.dart';

class DesktopLogin extends StatefulWidget {
  const DesktopLogin({Key? key}) : super(key: key);

  @override
  State<DesktopLogin> createState() => _DesktopLoginState();
}


/*
Color(0xFF0D47A1),
Color(0xFF0D47A1),
Color(0xFF42A5F5),
 */

class _DesktopLoginState extends State<DesktopLogin> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Container(
                //padding: const EdgeInsets.symmetric(horizontal: 20.0),
                width: screenSize.width/1.3,
                height: screenSize.height/1.2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30.0),
                  child: Card(
                    elevation: 8,
                    shadowColor: Colors.grey,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Expanded(
                          flex: 6,
                          child: Center(
                            heightFactor: 3,
                            child: Lottie.network('https://assets10.lottiefiles.com/packages/lf20_au98facn.json'),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 108,),
                              Container(
                                padding: const EdgeInsets.only(left:15.0, right: 25.0, top: 0, bottom: 0),
                                alignment: Alignment.center,
                                //padding: const EdgeInsets.all(10),
                                child: const Text(
                                  'Focus',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 30),
                                ),
                              ),
                              SizedBox(height: 50,),
                              Padding(
                                padding: const EdgeInsets.only(left:15.0, right: 25.0, top: 0, bottom: 0),
                                child: TextField(
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Email',
                                      hintText: 'email@email.com'
                                  ),
                                ),
                              ),
                              SizedBox(height: 8,),
                              Padding(
                                //padding: const EdgeInsets.only(left:15.0, right: 15.0, top: 0, bottom: 0),
                                padding: const EdgeInsets.only(left:15.0, right: 25.0, top: 0, bottom: 0),
                                child: TextField(
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Password',
                                      hintText: '********'
                                  ),
                                ),
                              ),
                              SizedBox(height: 8,),
                              SizedBox(
                                height: 48,
                                child: Container(
                                  padding: const EdgeInsets.only(left:15.0, right: 25.0, top: 0, bottom: 0),
                                  width: double.infinity,
                                  child: TextButton(
                                    child: Text('Login',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500
                                      ),
                                    ),
                                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue)),
                                    onPressed: () {},
                                  ),
                                ),
                              ),
                              SizedBox(height: 4,),
                              SizedBox(
                                height: 48,
                                child: Container(
                                  padding: const EdgeInsets.only(left:15.0, right: 25.0, top: 0, bottom: 0),
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.white,
                                      onPrimary: Colors.black,
                                      minimumSize: Size(double.infinity, 50),
                                    ),
                                    icon: FaIcon(FontAwesomeIcons.google, color: Colors.red,),
                                    label: Text('Sign Up with Google', textAlign: TextAlign.left,),
                                    onPressed: () {
                                      final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
                                      provider.googleLogin();
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(height: 8,),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 5,
                                    child: TextButton(
                                        child: Text('New User? Signup'),
                                        onPressed: () {
                                          print('Pressed');
                                        }
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: TextButton(
                                        child: Text('Forgot your password?'),
                                        onPressed: () {
                                          print('Pressed');
                                        }
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],



                      /*children: <Widget>[
                        Center(
                          heightFactor: 3,
                          child: Lottie.network('https://assets10.lottiefiles.com/packages/lf20_au98facn.json'),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 24,),
                            Container(
                              padding: const EdgeInsets.only(left:15.0, right: 15.0, top: 0, bottom: 0),
                              alignment: Alignment.center,
                              //padding: const EdgeInsets.all(10),
                              child: const Text(
                                'Focus',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 30),
                              ),
                            ),
                            SizedBox(height: 50,),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Email',
                                    hintText: 'email@email.com'
                                ),
                              ),
                            ),
                          ],
                        ),





                        /*Column(
                          children: <Widget>[
                            SizedBox(height: 24,),
                            Container(
                              padding: const EdgeInsets.only(left:15.0, right: 15.0, top: 0, bottom: 0),
                              alignment: Alignment.centerLeft,
                              //padding: const EdgeInsets.all(10),
                              child: const Text(
                                'Focus',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 30),
                              ),
                            ),
                            SizedBox(height: 50,),
                            Padding(
                              //padding: const EdgeInsets.only(left:15.0, right: 15.0, top: 0, bottom: 0),
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: TextField(
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Email',
                                    hintText: 'email@email.com'
                                ),
                              ),
                            ),
                            SizedBox(height: 4,),
                            Padding(
                              //padding: const EdgeInsets.only(left:15.0, right: 15.0, top: 0, bottom: 0),
                              padding: const EdgeInsets.only(left:15.0, right: 15.0, top: 0, bottom: 0),
                              child: TextField(
                                obscureText: true,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Password',
                                    hintText: '********'
                                ),
                              ),
                            ),
                            SizedBox(height: 8,),
                            SizedBox(
                              height: 48,
                              child: Container(
                                padding: const EdgeInsets.only(left:15.0, right: 15.0, top: 0, bottom: 0),
                                width: double.infinity,
                                child: TextButton(
                                  child: Text('Login',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500
                                    ),
                                  ),
                                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue)),
                                  onPressed: () {},
                                ),
                              ),
                            ),
                          ],
                        )*/
                      ],*/
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
