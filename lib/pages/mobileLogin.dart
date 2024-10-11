import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../controller/onStart.dart';
import '../controller/optimizedText.dart';
import 'HomeScreenMobile.dart';

class mobileLogin extends StatefulWidget {
  const mobileLogin({Key? key}) : super(key: key);

  @override
  State<mobileLogin> createState() => _mobileLoginState();
}

class _mobileLoginState extends State<mobileLogin> {

  ui_loginPage UI_loginPage = new ui_loginPage.empty();
  @override
  Widget build(BuildContext context) {
    final _pwController = TextEditingController();
    final _emailController = TextEditingController();
    UI_loginPage.getVersion();

    Future signIn() async{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailController.text.trim(), password: _pwController.text.trim());
    }

    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          if(snapshot.hasData){
            onStart onstart = onStart(uid: FirebaseAuth.instance.currentUser?.uid);
            onstart.getGlobalVersion();
            return HomePageMobile();
          }else{
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    child: Center(
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Center(
                                heightFactor: 1,
                                child: Lottie.network('https://assets10.lottiefiles.com/packages/lf20_au98facn.json'),
                              ),
                              SizedBox(height: 8,),
                              Container(
                                padding: const EdgeInsets.only(left:8.0, right: 8.0, top: 0, bottom: 0),
                                alignment: Alignment.center,
                                child: Text(
                                  UI_loginPage.lblAppTitle,
                                  style: TextStyle(
                                    color: Colors.blue,
                                      fontWeight: FontWeight.w500,
                                    fontSize: 48,
                                    fontFamily: 'montserrat',
                                  ),
                                ),
                              ),
                              SizedBox(height: 8,),
                              Padding(
                                padding: const EdgeInsets.only(left:8.0, right: 8.0, top: 0, bottom: 0),
                                child: TextField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Email',
                                      hintText: 'email@email.com'
                                  ),
                                ),
                              ),
                              SizedBox(height: 8,),
                              Padding(
                                padding: const EdgeInsets.only(left:8.0, right: 8.0, top: 0, bottom: 0),
                                child: TextField(
                                  controller: _pwController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Password',
                                      hintText: '********'
                                  ),
                                ),
                              ),
                              SizedBox(height: 4,),
                              SizedBox(
                                height: 48,
                                child: Container(
                                  padding: const EdgeInsets.only(left:8.0, right: 8.0, top: 0, bottom: 0),
                                  width: double.infinity,
                                  child: TextButton(
                                    child: Text('Login',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500
                                      ),
                                    ),
                                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue)),
                                    onPressed: () async {
                                      signIn();
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(height: 4,),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 5,
                                    child: TextButton(
                                        child: Text('New User? Signup'),
                                        onPressed: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => const mobileSignUp()));
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
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          }
        }
      ),
    );
  }
}

class mobileSignUp extends StatefulWidget {
  const mobileSignUp({Key? key}) : super(key: key);

  @override
  State<mobileSignUp> createState() => _mobileSignUpState();
}

class _mobileSignUpState extends State<mobileSignUp> {
  DateTime? _dateTime;

  @override
  Widget build(BuildContext context) {
    final _pwController = TextEditingController();
    final _emailController = TextEditingController();
    final _nameController = TextEditingController();
    final _organizationController = TextEditingController();
    CollectionReference users = FirebaseFirestore.instance.collection('xusers');
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(left:10.0, right: 10.0, top: 0, bottom: 0),
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
                              SizedBox(height: 16,),
                              TextField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Name',
                                ),
                              ),
                              SizedBox(height:16,),
                              TextField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Email',
                                ),
                              ),
                              SizedBox(height: 16,),
                              TextField(
                                controller: _pwController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Password',
                                ),
                              ),
                              SizedBox(height: 16,),
                              TextField(
                                controller: _organizationController,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Organization',
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16,),
                        SizedBox(
                          height: 48,
                          child: Container(
                            padding: const EdgeInsets.only(left:10.0, right: 10.0, top: 0, bottom: 0),
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
                                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                    email: _emailController.text.trim(),
                                    password: _pwController.text.trim(),
                                  );
                                  await FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailController.text.trim(), password: _pwController.text.trim());
                                  setState(() {
                                    users.doc(FirebaseAuth.instance.currentUser?.uid).set(
                                      {'name': _nameController.text.trim(), 'organization': _organizationController.text.trim(), 'favourites' : FieldValue.arrayUnion([]), 'contributions' : FieldValue.arrayUnion([])}
                                    ).then((value) => Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePageMobile()))).catchError((error) => print('Failed to add user: $error'));
                                    //users.add({'name': _nameController.text.trim(), 'age': age}).then((value) => print('User added')).catchError((error) => print('Failed to add user: $error'));
                                  });
                                }
                            ),
                          ),
                        ),
                      ],
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



  
  
  