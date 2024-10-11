import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class myCustomForm extends StatefulWidget{
  myCustomFormState createState(){
    return myCustomFormState();
  }
}

class myCustomFormState extends State<myCustomForm>{
  final _formkey = GlobalKey<FormState>();
  var name = '';
  var age = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return Form(
      key: _formkey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.person),
              hintText: 'What\'s your name?',
              labelText: 'Name',
            ),
            onChanged: (value) {
              name = value;
            },
            validator: (value) {
              if (value == null || value.isEmpty){
                return 'Please enter some text';
              }
              return null;
            },
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: Icon(Icons.person),
              hintText: 'What\'s your Age?',
              labelText: 'Age',
            ),
            onChanged: (value) {
              age = int.parse(value);
            },
            validator: (value) {
              if (value == null || value.isEmpty){
                return 'Please enter some text';
              }
              return null;
            },
          ),
          SizedBox(height: 10,),
          Center(
            child: ElevatedButton(
              onPressed: () {
                if(_formkey.currentState!.validate()){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Sending Data to Cloud Firestore'),
                    ),
                  );
                  users.add({'name': name, 'age': age}).then((value) => print('User added')).catchError((error) => print('Failed to add user: $error'));
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}