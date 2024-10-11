import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:projecto_fcs/controller/CardProvider.dart';
import 'package:projecto_fcs/pages/insertDataFirestore.dart';
import 'package:projecto_fcs/pages/mobileLogin.dart';
import 'package:provider/provider.dart';

Future <void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'Projeto-FC2',
      options: FirebaseOptions(
        apiKey: "AIzaSyDVau_oe7ihGPMFpLJrsWcvDaSAmpNMdTs",
        appId: "1:365130914640:web:8e08a46c837bd17829ea55",
        messagingSenderId: "365130914640",
        projectId: "projeto-fcs",
      ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (context) => CardProvider(),
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Focus',
      home: mobileLogin()
    ),
  );
}
