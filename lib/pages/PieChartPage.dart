import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';



class PieChartPage extends StatefulWidget {
  final String docId;
  const PieChartPage({Key? key,
    required this.docId,
  }) : super(key: key);

  @override
  State<PieChartPage> createState() => _PieChartPageState();
}

class _PieChartPageState extends State<PieChartPage> {

  /*
  var collectionx = await FirebaseFirestore.instance.collection('users').doc().get();


  var docSnapshot = await collectionx.doc('doc_id').get();
  if (docSnapshot.exists) {
    Map<String, dynamic>? data = docSnapshot.data();
    var value = data?['some_field']; // <-- The value you want to retrieve.
    // Call setState if needed.
  }
   */

  static Color randomColor() {
    return Color(Random().nextInt(0xffffffff));
  }

  Map<String, double> dataMap = {
    'Gato' : 40.0,
    'Cão' :  60.0,
  };

  List<Color> colorList = [
    const Color(0xffD95Af3),
    const Color(0xff3EE094),
  ];


  @override
  Widget build(BuildContext context) {

    CollectionReference users = FirebaseFirestore.instance.collection('communitypolls');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(widget.docId).get(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
            //return Text("Full Name: ${data['answers']} ${data['last_name']}");
            List<String> ans = List<String>.from(data['answers']);
            Map<String, double> map1 = {};
            List<Color> colorGraph = [];

            if(ans.length == 0){
              return Container();
            }

            for(int i=0;i<ans.length;i++){
              if(ans[i] == ''){
                ans.removeAt(i);
              }
              colorGraph.add(randomColor());

              int count = 0;
              for(int j=0;j<ans.length;j++){
                if(ans[j] == ans[i]){
                  count += 1;
                }
              }
              map1[ans[i]] = (count/ans.length);
            }

            print('answers :: ' + ans.toString());
            print('count :: ' + map1.toString());
            print('len :: ' + ans.length.toString());

            return Scaffold(
                body: Center(
                  child: PieChart(
                    dataMap: map1,
                    colorList: colorGraph,
                    chartRadius: MediaQuery.of(context).size.width / 2,
                    centerText: 'Answers',
                  ),
                )
            );
            //print('answers :: ${data['answers']}');
          }

          return Text("loading");
        });
    /*
    return new StreamBuilder(
        stream: FirebaseFirestore.instance.collection('communitypolls').doc('vZVOwcpamqZ8PjBxAfQl').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            //return new Text("Loading");
          }
          var userDocument = snapshot.data;
          //print(snapshot.data!['answers']);
          //return new Text(userDocument!["name"]);
        }
    );
    */
    /**/
  }
}
