import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:projecto_fcs/controller/auth_service.dart';
import 'package:projecto_fcs/controller/google_sign_in.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projecto_fcs/main.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _emailTextEditor = TextEditingController();
  TextEditingController _pwTextEditor = TextEditingController();

  final formkey = GlobalKey<FormState>();
  //final _auth = FirebaseAuth.instance;

  String email = '';
  String password = '';
  bool isloading = false;
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: isloading ? Center(
        child: CircularProgressIndicator(),
      )  : Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Container(
                width: screenSize.width/2,
                height: screenSize.height/1.2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30.0),
                  child: Card(
                    elevation: 8,
                    shadowColor: Colors.grey,
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(left:100.0, right: 100.0, top: 0, bottom: 0),
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 32,),
                              const Text(
                                'Sign Up',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 48),
                              ),
                              SizedBox(
                                height: 224,
                                child: Lottie.network('https://assets7.lottiefiles.com/packages/lf20_dellwkg7.json'),
                              ),
                              SizedBox(height:16,),
                              TextField(
                                controller: _emailTextEditor,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Email',
                                ),
                              ),
                              SizedBox(height: 16,),
                              TextField(
                                controller: _pwTextEditor,
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Password',
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16,),
                        SizedBox(
                          height: 48,
                          child: Container(
                            padding: const EdgeInsets.only(left:100.0, right: 100.0, top: 0, bottom: 0),
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.blue[300],
                                onPrimary: Colors.black,
                                minimumSize: Size(double.infinity, 50),
                              ),
                              icon: FaIcon(FontAwesomeIcons.check, color: Colors.white,),
                              label: Text('Create Account'),
                              onPressed: () async {
                                //context.read<AuthenticationService>().signIn(email: _emailTextEditor.text.trim(), password: _pwTextEditor.text.trim());
                                //SignUpService().signUp(_emailTextEditor.text.trim(), _pwTextEditor.text.trim());
                              }
                            ),
                          ),
                        ),
                      ],
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
  /*
  Future signIn() async{
    //https://www.youtube.com/watch?v=oJ5Vrya3wCQ
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailTextEditor.text, password: _pwTextEditor.text);

  }*/
}

