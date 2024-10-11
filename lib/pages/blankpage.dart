import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../controller/optimizedText.dart';

class CanvasBlankPage extends StatefulWidget {
  const CanvasBlankPage({Key? key}) : super(key: key);

  @override
  State<CanvasBlankPage> createState() => _CanvasState();
}

class _CanvasState extends State<CanvasBlankPage> {
  bool _isSelected = false;

  bool _dl = false;
  bool _art = false;
  bool _cg = false;
  final double spacing = 8.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            SizedBox(height: 200,),
            ChoiceChips(),
          ],
        )
      ),
    );
  }

  Widget buildFilterChips() => Wrap(
    runSpacing: 4.0,
    spacing: 4.0,
    children: [],
  );

  Widget buildChips() => Chip(
    labelPadding: EdgeInsets.all(4),
    avatar: CircleAvatar(
      child: Icon(Icons.voice_chat_sharp),
      backgroundColor: Colors.red.withOpacity(0.8),
    ),
    label: Text('Chip'),
    labelStyle: TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    backgroundColor: Colors.red,
  );

  Widget ChoiceChips() => Center(
    child: Wrap(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ChoiceChip(
              label: const Text('Art'),
              selected: _isSelected,
              selectedColor: Colors.blueAccent,
              onSelected: (newBoolValue){
                setState(() {
                  _isSelected = newBoolValue;
                });
              },
            ),
            ChoiceChip(
              label: const Text('Computer Graphics'),
              selected: _isSelected,
              selectedColor: Colors.greenAccent,
              onSelected: (newBoolValue){
                setState(() {
                  _isSelected = newBoolValue;
                });
              },
            ),
            ChoiceChip(
              label: const Text('Deep Learning'),
              selected: _isSelected,
              selectedColor: Colors.yellowAccent,
              onSelected: (newBoolValue){
                setState(() {
                  _isSelected = newBoolValue;
                });
              },
            ),
          ],
        ),
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ChoiceChip(
                label: const Text('Education'),
                selected: _isSelected,
                selectedColor: Colors.blueAccent,
                onSelected: (newBoolValue){
                  setState(() {
                    _isSelected = newBoolValue;
                  });
                },
              ),
              ChoiceChip(
                label: const Text('Conservation'),
                selected: _isSelected,
                selectedColor: Colors.greenAccent,
                onSelected: (newBoolValue){
                  setState(() {
                    _isSelected = newBoolValue;
                  });
                },
              ),
              ChoiceChip(
                label: const Text('Computing'),
                selected: _isSelected,
                selectedColor: Colors.yellowAccent,
                onSelected: (newBoolValue){
                  setState(() {
                    _isSelected = newBoolValue;
                  });
                },
              ),
              ChoiceChip(
                label: const Text('Mathematics'),
                selected: _isSelected,
                selectedColor: Colors.yellowAccent,
                onSelected: (newBoolValue){
                  setState(() {
                    _isSelected = newBoolValue;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    ),

  );
}

class FilterChipExampleState extends StatefulWidget {
  final List filters_;
  FilterChipExampleState({Key? key, required this.filters_}) : super(key: key);

  @override
  State<FilterChipExampleState> createState() => _FilterChipExampleStateState();
}

class _FilterChipExampleStateState extends State<FilterChipExampleState> {
  final _filters = [];

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //widget.filters_,
          Text('Hey'),
        ].map((filterType){
          return FilterChip(label: Text(filterType.toString()),
            backgroundColor: Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0),
            selected: _filters.contains(filterType),
            onSelected: (val) {
              setState(() {
                if(val){
                  _filters.add(filterType);
                }else{
                  _filters.removeWhere((name) {
                    return name == filterType;
                  });
                }
              });
            },
          );
        }).toList(),
      ),
    );
  }
}

class InjectData extends StatefulWidget {
  const InjectData({Key? key}) : super(key: key);

  @override
  State<InjectData> createState() => _InjectDataState();
}

class _InjectDataState extends State<InjectData> {

  ui_loginPage UI_loginPage = ui_loginPage.empty();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ClipOval(
          child: Material(
            color: Colors.blue, // Button color
            child: InkWell(
              splashColor: Colors.red, // Splash color
              onTap: () {
                UI_loginPage.getVersion();
              },
              child: SizedBox(width: 56, height: 56, child: Icon(Icons.menu)),
            ),
          ),
        )    ,
      ),
    );
  }
}

