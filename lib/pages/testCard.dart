import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:projecto_fcs/controller/CardProvider.dart';
import 'package:projecto_fcs/pages/PieChartPage.dart';
import 'package:projecto_fcs/pages/swiper.dart';
import 'package:provider/provider.dart';

import 'ProjectPageDesktop.dart';

class TestCard extends StatefulWidget {
  const TestCard({Key? key}) : super(key: key);

  @override
  State<TestCard> createState() => _TestCardState();
}

class _TestCardState extends State<TestCard> {
  var currentId = -1;

  @override
  Widget build(BuildContext context) {

    return Container(
      /*decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            //Colors.red.shade200,
            //Colors.black,
          ]
        ),
      ),*/
      child: Scaffold(
        //backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          /*Expanded(
                              child: buildCards()),*/
                          buildCards(),
                          Container(
                              alignment: Alignment.bottomCenter,
                              child: buildStamps()),
                        ],),
                    ),
                    const SizedBox(height: 16,),
                    buildButtons(),
                  ],
                ),
                //const SizedBox(height: 16,),
                //
          ),
        ),
      ),
    );
  }

  Widget buildCards() {
    //final CommPolls = provider.CommunityPolls;

    //final poLength = CommPolls.length;

    //print(CommPolls.length);

    final provider = Provider.of<CardProvider>(context);
    provider.updateList();
    final urlImages = provider.urls;
    final questions = provider.Questions;
    final ids = provider.Idxs;

    print('images:' + urlImages.length.toString());
    print('questions' + questions.length.toString());
    print('ids' + ids.length.toString());


    if (urlImages.isEmpty) {
      return Center(
        child: Text('There are no more entries'),
      );
    } else {
      return Stack(
        children: urlImages
            .asMap()
            .entries
            .map((image) =>
            ProjectCardSwiper(
              url: image.value,
              isFront: urlImages.last == image.value,
              tipo: 'image',
              question: questions[image.key],
              projectID: ids[image.key],
            ),).toList(),
      );
    }
  }
  /*
          urlImages.map((image) => ProjectCardSwiper(
            url: image,
            isFront:  urlImages.last == image, tipo: 'image', question: questions[urlImages.indexOf(image)-1], projectID: ids[urlImages.indexOf(image)-1],
          )).toList(),
        );
    //}

    //return Container();

    return CommPolls.isEmpty ? Center(
      child: Text('There are no more entries'),
    ) : Stack(
      children: CommPolls.map((poll) => ProjectCardSwiper(
        url: poll.image,
        isFront:  CommPolls.last.image == poll.image, tipo: 'image',
      )).toList(),
    );

    //CommPolls[poLength-1].image

    return urlImages.isEmpty ? Center(
      child: Text('There are no more entries'),
    ) : Stack(
      children: urlImages.map((poll) => ProjectCardSwiper(
        url: poll,
        isFront: urlImages.last == poll, tipo: 'image',
      )).toList(),
    );
  }*/

  Widget buildStamps(){
    final provider = Provider.of<CardProvider>(context);
    final status = provider.getStatus();
    switch(status){
      case CardStatus.superlike:
        final child = buildStamp(angle: -0.5, color: Colors.green, text: 'Submit your answer');
        return child;
      default:
        return Container();
    }
  }

  Widget buildStamp({double angle = 0, required Color color, required String text}){
    final myController = TextEditingController();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.bottomCenter,
              width: 300,
              height: 275,
              padding: EdgeInsets.symmetric(horizontal: 8),
              decoration: new BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
            ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(text, textAlign: TextAlign.start, style: TextStyle(color: Colors.black, fontSize: 32, fontWeight: FontWeight.bold),),
                  TextField(
                    controller: myController,
                    autofocus: true,
                  ),
                  SizedBox(height: 32,),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      height: 48,
                      child: Container(
                        padding: const EdgeInsets.only(left:8.0, right: 8.0, top: 0, bottom: 0),
                        width: double.infinity,
                        child: TextButton(
                          child: Text('submit',
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
                            //print('submit button');
                            final provider = Provider.of<CardProvider>(context, listen: false);
                            print(provider.getId());
                            final ids = provider.Idxs;
                            print('pid ' + ids[provider.getId()-1]);
                            var list = [myController.text.toString()];
                            FirebaseFirestore.instance.collection('communitypolls').doc(ids[provider.getId()-1]).update({'answers': FieldValue.arrayUnion(list)});
                            provider.printName(myController.text.toString());
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              )
          ),
        ],
      );
  }

  Widget buildButtons() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          elevation: 20,
          primary: Colors.white,
          shape: CircleBorder(),
          minimumSize: Size.square(80),
          side: BorderSide(width: 2.0, color: Colors.red),
        ),
        child: Icon(Icons.poll, color: Colors.red, size: 32,),
        onPressed: (){
          final provider = Provider.of<CardProvider>(context, listen: false);
          final ids = provider.Idxs;
          print('pid ' + ids[provider.getId()-1]);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PieChartPage(docId: ids[provider.getId()-1],)),
          );
        },
      ),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          elevation: 20,
          primary: Colors.white,
          shape: CircleBorder(),
          minimumSize: Size.square(80),
          side: BorderSide(width: 2.0, color: Colors.blue),
        ),
        child: Icon(Icons.home, color: Colors.blue, size: 32,),
        onPressed: () async{
          //final provider = Provider.of<CardProvider>(context, listen: false);
          //provider.like();
          //print('meio');
          final provider = Provider.of<CardProvider>(context, listen: false);
          final ids = provider.Idxs;
          print('pid ' + ids[provider.getId()-1]);

          DocumentReference polls = FirebaseFirestore.instance.collection('communitypolls').doc(ids[provider.getId()-1]);
          DocumentSnapshot docPoll = await polls.get();
          var ProjectId = docPoll['projectID'];
          print(ProjectId);
          DocumentReference proj = FirebaseFirestore.instance.collection('projects').doc(ProjectId);
          DocumentSnapshot docSnap = await proj.get();

          /*
          var author_id = docSnap['author_id'];
          print(author_id);
          var name = docSnap['name'];
          print(name);
          var imageURL = docSnap['url'];
          print(imageURL);
          var description = docSnap['description'];
          print(description);
          var Organization = docSnap['Organization'];
          print(Organization);
          var author = docSnap['author'];
          print(author);
          var ProjectIdx = docSnap['id'];
          print(ProjectIdx);

          print(files.toString());

          print(topics.toString());
           */

          List<String> files = List<String>.from(docSnap['files']);
          List<String> topics = List<String>.from(docSnap['topics']);
          List<String> banlist = List<String>.from(docSnap['banlist']);

          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProjectPageMobile(ProjectName: docSnap['name'],
                fileTypes: files,
                author_id: docSnap['author_id'],
                imageURL: docSnap['url'],
                topics: topics,
                description: docSnap['description'],
                Organization: docSnap['Organization'],
                author: docSnap['author'],
                ProjectId: docSnap['id'], banlist: banlist,
              )));
          /*
          List<String> files = List<String>.from(indx['files']);
          List<String> topics = List<String>.from(indx['topics']);
          ProjectName: snapshot.data!.docs[snapshot.data!.docs.length-index-1]['name'],
          fileTypes: files,
          author_id: indx['author_id'],
          imageURL: indx['url'],
          topics: topics,
          description: indx['description'],
          Organization: indx['Organization'],
          author: indx['author'],
          ProjectId: indx['id'],
          */

        },
      ),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
            onPrimary: Colors.white,
            elevation: 20,
            primary: Colors.white,
            shape: CircleBorder(),
            minimumSize: Size.square(80),
            side: BorderSide(width: 2.0, color: Colors.teal),
        ),
        child: Icon(Icons.skip_next, color: Colors.teal, size: 32,),
        onPressed: (){
          //print(currentId.toString());
          //final provider = Provider.of<CardProvider>(context, listen: false);
          //print(provider.Idof.toString());
          final provider = Provider.of<CardProvider>(context, listen: false);
          provider.like();
        },
      ),
    ],
  );
}


