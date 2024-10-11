import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/card/gf_card.dart';
import 'ProjectPageDesktop.dart';

class SearchResults extends StatefulWidget {
  final String search;
  const SearchResults({Key? key,
    required this.search,
  }) : super(key: key);

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 45.0,),
          Text('Search Results', textAlign: TextAlign.start,
              style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold)
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection('projects').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot){
              if(!snapshot.hasData){
                print('here');
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Flexible(
                child: Container(
                  decoration: BoxDecoration(color: Colors.white,
                    borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(20.0),
                      topRight: const Radius.circular(20.0),
                    ),
                  ),
                  child: ListView.builder(
                    itemBuilder: (BuildContext context, int index){
                      var indx = snapshot.data!.docs[snapshot.data!.docs.length-index-1];

                      final String nameProj = snapshot.data!.docs[snapshot.data!.docs.length-index-1]['name'];

                      print('authorid :: ' + indx['author_id']);
                      print('authid ::' + FirebaseAuth.instance.currentUser!.uid);

                      if(nameProj.toLowerCase().contains(widget.search.toLowerCase())){
                        print('contains');
                        return InkWell(
                            onTap: (){
                              List<String> files = List<String>.from(indx['files']);
                              List<String> topics = List<String>.from(indx['topics']);
                              List<String> banlist = List<String>.from(indx['banlist']);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ProjectPageMobile(ProjectName: snapshot.data!.docs[snapshot.data!.docs.length-index-1]['name'],
                                    fileTypes: files,
                                    author_id: indx['author_id'],
                                    imageURL: indx['url'],
                                    topics: topics,
                                    description: indx['description'],
                                    Organization: indx['Organization'],
                                    author: indx['author'],
                                    ProjectId: indx['id'], banlist: banlist,
                                  )));
                            },
                            child: GFCard(
                              color: Colors.white70,
                              boxFit: BoxFit.cover,
                              image: Image.network(indx['url'],
                                height: MediaQuery.of(context).size.height * 0.25,
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.fitWidth,
                              ),
                              showImage: true,
                              content: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(snapshot.data!.docs[snapshot.data!.docs.length-index-1]['name'], textAlign: TextAlign.left,
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)
                                  ),
                                  Text(
                                      ' by ' + indx['Organization'],
                                      textAlign: TextAlign.left, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300)
                                  ),
                                  //Text('topics', textAlign: TextAlign.right),
                                ],
                              ),
                            )
                        );
                      }
                      return Container();
                    },
                    itemCount: snapshot.data!.docs.length,),
                ),
              );
            },
          ),
          /*
          if (count == 0) ...[
            Center(child: Text('No projects were created with this account')),
          ] else ...[

          ],*/
        ],
      ),
    );
  }
}
