import 'package:flutter/material.dart';
import 'package:projecto_fcs/pages/searchResult.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  final Mycontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          color: Colors.white,
          child: Center(
            child: Row(
              children: [
              Flexible(
                flex: 3,
                child: Container(
                  color: Colors.blue,
                  child: TextField(
                    controller: Mycontroller,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(90.0)),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'type your search',
                      hintStyle: TextStyle(color: Colors.white),
                    )),
                ),
              ),
                SizedBox(width: 4,),
                Flexible(
                  flex: 1,
                  child: ElevatedButton(
                      onPressed: (){
                        print(Mycontroller.text.toString());
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SearchResults(search: Mycontroller.text.toString(),)));
                      },
                      child: Text('Search')
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
