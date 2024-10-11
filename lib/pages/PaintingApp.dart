import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:math';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'dart:convert' show utf8;

class CanvasPaint extends StatefulWidget {
  final int ProjectID;
  const CanvasPaint({Key? key, value,
    required this.ProjectID,

  }) : super(key: key);

  @override
  State<CanvasPaint> createState() => _CanvasPaintState();
}

class _CanvasPaintState extends State<CanvasPaint> {

  final controller = ScreenshotController();
  List<DrawingPoints?> points = [];
  Color strokeColor = Colors.black;
  double strokeWidth = 3.0;
  final name = 'compound';
  List<File>? files;
  List<String> nameFiles = [];
  final user = FirebaseAuth.instance.currentUser!;

  static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();


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

    const snackBar = SnackBar(
      content: const Text('Data uploaded sucessfully'), duration: Duration(seconds: 3),);

    print('kazzinski');
    print(nameFiles.toString());
    FirebaseFirestore.instance.collection('projects').doc(widget.ProjectID.toString()).update(
        {'contributions': FieldValue.arrayUnion(nameFiles!)}
    ).then((value) => ScaffoldMessenger.of(context).showSnackBar(snackBar));

  }

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

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));



  Future<String> saveImage(Uint8List bytes) async{
    String randomString = getRandomString(_rnd.nextInt(10));
    var nameBytes = utf8.encode(randomString);
    var value = sha256.convert(nameBytes);
    var path;
    var file;
    String compoundName = name + '_' + value.toString();

    await [Permission.storage].request();
    //final result = await ImageGallerySaver.saveImage(bytes, name: compoundName);


    final result = await ImageGallerySaver.saveImage(bytes, name: compoundName);

    //final imagePath = result['filePath'].toString().replaceAll(RegExp('content://'), '');
    final imagePath = result['filePath'].toString();

    //uploadFile(widget.ProjectID.toString(), imagePath, compoundName);




    //print(imagePath);





    //file = File(result['filepath']);
    //path = '$widget.ProjectID/data/${result['filepath'].toString().split('/').last}';
    //final ref = FirebaseStorage.instance.ref().child(path);
    //ref.putFile(file);

    //print(':::' + result['filepath']);
    return result['filepath'];
    //return result;
  }

  Widget myCanvas() => CustomPaint(
      size: Size.infinite,

      painter: Painter(
        points: points,
      )
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Draw'),
        actions: [
          IconButton(
            onPressed: (){
              setState(() {
                points = [];
              });
            },
            icon: Icon(Icons.cleaning_services),
          ),
          IconButton(
            onPressed: () async{
                final image = await controller.captureFromWidget(myCanvas());
                String path = await saveImage(image);
                print('>>>>' + path);
                selectFileImage(widget.ProjectID.toString());
                //if (image == null) return;
                //
                //Navigator.of(context).pop(path);
            },
            icon: Icon(Icons.save),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 40,
          child: Slider(
            value: strokeWidth, min: 1, max: 5, onChanged: (val){
              setState(() {
                strokeWidth = val;
              });
            },
          ),
        ),
      ),
      floatingActionButton: Container(
        alignment: Alignment.bottomCenter,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FloatingActionButton(child: strokeColor == Colors.red ? Icon(Icons.close) : Container(),
              onPressed: (){
              strokeColor = Colors.red;
            },

              backgroundColor: Colors.red,

            ),
            FloatingActionButton(child: strokeColor == Colors.green ? Icon(Icons.close) : Container(),
              onPressed: (){
              strokeColor = Colors.green;
            },

              backgroundColor: Colors.green,

            ),
            FloatingActionButton(child: strokeColor == Colors.blue ? Icon(Icons.close) : Container(),
              onPressed: (){
              strokeColor = Colors.blue;
            },

              backgroundColor: Colors.blue,

            ),
            FloatingActionButton(child: strokeColor == Colors.white ? Icon(Icons.close) : Container(),
              onPressed: (){
              strokeColor = Colors.white;
            },

              backgroundColor: Colors.white,

            ),
            FloatingActionButton(child: strokeColor == Colors.black ? Icon(Icons.close) : Container(),
              onPressed: (){
              strokeColor = Colors.black;
            },

              backgroundColor: Colors.black,

            ),
            FloatingActionButton(child: strokeColor == Colors.yellow ? Icon(Icons.close) : Container(),
              onPressed: (){
              strokeColor = Colors.yellow;
            },
              backgroundColor: Colors.yellow,
            ),
          ],
        ),
      ),

      body: GestureDetector(
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: myCanvas(),
      )
    );



  }

  void _onPanStart(DragStartDetails details){
    setState(() {
      points.add(DrawingPoints(point: details.localPosition,
        paint: Paint()..color = strokeColor
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.butt,
      ));
      print('User has started drawing');
    });

  }

  void _onPanUpdate(DragUpdateDetails details){
    setState(() {
      points.add(DrawingPoints(point: details.localPosition,
      paint: Paint()..color = strokeColor
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.butt,
      ));
      print(details.localPosition);
    });

  }

  void _onPanEnd(DragEndDetails details){
    setState(() {
      points.add(null);
    });
    print('User has stopped drawing');
  }
}

class Painter extends CustomPainter{
  List<DrawingPoints?> points;
  Painter({required this.points, });
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(Colors.white, BlendMode.color);

    for(var i = 0; i < points.length - 1; i++){
      //var paint =

      //Paint()..color = Colors.black..strokeWidth = 3.0..strokeCap = StrokeCap.butt;

      var currentPoint = points[i];
      var nextPoint = points[i + 1];
      if(currentPoint != null && nextPoint != null){
        canvas.drawLine(currentPoint.point, nextPoint.point, currentPoint.paint);
      }


    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

}

class DrawingPoints{
  Offset point;
  Paint paint;
  DrawingPoints({required this.point, required this.paint}){

  }
}
