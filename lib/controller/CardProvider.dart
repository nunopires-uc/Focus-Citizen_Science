import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/communitypoll.dart';

enum CardStatus {like, dislike, superlike}


int count = -1;




class CardProvider extends ChangeNotifier{


  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) => getData());
  }




  List<String> _urls = [
    //'https://media.wired.com/photos/593261cab8eb31692072f129/master/pass/85120553.jpg',
    //'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3c/Giant_Panda_2004-03-2.jpg/1200px-Giant_Panda_2004-03-2.jpg',
    //'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/headshot-of-giraffe-sabi-sands-game-reserve-royalty-free-image-1573571198.jpg',
  ];



  /*
  List<String> _urls = [
    'https://firebasestorage.googleapis.com/v0/b/projeto-fcs.appspot.com/o/10%2FCommunityPoll%2Ftspt_bird_flute_01_008.mp3',
    'https://firebasestorage.googleapis.com/v0/b/projeto-fcs.appspot.com/o/10%2FCommunityPoll%2FPigeon-noise-cooing.mp3'
  ];
   */


  List<String> _mediaTypes = [
    //'image', 'image'
  ];

  List<String> _ids = [];

  List<CommunityPoll> polls  = [];

  List<String> _questions = [];

  bool _isDragging = false;
  double _angle = 0;
  Offset _position = Offset.zero;
  Offset get position => _position;
  bool get isDragging => _isDragging;
  double get angle => _angle;
  List<String> get urls => _urls;
  List<String> get Questions => _questions;
  List<String> get Idxs => _ids;

  String get Idof => _ids[_ids.length-1];
  List<CommunityPoll> get CommunityPolls => polls;
  Size _screenSize = Size.zero;


  CollectionReference _collectionRef = FirebaseFirestore.instance.collection('communitypolls');







  Future<void> getData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();
    //querySnapshot
    _collectionRef.get().then((QuerySnapshot querySnapshot){
      querySnapshot.docs.forEach((doc) {

        //CommunityPoll poll = CommunityPoll(id: doc.reference.id, ProjectID: doc['projectID'], image: doc['image'], question: doc['question'], type: doc['type']);
        final index = Idxs.indexWhere((element) =>
        element == doc.reference.id);

        print(':->:' + index.toString());

        if(index >= 0){

        }else{
          _ids.add(doc.reference.id.toString());
          _urls.add(doc['image']);
          _questions.add(doc['question']);
          //polls.add(poll);
        }
        print('here -> get_data');
        print(_ids.toString());
        print(_urls.toString());
        print(_questions.toString());
        //print(polls.toString());
        //polls.map((e) => print('image:' + e.image + 'type' + e.type));


        //for(var i = 0; i < poll; i++)
        //print(doc['image']);
        //print(doc['type']);
        //_urls.add('+');
        /*
          if(!_urls.contains(doc['image'])){
            _urls.add(doc['image']);
          }
          if(!_mediaTypes.contains(doc['type'])){
            _mediaTypes.add(doc['type']);
          }
        */

      });
    });


    //print(polls.toList().toString());
    //print(_urls);
    //print(_mediaTypes);
    // Get data from docs and convert map to List
    // doc.data()
    //final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    //_urls.add(allData);
    //print(allData['question']);
  }


  void setScreenSize(Size screenSize) => _screenSize = screenSize;

  void startPosition(DragStartDetails details){
    _isDragging = true;
    notifyListeners();
  }


  void updatePosition(DragUpdateDetails details){
    _position += details.delta;
    final x = _position.dx;
    _angle = 45 * x / _screenSize.width;
    notifyListeners();
  }

  int getId(){
    return _urls.length;
  }

  void endPosition() {
    //resetPosition();
    _isDragging = false;
    notifyListeners();
    final status = getStatus();
    if(status != null){
      print('status -> ' + status.toString());
      /*Fluttertoast.cancel();
      Fluttertoast.showToast(
        msg: status.toString().split('.').last.toUpperCase(),
        fontSize: 36,
      );*/
    }

    switch(status){
      case CardStatus.like:
        like();
        break;
      case CardStatus.superlike:
        //superLike();
        //resetPosition();
        break;

      default:
        resetPosition();
        break;
    }
  }

  void superLike(){
    _angle = 0;
    _position -= Offset(0, _screenSize.height);
    _nextCard();
    notifyListeners();
  }

  void like(){
    //getData();
    _angle = 20;
    _position += Offset(2 * _screenSize.width, 0);
    //_ids.removeAt(_ids.length - 1);
    _nextCard();

    print('len ' + _ids.length.toString());
    print('data ' + _ids.toString());
    //_ids.removeLast();
    //nextCard();
    notifyListeners();
  }

  void nextCard(){
    _nextCard();
    notifyListeners();
  }

  void updateList(){
    print('update -> list');
    getData();
  }

  CardStatus? getStatus(){
    final x = _position.dx;
    final y = _position.dy;
    final forceSuperLike = x.abs() < 20;
    final delta = 100;
    if(x >= delta){
      return CardStatus.like;
    }else if(y <= -delta / 2 && forceSuperLike){
      return CardStatus.superlike;
    }
  }

  Future _nextCard() async{
    if(_urls.isEmpty) return;
    await Future.delayed(Duration(milliseconds: 200));
    //_ids.removeLast();
    _urls.removeLast();
    //_questions.removeLast();
    //
    count -= 1;
    //print('last:' + _ids[_ids.length-1]);

    resetPosition();
  }


  void printName(String name){
    print(name);
    _nextCard();
  }


  void resetPosition(){
    _isDragging = false;
    _angle = 0;
    _position = Offset.zero;
    notifyListeners();
  }

}