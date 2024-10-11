//import 'package:audioplayers/audioplayers.dart';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:expandable/expandable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:projecto_fcs/controller/DownloadApi.dart';
import 'package:projecto_fcs/models/FirebaseFile.dart';
import 'package:projecto_fcs/pages/communitypoll.dart';
import 'package:projecto_fcs/pages/pdfViewer.dart';
import 'package:projecto_fcs/widgets/buttons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart'as http;
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:native_pdf_view/native_pdf_view.dart';


import 'HomeScreenMobile.dart';
import 'PaintingApp.dart';
import 'downloadFiles_1b1.dart';

class ProjectPage extends StatefulWidget {
  const ProjectPage({Key? key, required this.ProjectName}) : super(key: key);

  final String ProjectName;


  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {




  final pdfController = PdfController(
      document: PdfDocument.openAsset('asses/pdf/sample.pdf'),
  );




  /*Widget pdfView() => PdfView(controller: pdfController,
  );*/

  @override
  Widget build(BuildContext context) {

    Future<bool> saveFile(String url, String fileName) async{
      Directory? directory;
      try{
        if(!await Permission.storage.isGranted){
          var result = await Permission.storage.request();
          if(result == PermissionStatus.granted){
            directory = await getExternalStorageDirectory();
            print(directory?.path);
          }else{
            return false;
          }
        }else{
          directory = await getExternalStorageDirectory();
          print(directory?.path);
        }

      }catch(e){

      }
      return false;
    }

    downloadFile() async{
      setState(() {

      });

      bool downloaded = await saveFile('https://firebasestorage.googleapis.com/v0/b/projeto-fcs.appspot.com/o/1%2Fdata%2Fpassaro.jpg?alt=media&token=f00ee586-1863-460d-b9c6-a5428af3c589', 'passaromaluco.jpg');
    }

    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 50.0),
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: screenSize.height/6,
                child: Card(
                  /*child: ListTile(
                    //title: Text("Zebra Photogrammetry"),
                  ),*/
                  elevation: 8,
                  shadowColor: Colors.grey,
                  child: Stack(
                    //fit: StackFit.expand,
                    children: <Widget>[

                      //Image.asset("assets/images/zebra.jpg",
                          //fit: BoxFit.fill),
                      /*Image.network('https://undark.org/wp-content/uploads/2020/01/GettyImages-981130046.jpg', fit: BoxFit.fill,
                      width: double.infinity,
                        fit:

                      )*/
                      Image(
                        image: NetworkImage('https://undark.org/wp-content/uploads/2020/01/GettyImages-981130046.jpg'),
                        alignment: Alignment.center,
                        width: double.infinity,
                        fit: BoxFit.fill,
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
                            child: Text("this.ProjectName", style: TextStyle(
                              color: Colors.white,
                              fontSize: 32
                            ),
                              )
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProjectPageMobile extends StatefulWidget {
  final String ProjectName;
  final int ProjectId;
  final String Organization;
  final String author_id;
  final String description;
  final String imageURL;
  final String author;
  final List<String> fileTypes;
  final List<String> topics;
  final List<String> banlist;
  const ProjectPageMobile({Key? key,
    required this.ProjectName,
    required this.Organization,
    required this.author_id,
    required this.description,
    required this.imageURL,
    required this.fileTypes,
    required this.topics,
    required this.author,
    required this.ProjectId,
    required this.banlist,
  }) : super(key: key);


  @override
  State<ProjectPageMobile> createState() => _ProjectPageMobileState();
}

class _ProjectPageMobileState extends State<ProjectPageMobile> with TickerProviderStateMixin {
  bool _isSelected = true;
  List<PlatformFile>? pickedFiles;
  List<File>? files;
  List<String> nameFiles = [];
  final user = FirebaseAuth.instance.currentUser!;

  //AudioPlayer audioPlayer = AudioPlayer();
  //bool isPlaying = false;
  //Duration duration = Duration.zero;
  //Duration position = Duration.zero;

  Future selectFileImage(String ProjectID) async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg']
    );
    if (result == null) return;
    files = result!.paths.map((path) => File(path!)).toList();
    uploadFile(ProjectID);
  }

  Future selectFileAudio(String ProjectID) async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['mp3', 'wav', 'ogg']
    );
    if (result == null) return;
    files = result!.paths.map((path) => File(path!)).toList();
    uploadFile(ProjectID);
  }


  Future uploadFile(String ProjectID) async{
    var path;
    var file;
    var fileName;

    files?.forEach((itemFile){
      file = File(itemFile!.path!);
      path = '$ProjectID/data/${file.toString().split('/').last.replaceAll('\'', '')}';
      print(path);
      fileName = '${file.toString().split('/').last}';
      nameFiles.add(user.uid+'_'+fileName);
      print(user.uid+'_'+fileName);
      final ref = FirebaseStorage.instance.ref().child(path);
      print(nameFiles.toString());
      ref.putFile(file);
    });

    print('kazzinski');
    print(nameFiles.toString());
    FirebaseFirestore.instance.collection('projects').doc(widget.ProjectId.toString()).update(
        {'contributions': FieldValue.arrayUnion(nameFiles!)}
    ).then((value) => ScaffoldMessenger.of(context).showSnackBar(snackBar));

  }
  TabController? _tabController;

  static const int _initialPage = 2;
  int _actualPageNumber = _initialPage, _allPagesCount = 0;
  bool isSampleDoc = true;
  late PdfControllerPinch _pdfController;
  final myController = TextEditingController();

  void initState() {

    _pdfController = PdfControllerPinch(
      document: PdfDocument.openAsset('assets/hello.pdf'),
      initialPage: _initialPage,
    );

    super.initState();
    _tabController = TabController(vsync: this, length: 1);

  }

  void dispose(){
    _pdfController.dispose();
    super.dispose();
  }
  double _tabHeight = 175;

  static const snackBar = SnackBar(
    content: const Text('Data uploaded sucessfully'), duration: Duration(seconds: 3),);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: SizedBox(
                  child: Image.network(widget.imageURL),
                ),
              ),
              Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                          child: Text(widget.ProjectName, textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                          child: Text('author: ' + widget.author, textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 12,
                            ),
                          ),
                        ),
                        SizedBox(height: 1,),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                          child: Text('Organization: ' + widget.Organization, textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 12,
                            ),
                          ),
                        ),
                        SizedBox(height: 1,),
                        Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                            child: Text('Topics: ' + widget.topics.toString().replaceAll('[', '').replaceAll(']', ''),
                              style: TextStyle(
                                fontWeight: FontWeight.w300, fontSize: 12,
                              ),
                            )
                        ),
                        SizedBox(height: 8,)
                      ],
                    ),
                  ],
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: TabBar(
                            controller: _tabController,
                            labelColor: Colors.black,
                            unselectedLabelColor: Colors.grey,
                            tabs: [
                              Tab(text: 'Description',),
                              //Tab(text: 'Articles'),
                              //Tab(text: 'Project Data'),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        width: double.maxFinite,
                        height: _tabHeight,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 4,),
                                      Text(widget.description, textAlign: TextAlign.justify,
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      )
                                    ],
                                  )
                                ),
                              ),

                              /*Container(child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          textStyle: const TextStyle(fontSize: 16),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => PdfViewer()));
                                        },
                                        child: const Text('• how_to_pdf1.pdf'),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          textStyle: const TextStyle(fontSize: 16),
                                        ),
                                        onPressed: () {},
                                        child: const Text('• philosophy101.pdf'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),*/
                              /*Container(child: Container(
                                alignment: Alignment.topLeft,
                                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                                child: Text('Currently accepting these files: png, jpeg, raw, dif', textAlign: TextAlign.justify,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 16,
                                  ),
                                ),
                              ),),*/
                          ],//
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 1,),
              /*
              SizedBox(
                height: 48,
                child: Container(
                  padding: const EdgeInsets.only(left:8.0, right: 8.0, top: 0, bottom: 0),
                  width: double.infinity,
                  child: TextButton(
                    child: Text('debug - Contribute',
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
                      //selectPDF();
                      Navigator.push(context, MaterialPageRoute(builder: (context) => CanvasPaint()));
                    },
                  ),
                ),
              ),*/
              SizedBox(height: 1,),
              if (widget.author_id == user.uid) ... [
                SizedBox(
                  height: 48,
                  child: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(left:8.0, right: 8.0, top: 0, bottom: 0),
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        onPrimary: Colors.black,
                        minimumSize: Size(double.infinity, 50),
                      ),
                      icon: FaIcon(
                        FontAwesomeIcons.edit, color: Colors.white,),
                      //FaIcon(FontAwesomeIcons.google, color: Colors.red,),
                      label: Text('Edit description'),
                      onPressed: () {
                        print(widget.author_id);
                        print(widget.ProjectId);
                        print(user.uid);

                        final controller = TextEditingController();
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Update description'),
                                content: TextField(
                                  onChanged: (value) {
                                    setState(() {
                                      //valueText = value;
                                    });
                                  },
                                  controller: controller,
                                  decoration: InputDecoration(hintText: "Write your project description"),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('Update',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500
                                      ),
                                    ),
                                    style: ButtonStyle(shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(18.0),
                                            side: BorderSide(color: Colors.red)
                                        )
                                    ),
                                      backgroundColor: MaterialStateProperty.all(Colors.red),
                                    ),
                                    onPressed: () async {
                                      print(controller.text.toString());

                                      if(!controller.text.isEmpty){
                                        FirebaseFirestore.instance.collection('projects').doc(widget.ProjectId.toString()).update({'description': controller.text.toString()});
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => ProjectPageMobile(
                                              author: widget.author,
                                              description: controller.text.toString(),
                                              fileTypes: widget.fileTypes,
                                              ProjectId: widget.ProjectId,
                                              topics: widget.topics,
                                              author_id: widget.author_id,
                                              imageURL: widget.imageURL,
                                              Organization: widget.Organization,
                                              ProjectName: widget.ProjectName, banlist: widget.banlist,)));

                                        const snackBar = SnackBar(
                                          content: const Text('Description modified'),);
                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      }
                                      setState(() {
                                      });
                                    },
                                  )
                                ],
                              );
                            });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 24,),
                SizedBox(
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
                        FontAwesomeIcons.atom, color: Colors.blue,),
                      //FaIcon(FontAwesomeIcons.google, color: Colors.red,),
                      label: Text('Create Community Poll'),
                      onPressed: () {
                        print(widget.author_id);
                        print(widget.ProjectId);
                        print(user.uid);
                        Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CommunityPoll(ProjectID: widget.ProjectId.toString(),)));
                      },
                    ),
                  ),
                ),
                SizedBox(height: 4,),
                SizedBox(
                  height: 48,
                  child: Container(
                    padding: const EdgeInsets.only(left:8.0, right: 8.0, top: 0, bottom: 0),
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        onPrimary: Colors.black,
                        minimumSize: Size(double.infinity, 50),
                      ),
                      icon: FaIcon(
                        FontAwesomeIcons.arrowDown, color: Colors.white,),
                      //FaIcon(FontAwesomeIcons.google, color: Colors.red,),
                      label: Text('Download Project Data'),
                      onPressed: () async {
                        print(widget.author_id);
                        print(widget.ProjectId);
                        print(user.uid);

                        DocumentReference polls = FirebaseFirestore.instance.collection('projects').doc(widget.ProjectId.toString());
                        DocumentSnapshot docPoll = await polls.get();
                        List<String> contrib = List<String>.from(docPoll['contributions']);
                        const snackBar = SnackBar(
                          content: const Text('There is no data to Download'),);

                        const snackBarDownload = SnackBar(
                          content: const Text('Downloading...'),);
                        if(contrib.length == 0){
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }else{


                          //await FlutterDownloader.initialize();


                          /*


                          for(int i=0;i<urls.length;i++){
                            final refx = result.items[i];
                            print(refx);
                            final dir = await getApplicationDocumentsDirectory();
                            final file = File('${dir.path}/${refx.name}');
                            print('Documents/${refx.name}');
                            print(await refx.writeToFile(file));
                          }
                          */

                          final ref = FirebaseStorage.instance.ref(widget.ProjectId.toString()+'/data');
                          final result = await ref.listAll();

                          final urls = await DownloadApi.getDownloadLinks(result.items);
                          print(urls.toString());


                          Directory? directory;
                          try{
                            //Permission.manageExternalStorage

                            //!await Permission.storage.isGranted
                            if(!await Permission.storage.isGranted){

                              var resultperm = await Permission.storage.request();
                              if(resultperm == PermissionStatus.granted){

                                Map<Permission, PermissionStatus> statuses = await [
                                  Permission.manageExternalStorage
                                ].request();

                                print(statuses);

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
                                print(newPath);
                                directory = Directory(newPath);
                                print(directory.path);

                                if(!await directory.exists()){
                                  await Directory(directory.path).create(recursive: true);
                                }

                                final Dio dio = Dio();

                                if(await directory.exists()){
                                  if(await directory.exists()){
                                    for(int i=0;i<urls.length;i++){
                                      final name = result.items[i].name;
                                      File saveFile = File(directory.path+'/'+name);
                                      await dio.download(urls[i], saveFile.path);
                                    }
                                  }

                                  if(widget.fileTypes.contains('gps')){
                                    //QuerySnapshot snap = await FirebaseFirestore.instance.collection('projects').get();

                                    //List<String> files = List<String>.from(snap.docs.);
                                    //newid = snap.docs.last['id'] + 1;

                                    DocumentSnapshot ds = await FirebaseFirestore.instance.collection('projects').doc(widget.ProjectId.toString()).get();
                                    List<String> customData = List<String>.from(ds['custom']);
                                    print(customData.toString());
                                    final File file = File('${directory.path}/custom.txt');
                                    await file.writeAsString(customData.toString());
                                  }
                                }
                              }else{

                              }
                            }else{

                              Map<Permission, PermissionStatus> statuses = await [
                                Permission.manageExternalStorage
                              ].request();

                              print(statuses);

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
                              print(newPath);
                              directory = Directory(newPath);
                              print(directory.path);

                              if(!await directory.exists()){
                                await directory.create(recursive: true);
                              }

                              final Dio dio = Dio();

                              if(await directory.exists()){
                                for(int i=0;i<urls.length;i++){
                                  final name = result.items[i].name;
                                  File saveFile = File(directory.path+'/'+name);
                                  await dio.download(urls[i], saveFile.path);
                                }
                                if(widget.fileTypes.contains('gps')){
                                  DocumentSnapshot ds = await FirebaseFirestore.instance.collection('projects').doc(widget.ProjectId.toString()).get();
                                  List<String> customData = List<String>.from(ds['custom']);
                                  print(customData.toString());
                                  File file = File(directory.path + '/custom.txt');
                                  print(directory.path.toString());
                                  await file.writeAsString(customData.toString());
                                }
                              }
                            }
                          }catch(e){
                            print(e.toString());
                          }
                          ScaffoldMessenger.of(context).showSnackBar(snackBarDownload);
                        }
                        //var ProjectId = docPoll['projectID'];
                        //print(ProjectId);
                      },
                    ),
                  ),
                ),
                SizedBox(height: 4,),
                SizedBox(
                  height: 48,
                  child: Container(
                    padding: const EdgeInsets.only(left:8.0, right: 8.0, top: 0, bottom: 0),
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                        onPrimary: Colors.black,
                        minimumSize: Size(double.infinity, 50),
                      ),
                      icon: FaIcon(
                        FontAwesomeIcons.atom, color: Colors.white,),
                      //FaIcon(FontAwesomeIcons.google, color: Colors.red,),
                      label: Text('Delete Project'),
                      onPressed: () {
                        print(widget.author_id);
                        print(widget.ProjectId);
                        print(user.uid);

                        final controller = TextEditingController();
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Delete project'),
                                content: TextField(
                                  onChanged: (value) {
                                    setState(() {
                                      //valueText = value;
                                    });
                                  },
                                  controller: controller,
                                  decoration: InputDecoration(hintText: "Write the project name"),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: Text('Delete',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500
                                      ),
                                    ),
                                    style: ButtonStyle(shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(18.0),
                                            side: BorderSide(color: Colors.red)
                                        )
                                    ),
                                      backgroundColor: MaterialStateProperty.all(Colors.red),
                                    ),
                                    onPressed: () async {
                                      print(controller.text.toString());
                                      if(controller.text.toString() == widget.ProjectName){

                                        FirebaseFirestore.instance
                                            .collection("projects")
                                            .doc(widget.ProjectId.toString())
                                            .delete()
                                            .then((_) {
                                          print("success!");
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => HomeScreenMobile()));

                                        });

                                      }
                                      setState(() {
                                      });
                                    },
                                  )
                                ],
                              );
                            });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 4,),
                SizedBox(
                  height: 48,
                  child: Container(
                    padding: const EdgeInsets.only(left:8.0, right: 8.0, top: 0, bottom: 0),
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.yellow,
                        onPrimary: Colors.black,
                        minimumSize: Size(double.infinity, 50),
                      ),
                      icon: FaIcon(
                        FontAwesomeIcons.atom, color: Colors.white,),
                      //FaIcon(FontAwesomeIcons.google, color: Colors.red,),
                      label: Text('Archive'),
                      onPressed: () async{
                        print(widget.author_id);
                        print(widget.ProjectId);
                        print(user.uid);

                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DownloadFiles(ProjectId: widget.ProjectId.toString(), ProjectName: widget.ProjectName.toString(),),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 4,)
              ],

              if (widget.fileTypes.contains('gps')) ...[
                Row(
                  children: [
                    Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: myController,
                            decoration: InputDecoration(hintText: 'Write your contribution here'),
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
                            label: Text('Contribute'),
                            onPressed: () {
                              if(!widget.banlist.contains(user.uid)){
                                print(myController.text);
                                print(widget.author_id);
                                print(user.uid);
                                var customValue = [myController.text];
                                FirebaseFirestore.instance.collection('projects').doc(widget.ProjectId.toString()).update({'custom': FieldValue.arrayUnion(customValue)});
                                var list = [user.uid];
                                FirebaseFirestore.instance.collection('projects').doc(widget.ProjectId.toString()).update({'contributions': FieldValue.arrayUnion(list)});
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              }else{
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('You are banned'),),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4,),
              ],
              if(widget.fileTypes.contains('pf')) ...[
                SizedBox(
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
                        FontAwesomeIcons.paintbrush, color: Colors.blue,),
                      label: Text('Contribute Paint File'),
                      onPressed: () async{
                        if(!widget.banlist.contains(user.uid)){
                          print(widget.author_id);
                          print(user.uid);
                          final path = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CanvasPaint(ProjectID: widget.ProjectId,),
                            ),
                          );
                          print(path);
                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('You are banned'),),
                          );
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(height: 4,),
              ],
              if(widget.fileTypes.contains('image')) ...[
                SizedBox(
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
                        FontAwesomeIcons.image, color: Colors.blue,),
                      label: Text('Contribute image'),
                      onPressed: () {
                        print(widget.banlist.toString());
                        if(!widget.banlist.contains(user.uid)) {
                          print(widget.author_id);
                          print(user.uid);
                          selectFileImage(widget.ProjectId.toString());
                          var list = [user.uid];
                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('You are banned'),),
                          );
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(height: 4,),
              ],
               if(widget.fileTypes.contains('audio')) ...[
                SizedBox(
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
                        FontAwesomeIcons.music, color: Colors.blue,),
                      label: Text('Contribute Audio'),
                      onPressed: () {
                        if(!widget.banlist.contains(user.uid)) {
                          print(widget.author_id);
                          print(user.uid);
                          selectFileAudio(widget.ProjectId.toString());
                          var list = [user.uid];
                          FirebaseFirestore.instance.collection('projects').doc(widget.ProjectId.toString()).update({'contributions': FieldValue.arrayUnion(list)});
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('You are banned'),),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ],
              SizedBox(height: 8,),
            ],
          ),
        ),
      ),
    );
  }
}