import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:getwidget/components/card/gf_card.dart';
import 'package:projecto_fcs/controller/emoticon_face.dart';
import 'package:projecto_fcs/pages/searchPage.dart';
import 'package:projecto_fcs/pages/testCard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ProjectList.dart';
import 'ProjectPageDesktop.dart';
import 'insertProject.dart';
import 'package:intl/intl.dart';

class HomePageMobile extends StatefulWidget {
  const HomePageMobile({Key? key}) : super(key: key);

  @override
  State<HomePageMobile> createState() => _HomePageMobileState();
}

class _HomePageMobileState extends State<HomePageMobile> {
  int _index = 0;
  final List<Widget> pageRoutes = [
    HomeScreenMobile(),
    insertProjectPage(),
    //ProjectListPage(),
    TestCard(),
  ];

  void changePage(int index){
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageRoutes[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: changePage,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home),
              label: ''
          ),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline),
            label: '',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.supervised_user_circle),
              label: ''
          ),
        ],
      ),
    );
  }
}

/*
Future <void> getUserDetails() async{
  final docRef = db.collection("cities").doc("SF");
  docRef.get().then(
        (res) => print("Successfully completed"),
    onError: (e) => print("Error completing: $e"),
  );
}
 */


class HomeScreenMobile extends StatefulWidget {
  const HomeScreenMobile({Key? key}) : super(key: key);

  @override
  State<HomeScreenMobile> createState() => _HomeScreenMobileState();
}

class _HomeScreenMobileState extends State<HomeScreenMobile> {
  final user = FirebaseAuth.instance.currentUser!;
  final queryProjects = FirebaseFirestore.instance.collection('projects');

  //bool _currentIcon = false;


  /*
  Future<String> getNome() async{
    String userName;
    QuerySnapshot snap = (await FirebaseFirestore.instance.collection('xusers').doc(user.uid).get()) as QuerySnapshot<Object?>;
    userName = snap.docs.last['name'] + 1;


    final ref = FirebaseFirestore.instance.ref();
    final snapshot = await ref.child('users/$userId').get();
    if (snapshot.exists) {
      print(snapshot.value);
    } else {
      print('No data available.');
    }
  }
   */

  String? _name;
  String? _organization;
  int _hasNotification = 1;

  //bool _currentIcon = false;


  DateFormat dateFormat = new DateFormat.yMMMMd('en_US');


  Future<void> getSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _name = prefs.getString('_user');
    _organization = prefs.getString('_org');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    getSharedPrefs();

    Color _color = Colors.red;
    bool _currentIcon = false;
    final Mycontroller = TextEditingController();

    return Scaffold(backgroundColor: Colors.blue[800],
      body: Column(
        children: [
          SizedBox(height: 32,),
          Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: (){
                              //ProjectListPage
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ProjectListPage()));
                            },
                            child: Text('Hi, $_name', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),),
                          ),
                          SizedBox(height: 8.0,),
                          Text(DateFormat.yMMMd().format(DateTime.now()).toString(), style: TextStyle(color: Colors.blue[200])),
                        ],
                      ),

                      InkWell(
                        onTap: () async{
                          await FirebaseAuth.instance.signOut();
                        },
                        child: Container(
                          decoration: BoxDecoration(color: Colors.blue[600],
                              borderRadius: BorderRadius.circular(12.0)),
                          padding: EdgeInsets.all(16.0),
                          child: Icon(Icons.logout, color: Colors.white),
                        ),
                      ),

                      /*Badge(
                          badgeColor: Colors.red,
                          badgeContent: Text("2", style: const TextStyle(color: Colors.white),),
                          showBadge: _hasNotification > 0 ? true : false,
                          child: Container(
                            decoration: BoxDecoration(color: Colors.blue[600],
                                borderRadius: BorderRadius.circular(12.0)),
                            padding: EdgeInsets.all(16.0),
                            child: Icon(Icons.notifications, color: Colors.white),
                          )
                      )*/
                    ],
                  ),
                  SizedBox(height: 25,),
                  // Search Bar
                  Container(
                    decoration: BoxDecoration(color: Colors.blue[600],
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: EdgeInsets.all(12.0),
                    child: Row(
                      children: <Widget>[
                      Icon(Icons.search, color: Colors.white,),
                      SizedBox(width: 5.0,),
                      Flexible(
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SearchPage()),
                            );
                          },
                          child: Text(
                            'Search',
                            style: TextStyle(
                                color: Colors.white),
                            ),
                          ),
                        ),
                        /*TextField(
                          controller: Mycontroller,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                              hintText: 'Search',
                            hintStyle: TextStyle(color: Colors.white),
                          ),
                      ),*/
                      /*
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Search'
                        ),
                      )*/
                    ],),
                  ),
                ],
                    ),
                  )
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

              //print('controller :: ' + Mycontroller.text.toString());
              //if(Mycontroller.text.toString() != null){
                //if()
              //}
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


                      //indx['name'].toString().contains(controller.text.toString())

                      //if(Mycontroller.text.toString() != null){
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
                      //}else{
                      //  return Container();
                      //}




                    },
                    itemCount: snapshot.data!.docs.length,),
                ),
              );
            },
          )
        ],
      )
    );
  }
}




    /*

    StreamBuilder(stream: FirebaseFirestore.instance.collection('projects').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          Color _color = Colors.red;
          bool _currentIcon = false;
          )
      });
    ),
     */
    /*
    ListView.builder(
    shrinkWrap: true,
    //itemExtent: 70.0,
    itemBuilder: (BuildContext context, int index) {
      return InkWell(
        onTap: () async{
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProjectPageMobile(ProjectName: snapshot.data!.docs[index]['name'],)),
          );
        },
        child: Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  width: 100,
                  //alignment: Alignment.centerLeft,
                  child: Image.network('https://static.remove.bg/remove-bg-web/eb1bb48845c5007c3ec8d72ce7972fc8b76733b1/assets/start-1abfb4fe2980eabfbbaaa4365a0692539f7cd2725f324f904565a9a744f8e214.jpg')
              ),
              SizedBox(width: 4,),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(snapshot.data!.docs[snapshot.data!.docs.length-index-1]['name'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  ),
                  Text('this is the description', style: TextStyle(fontSize: 14),),
                ],
              ),
              SizedBox(width: 4,),
              Container(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: _currentIcon
                      ? new Icon(Icons.favorite, color: _color,)
                      : new Icon(Icons.favorite),
                  onPressed: () {
                    setState(() {
                      _currentIcon = !_currentIcon;
                    });
                  },
                ),
              )
            ],
          ),
        ),
      );
    },
    itemCount: snapshot.data!.docs.length,
    )













    /*SafeArea(
        child: Column(
          children: <Widget>[
            // login info - greetings
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Hi, $_name', /*+ user.email!*/
                            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8.0,),
                          Text(DateFormat.yMMMd().format(DateTime.now()).toString(), style: TextStyle(color: Colors.blue[200]),
                          ),
                        ],
                      ),

                      Badge(
                        badgeColor: Colors.red,
                        badgeContent: Text("2", style: const TextStyle(color: Colors.white),),
                        showBadge: _hasNotification > 0 ? true : false,
                        child: Container(
                            decoration: BoxDecoration(color: Colors.blue[600],
                            borderRadius: BorderRadius.circular(12.0)),
                            padding: EdgeInsets.all(16.0),
                            child: Icon(Icons.notifications, color: Colors.white,)
                            /*
                            child: Badge(
                              badgeContent: Text("2", style: const TextStyle(color: Colors.white),),
                              ,
                              badgeColor: Colors.white,

                            )*/
                            //child: Icon(Icons.notifications, color: Colors.white,)
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25,),
                  // Search Bar
                  Container(
                    decoration: BoxDecoration(color: Colors.blue[600],
                    borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: EdgeInsets.all(12.0),
                    child: Row(children: <Widget>[
                      Icon(Icons.search, color: Colors.white,),
                      SizedBox(width: 5.0,),
                      Text('Search',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ],),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(25.0),
              color: Colors.grey[200],
              child: Center(
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Recent Projects',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        InkWell(
                          child: Icon(Icons.more_horiz),
                          onTap: (){
                            FirebaseAuth.instance.signOut();
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    StreamBuilder(stream: FirebaseFirestore.instance.collection('projects').snapshots(),
                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                        if(!snapshot.hasData){
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        Color _color = Colors.red;
                        bool _currentIcon = false;
                        return ;
                        )
                      },
                    ),
                    //listview of exercises
                    /*
                    FirestoreListView(query: queryProjects, itemBuilder: (BuildContext context, QueryDocumentSnapshot<dynamic> doc) {
                      print('here');
                    final post = doc.data();
                    print(':-: ' + queryProjects.id);
                    return ListTile(
                    leading: CircleAvatar(
                    backgroundImage: NetworkImage('assets/images/2021-se-rdm-molecules-all.png'),
                    ),
                    title: Text('hey',
                    style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    ),),
                    subtitle: Text('Ancient Egypt Photogrammetry',
                    style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.grey
                    ),
                    ),
                    );
                    }),
                     */

                      /*return ListView.custom(childrenDelegate: SliverChildBuilderDelegate((BuildContext context, int index){
                        return Container(
                            padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(color: Colors.white,
                                borderRadius: BorderRadius.circular(16)),
                          child: Column(
                            children: [
                          Container(
                          width: MediaQuery.of(context).size.width,
                          height: 200,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage('assets/images/2021-se-rdm-molecules-all.png'),
                              )
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                          children: <Widget>[
                          Icon(Icons.favorite),
                          SizedBox(width: 12,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(post['name'],
                                style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),),
                            SizedBox(height: 5,),
                            Text('Ancient Egypt Photogrammetry',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.grey
                            ),
                            ),
                        ],
                        ),
                        IconButton(
                        icon: _currentIcon
                        ? new Icon(Icons.favorite, color: Colors.red,)
                            : new Icon(Icons.favorite),
                        onPressed: () {
                        setState(() {
                        _currentIcon = !_currentIcon;
                        });
                        },
                        )
                        ],
                          ),
                        ],),);
                          }
                        ),*/
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/*/
