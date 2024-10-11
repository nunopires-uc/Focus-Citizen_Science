import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:projecto_fcs/pages/StorageService.dart';
import 'package:uuid/uuid.dart';

class CommunityPoll extends StatefulWidget {
  final String ProjectID;
  const CommunityPoll({Key? key,
    required this.ProjectID
  }) : super(key: key);

  @override
  State<CommunityPoll> createState() => _CommunityPollState();
}

class _CommunityPollState extends State<CommunityPoll> {
  List<Widget> polls = <Widget>[];
  List<String?> filesPath = [];
  List<String> questions = [];
  List<TextEditingController> _controllers = [];
  final myController = TextEditingController();
  File? image;

  Future pickImage() async{
    try{
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if(image == null) {
        ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(content: Text("No File has been picked"), duration: Duration(milliseconds: 300),),);
        return;
      }
      final imageTemporary = File(image.path);
      setState(() => this.image = imageTemporary);
    }on PlatformException catch (e){
      print('Failed to pick image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Container(
        padding: EdgeInsets.all(20.0),
        child: new ListView.builder(itemBuilder: (context, index){
          Widget widget = polls.elementAt(index);
          return widget;
        }, itemCount: polls.length,)),
        floatingActionButton: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 0.0),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: new FloatingActionButton(onPressed: (){
                  print(questions);
                  print(image?.path);

                  if(filesPath[0] == null){
                    filesPath[0] = image!.path;
                  }
                  print(filesPath);

                  //Navigator.of(context).pop(filesPath);

                  final Storage storage = Storage();
                  CollectionReference refc = FirebaseFirestore.instance.collection('communitypolls');

                  // String filePath, String fileName, String ProjectFolder

                  const snackBar = SnackBar(
                    content: const Text('Poll added sucessfully'),);

                  for(int i=0;i<filesPath.length;i++){
                    storage.uploadFile(filesPath[i].toString(), filesPath[i].toString().split("/").last, widget.ProjectID + '/communitypolls/').then((String url){
                      refc.doc().set({
                        'answers': FieldValue.arrayUnion([]),
                        'image': url,
                        'projectID': widget.ProjectID,
                        'question': questions[i].toString(),
                        'type': 'image',
                      }).then((value) => {print('Poll added'), ScaffoldMessenger.of(context).showSnackBar(snackBar)}).catchError((error) =>
                          print('Failed to add project: $error')
                      );
                    });
                  }
                }, child: new Icon(Icons.save),),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: new FloatingActionButton(onPressed: (){
                final controller = TextEditingController();
              polls.add(new Container(
                child: Row(
                  children: [
                    Expanded(
                        flex: 3,
                        child: TextField(
                          controller: controller,
                          //_controllers[polls.length+1],
                          decoration: InputDecoration(hintText: 'Write your question here ${polls.length+1}'),
                        )
                    ),
                    Expanded(
                      flex: 1,
                      child: TextButton(
                      child: Text('upload',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500
                        ),
                      ),
                      style: ButtonStyle(shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.blue)
                          )
                      ),
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                      ),
                      onPressed: () async {
                        //polls.add(new TextField(decoration: InputDecoration(hintText: 'Hint ${polls.length+1}'),));
                        setState(() {
                          pickImage();
                          filesPath.add(image?.path);
                          questions.add(controller.text);
                        });
                      },
                  ),
                    ),]
                ,)
              ));



              setState(() {


              });
          }, child: new Icon(Icons.add),
      ),
            ),
        ]),
    );
  }
}
