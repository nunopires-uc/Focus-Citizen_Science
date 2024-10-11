import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadFiles extends StatefulWidget {

  final String ProjectId;
  final String ProjectName;
  const DownloadFiles({Key? key,
    required this.ProjectId,
    required this.ProjectName,
  }) : super(key: key);

  @override
  State<DownloadFiles> createState() => _DownloadFilesState();
}

class _DownloadFilesState extends State<DownloadFiles> {
  late Future<ListResult> futureFiles;
  late DocumentSnapshot docSnap;

  @override
  void initState(){
    super.initState();
    futureFiles = FirebaseStorage.instance.ref('/' + widget.ProjectId + '/data').listAll();
    setProj();
  }

  void setProj() async{
    DocumentReference proj = FirebaseFirestore.instance.collection('projects').doc(widget.ProjectId);
    docSnap = await proj.get();
  }

  Future downloadFile(Reference ref) async{
    final url = await ref.getDownloadURL();

    final Dio dio = Dio();

    var resultperm = await Permission.storage.request();
    Directory? directory;
    if(resultperm == PermissionStatus.granted) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.manageExternalStorage
      ].request();
      directory = await getExternalStorageDirectory();
      print(directory?.path);
      String newPath = '';
      List<String> folders = directory!.path.split("/");
      for(int i=1;i<folders.length;i++){
        String folder = folders[i];
        if(folder != "Android"){
          newPath += '/' + folder;
        }else{
          break;
        }
      }
      newPath = newPath + '/' + widget.ProjectName.replaceAll(' ', '_');

      directory = Directory(newPath);
      print(' :: ' + directory.path);

      if(!await directory.exists()){
        await Directory(directory.path).create(recursive: true);
      }

      if(await directory.exists()) {
        File saveFile = File(directory.path+'/'+ref.name.replaceAll("\'", ' '));
        await dio.download(url, saveFile.path);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Downloaded ${ref.name}'),)
        );
      }
    }
  }

  final myController = TextEditingController();
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
        title: Text('Archive - Download Files'),
    ),
    body: FutureBuilder<ListResult>(
      future: futureFiles,
      builder: (context, snapshot){
        if(snapshot.hasData){
          final files = snapshot.data!.items;
          print(docSnap['contributions']);
          List<String> contributions = List<String>.from(docSnap['contributions']);
          List<String> fnames = contributions.map((e) => e.split('_')[1].replaceAll('\'', '')).toList();
          print(fnames);
          print('uik->' + files.toString());

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                    itemCount: files.length,
                    itemBuilder: (context, index) {
                      final file = files[index];
                      print('::' + file.name);
                      var i = fnames.indexOf(file.name);
                      print('--_ '+i.toString());
                      if(i >= 0){
                        print(contributions[i].split('_')[0]);
                        return ListTile(
                          title: //Text(),
                          SelectableText(
                            file.name + ' by ' + contributions[i].split('_')[0],
                            style: TextStyle(color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 16
                            ),
                            onTap: () => print('Tapped'),
                            toolbarOptions: ToolbarOptions(copy: true, selectAll: true,),
                            showCursor: true,
                            cursorWidth: 2,
                            cursorColor: Colors.red,
                            cursorRadius: Radius.circular(5),
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.download, color: Colors.blue,
                            ),
                            onPressed: (){
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Downloading...'),)
                              );
                              downloadFile(file);
                            },
                          ),
                        );
                      }
                      return Container();
                    }),
              ),
              Row(
                children: [
                  Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: myController,
                          decoration: InputDecoration(hintText: 'Write user id'),
                        ),
                      )
                  ),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 48,
                      child: Container(
                        padding: const EdgeInsets.only(left:8.0, right: 8.0, top: 0, bottom: 0),
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            onPrimary: Colors.black,
                            minimumSize: Size(double.infinity, 50),
                          ),
                          icon: FaIcon(
                            FontAwesomeIcons.globe, color: Colors.blue,),
                          //FaIcon(FontAwesomeIcons.google, color: Colors.red,),
                          label: Text('Ban User'),
                          onPressed: () {
                            print(myController.text);
                            var list = [myController.text];
                            FirebaseFirestore.instance.collection('projects').doc(widget.ProjectId.toString()).update({'banlist': FieldValue.arrayUnion(list)});

                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('User banned'),)
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        }else if(snapshot.hasError){
          return const Center(child: Text('Error occured'),);
        }else{
          return const Center(child: CircularProgressIndicator(),);
        }
      }
    ),
  );
}
