import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:projecto_fcs/pages/StorageService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HomeScreenMobile.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


class insertProjectPage extends StatefulWidget {
  const insertProjectPage({Key? key}) : super(key: key);
  @override
  State<insertProjectPage> createState() => _insertProjectPageState();
}

class _insertProjectPageState extends State<insertProjectPage> {

  File? image;
  Future getImage() async{
    final results = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg'],
    );
    if(results == null){
      ScaffoldMessenger.of(this.context).showSnackBar(SnackBar(content: Text("No File has been picked"), duration: Duration(milliseconds: 300),),);
    }
    final path = results?.files.single.path!;
    final fileName = results?.files.single.name;
    print(path);
    print(fileName);
  }

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

  bool _isSelectedWeight = false;
  bool _isSelectedPDF = false;
  List<PlatformFile>? pickedFiles;
  List<File>? filesWeigtht;
  List<File>? filesPDF;
  final user = FirebaseAuth.instance.currentUser!;

  Future selectWeight() async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) {
      _isSelectedWeight = false;
      return;
    }else{
      _isSelectedWeight = true;
    }
    filesWeigtht = result!.paths.map((path) => File(path!)).toList();
    //uploadFile();
  }

  Future selectPDF() async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['pdf']
    );
    if (result == null) {
      _isSelectedPDF = false;
      return;
    }else{
      _isSelectedPDF = true;
    }
    filesPDF = result!.paths.map((path) => File(path!)).toList();
    //uploadFile();
  }


  Future uploadFile(String projectName, String Folder) async {
    var path;
    var file;
    filesWeigtht?.forEach((itemFile) {
      file = File(itemFile!.path!);
      path = '${projectName}/${Folder}/${file
          .toString()
          .split('/')
          .last}';
      final ref = FirebaseStorage.instance.ref().child(path);
      ref.putFile(file);
    });
  }

  late final File img;
  final _ProjectNameController = TextEditingController();
  final _DescriptionController = TextEditingController();
  final CustomFileController = TextEditingController();
  bool _catImage = false;
  bool _catAudio = false;
  bool _GPSFile = false;
  bool _paintFile = false;
  final results = null;
  var files = [];
  List<String> topics = ['Science', 'Biology', "Physics", 'Machine Learning', 'Math', 'Philosophy', 'Geology'];
  List<String>? selectedTopics = [];
  List<Widget> choices = [];
  Color colorChoiceChip = Colors.blue;
  String? StringcustomFiles;
  String? _name, _organization;
  List<Widget> polls = <Widget>[];

  bool imgInserted = false, nameInserted = false, descriptionInserted = false;

  CollectionReference xproj = FirebaseFirestore.instance.collection('xproj');
  List<String> fsTopics = <String>[];

  getdata() async{
    await FirebaseFirestore.instance.collection('app_config').doc('topics').get().then((value){
      setState(() {
        List.from(value.data()!['names']).forEach((element){
          String data = element;
          fsTopics.add(data);
        });
        print(fsTopics.toString());
      });
    });
  }

  Future<void> getSharedPrefs() async{
    final prefs = await SharedPreferences.getInstance();
    _name = prefs.getString('_user');
    _organization = prefs.getString('_org');
    setState((){});
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      getdata();
      getSharedPrefs();
    });

  }

  List<String> listOfWidgets(List<String> item) {
    List<String> list = <String>[];
    for (var i = 0; i < item.length; i++) {
      list.add(item[i]);
    }
    return list;
  }

  Future<String?> openDialog() => showDialog<String>(context: this.context, builder: (context) => AlertDialog(
    title: Text('Custom File Extensions'),
    content: TextField(
      decoration: InputDecoration(hintText: 'Example: csv,diff,doc'),
      controller: CustomFileController,
    ),
    actions: [
      TextButton(onPressed: (){
        Navigator.of(context).pop(CustomFileController.text);
      }, child: Text('SUBMIT'))
    ],
  ),);

  static const bodyStyle = TextStyle(fontSize: 19.0);

  static const pageDecoration = const PageDecoration(
    titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
    bodyTextStyle: bodyStyle,
    bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
    pageColor: Colors.white,
    imagePadding: EdgeInsets.zero,
  );

  @override
  Widget build(BuildContext context) => SafeArea(
    child: IntroductionScreen(
      pages: [
        PageViewModel(
          title: 'Select an Image',
          bodyWidget: Column(
            children: [
              GestureDetector(
                onTap: () async{
                  pickImage();
                }, child: image != null ? Container(
              child: Image.file(image!),
              height: 200,
              width: 300,
            ) : Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  height: 200,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(6)
                  ),
                  width: 300,
                  child: Icon(Icons.add_a_photo),
                ),
              ),
              SizedBox(height: 16,),
              SizedBox(
                height: 48,
                child: Text(
                  'All projects need an Image, start by uploading one that suits best your project',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  maxLines: 3,
                ),
              ),
              image != null ? Container(
                child: Column(
                  children: [
                    SizedBox(height: 16,),
                    Text(
                      'Good Choice!',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 32, color: Colors.blue),
                      maxLines: 3,
                    ),
                  ],
                ),
              ) : Container(

              ),
            ],
          )
        ),
        PageViewModel(
            title: 'Name your project, keep it simple',
            bodyWidget: Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                    child: TextFormField(
                      controller: _ProjectNameController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Project Name',
                      ),
                    ),
                  )
                ],
              ),
            ),
            image: Lottie.asset('assets/animations/lf20_j2rjqphu.json'),
            decoration: getPageDecoration()
        ),
        PageViewModel(
            title: 'Explain your project',
            bodyWidget: Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
                    child: TextFormField(
                      controller: _DescriptionController,
                      keyboardType: TextInputType.multiline,
                      maxLines: 5,
                      decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Description'
                      ),
                    ),
                  )
                ],
              ),
            ),
            image: Lottie.asset('assets/animations/lf20_wzbqr5lv.json'),
            decoration: getPageDecoration()
        ),
        PageViewModel(
          title: 'Topics that suit your project',
          bodyWidget: Wrap(children: fsTopics.map(
                (topic) {
              bool isSelected = false;
              if (selectedTopics!.contains(topic)) {
                isSelected = true;
              }
              return GestureDetector(
                onTap: () {
                  if (!selectedTopics!.contains(topic)) {
                    if (selectedTopics!.length < 5) {
                      selectedTopics!.add(topic);
                      setState(() {
                        //colorChoiceChip = Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
                      });
                      print(selectedTopics);
                    }
                  } else {
                    selectedTopics!.removeWhere((element) => element == topic);
                    setState(() {});
                    print(selectedTopics);
                  }
                },
                child: Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: 5, vertical: 4),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 5, horizontal: 12),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                              color: isSelected
                                  ? Colors.blue
                                  : Colors.grey,
                              width: 2)),
                      child: Text(
                        topic,
                        style: TextStyle(
                            color:
                            isSelected ? Colors.blue : Colors.grey,
                            fontSize: 16),
                      ),
                    )
                ),
              );
            },
          ).toList(),
          ),
        ),
        PageViewModel(
          title: 'Select your file types',
          //body: 'Default lorem ipsum description',
          bodyWidget: Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: CheckboxListTile(
                      title: Text("Image"),
                      secondary: Icon(Icons.code),
                      autofocus: false,
                      value: _catImage,
                      selected: _catImage,
                      onChanged: (newValue){
                        setState(() {
                          if(newValue!){
                            files.add('image');
                          }else{
                            files.removeWhere((name){
                              return name == 'image';
                            });
                          }
                          _catImage = newValue!;
                        });
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: CheckboxListTile(
                      title: Text("Audio File"),
                      secondary: Icon(Icons.code),
                      autofocus: false,
                      value: _catAudio,
                      selected: _catAudio,
                      onChanged: (newValue){
                        setState(() {
                          if(newValue!){
                            files.add('audio');
                          }else{
                            files.removeWhere((name){
                              return name == 'audio';
                            });
                          }
                          _catAudio = newValue!;
                        });
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: CheckboxListTile(
                      title: Text("Custom Input Text"),
                      secondary: Icon(Icons.code),
                      autofocus: false,
                      value: _GPSFile,
                      selected: _GPSFile,
                      onChanged: (newValue){
                        setState(() {
                          if(newValue!){
                            files.add('gps');
                          }else{
                            files.removeWhere((name){
                              return name == 'gps';
                            });
                          }
                          _GPSFile = newValue!;
                        });
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueAccent),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: CheckboxListTile(
                      title: Text("Paint Files"),
                      secondary: Icon(Icons.code),
                      autofocus: false,
                      value: _paintFile,
                      selected: _paintFile,
                      onChanged: (newValue){
                        setState(() {
                          if(newValue!){
                            files.add('pf');
                          }else{
                            files.removeWhere((name){
                              return name == 'pf';
                            });
                          }
                          _paintFile = newValue!;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          image: Lottie.asset('assets/animations/lf20_jmuq5aha.json'),
          decoration: getPageDecoration(),
        ),
        PageViewModel(
          title: 'Upload your weights',
          bodyWidget: Container(
            child: Column(
              children: [
                Container(
                  child: Text('If you don\'t have any weights right now, just skip this page'),
                ),
                SizedBox(
                  height: 26,
                ),
                SizedBox(
                  height: 48,
                  child: Container(
                    padding: const EdgeInsets.only(left:8.0, right: 8.0, top: 0, bottom: 0),
                    width: double.infinity,
                    child: TextButton(
                      child: Text('Select project weights',
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
                        selectWeight();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          image: Lottie.asset('assets/animations/105509-delivery-man.json'),
        ),
        PageViewModel(
          title: 'Upload your pdf documentation/articles',
          bodyWidget: Container(
            child: Column(
              children: [
                Container(
                  child: Text('If you don\'t have any articles right now, just skip this page you can add them later'),
                ),
                SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 48,
                  child: Container(
                    padding: const EdgeInsets.only(left:8.0, right: 8.0, top: 0, bottom: 0),
                    width: double.infinity,
                    child: TextButton(
                      child: Text('Select pdf(s)',
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
                        selectPDF();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          image: Lottie.asset('assets/animations/11564-scanner-animation.json'),
        )
      ],
      showBackButton: true,
      skipOrBackFlex: 0,
      nextFlex: 0,
      back: Text('Back',
          style: TextStyle(
            fontWeight: FontWeight.w300,
          )
      ),
      next: Icon(Icons.arrow_forward),
      dotsDecorator: getDotDecoration(),
      done: Text('Create',
        style: TextStyle(
          fontWeight: FontWeight.w300,
        ),
      ),
      onDone: () => insertProject(),
          //insertProject(),
          //goToHome(context),
    ),
  );

  void goToHome(context) => Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (_) => HomeScreenMobile()),
  );

  Future<int> getLastID() async {
    int newid;
    QuerySnapshot snap = await FirebaseFirestore.instance.collection('projects').get();
    newid = snap.docs.last['id'] + 1;
    return newid;
  }

  Future<void> insertProject() async{
    //falta verificar se foi tudo inserido, caso contrário snackbar
    if((image != null) && (_ProjectNameController.text != null) && (selectedTopics?.length != 0) && (_DescriptionController.text != null)){
      final Storage storage = Storage();
      QuerySnapshot snap = await FirebaseFirestore.instance.collection('projects').get();
      CollectionReference refc = FirebaseFirestore.instance.collection('projects');
      int newid = -1;
      if(snap.docs.isNotEmpty){
        newid = snap.docs.last['id'] + 1;
      }else{
        newid = 0;
      }
      const snackBar = SnackBar(
        content: const Text('Project uploaded sucessfully'),);
      print('o ultimo id : $newid');
      storage.uploadFile(image!.path.toString(), image!.path.toString().split("/").last, newid.toString()).then((String url){
        refc.doc(newid.toString()).set({
          'name' : _ProjectNameController.text.toString(),
          'author': _name,
          'id' : newid,
          'author_id': user.uid,
          'Organization': _organization,
          'title': _ProjectNameController.text.toString(),
          'image': image!.path.toString().split("/").last,
          'description': _DescriptionController.text.toString(),
          'topics': FieldValue.arrayUnion(selectedTopics!),
          'files' : FieldValue.arrayUnion(files),
          'weights': _isSelectedWeight,
          'pdf' : _isSelectedPDF,
          'custom' : FieldValue.arrayUnion([]),
          'banlist' : FieldValue.arrayUnion([]),
          'url': url,
          'likes' : 0,
          'contributions' : FieldValue.arrayUnion([]),
        }).then((value) => {print('Project added'), uploadFile(newid.toString(), 'weights'), uploadFile(newid.toString(), 'articles'), ScaffoldMessenger.of(context).showSnackBar(snackBar)}).catchError((error) =>
            print('Failed to add project: $error')
        );
      });
    }else{
      const snackBar = SnackBar(
          content: const Text('Missing some project information'),);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void createProject(context) async {
    setState(() {

    });
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreenMobile()));
  }

  PageDecoration getPageDecoration() => PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      bodyTextStyle: TextStyle(fontSize: 20),
      bodyPadding: EdgeInsets.all(16).copyWith(bottom: 0),
      imagePadding: EdgeInsets.all(24),
      pageColor: Colors.white
  );

  Widget buildImage(String url) =>
    SizedBox(
      child: Lottie.network(url),
    );
    //Center(child: Lottie.network(url), heightFactor: 150,);

  DotsDecorator getDotDecoration() => DotsDecorator(
    color: Color(0xFFBDBDBD),
    activeColor: Colors.blue,
    size: Size(10, 10),
    activeSize: Size(22, 10),
    activeShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
  );
}


class LoadingWidget{
  Widget loadingWidget(){
    return SpinKitCircle(
      size: 140,
      color: Colors.white,
    );
  }
}
















class uploadImage extends StatefulWidget {
  const uploadImage({Key? key}) : super(key: key);

  @override
  State<uploadImage> createState() => _uploadImageState();
}

class _uploadImageState extends State<uploadImage> {
  @override
  final Storage storage = Storage();
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 24,),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                final results = await FilePicker.platform.pickFiles(
                  allowMultiple: false,
                  type: FileType.custom,
                  allowedExtensions: ['png', 'jpg', 'jpeg'],
                );
                if(results == null){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No File has been picked"), duration: Duration(milliseconds: 300),),);
                }
                final path = results?.files.single.path!;
                final fileName = results?.files.single.name;
                print(path);
                print(fileName);
                storage.uploadFile(path!, fileName!, 'TestFolder').then((value) => print('Done'));
              },
              child: Text('Upload File'),
            ),
          ),
          FutureBuilder(
              future: storage.listFiles(),
              builder: (BuildContext context,
                  AsyncSnapshot<firebase_storage.ListResult> snapshot){
                if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.items.length,
                      itemBuilder: (BuildContext context, int index){
                       return Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: ElevatedButton(onPressed: () {}, child: Text(snapshot.data!.items[index].name),),
                       );
                      },
                    ),
                  );
                }
                if(snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData){
                  return CircularProgressIndicator();
                }
                return Container();
              }),
          /*FutureBuilder(
              future: storage.downloadURL('14192399_lizrad-king-1b.jpg'),
              builder: (BuildContext context,
                  AsyncSnapshot<String> snapshot){
                if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
                  return Container(
                    width: 300,
                    height: 250,
                    child: Image.network(snapshot.data!, fit: BoxFit.cover,),
                  );
                }
                if(snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData){
                  return CircularProgressIndicator();
                }
                return Container();
              }),*/
          SizedBox(
            width: double.infinity,
            child: IconButton(
              icon: FaIcon(FontAwesomeIcons.moneyBillWave),
              iconSize: 80,
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}

class ChoiceChipSelect extends StatefulWidget {
  final List<String> catList;
  final Function(List<String>)? onSelectionChanged;
  final Function(List<String>)? onMaxSelected;
  final int? maxSelection;
  ChoiceChipSelect(this.catList, {this.onSelectionChanged, this.onMaxSelected, this.maxSelection});

  @override
  State<ChoiceChipSelect> createState() => _ChoiceChipSelectState();
}

class _ChoiceChipSelectState extends State<ChoiceChipSelect> {
  List<String> selectedCats = [];

  _buildCatList(){
    List<Widget>? choices = [];
    widget.catList.forEach((element) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(element),
          selected: selectedCats.contains(element),
          onSelected: (selected){
            if(selectedCats.length == (widget.maxSelection ?? -1) && !selectedCats.contains(element)){
              widget.onMaxSelected?.call(selectedCats);
            }else{
              setState(() {
                selectedCats.contains(element)
                    ? selectedCats.remove(element)
                    : selectedCats.add(element);
              });
              widget.onSelectionChanged?.call(selectedCats);
            }
          }
        ),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildCatList(),
    );
  }
}




