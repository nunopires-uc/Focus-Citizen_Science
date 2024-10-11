import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:projecto_fcs/constants/routes.dart';

class AuthenticationService{
  final FirebaseAuth _firebaseAuth;
  AuthenticationService(this._firebaseAuth);
  //Stream<User> get authStateChanges => _firebaseAuth.idTokenChanges();

  Stream<User?> get authStateChanges => _firebaseAuth.idTokenChanges();
  Future<String?> signIn({required String email, required String password}) async{
    try{
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return "Signed in";
    }on FirebaseAuthException catch(e){
      return e.message;
    }
  }

  Future<String?> signUp({required String email, required String password}) async{
    try{
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return "Signed up";
    }on FirebaseAuthException catch(e){
      return e.message;
    }
  }
}

class SignUpService{
  signUp(String email, String password) async{
    Uri uri = Uri.https(Routes.urlSignUp, "/");
    http.Response response = await http.post(uri, body:
    json.encode(
      {"email" : email,
      "password" : password,
      "returnSecureToken" : true,
      }
    ));

    print(response.body);
  }
}