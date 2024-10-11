import 'dart:math';
//import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:projecto_fcs/controller/CardProvider.dart';
import 'package:provider/provider.dart';


class ProjectCardSwiper extends StatefulWidget {
  final String url;
  final String tipo;
  final String projectID;
  final String question;
  final bool isFront;
  const ProjectCardSwiper({Key? key,
    required this.url,
    required this.isFront,
    required this.tipo,
    required this.projectID,
    required this.question,
  }) : super(key: key);

  @override
  State<ProjectCardSwiper> createState() => _ProjectCardSwiperState();
}

class _ProjectCardSwiperState extends State<ProjectCardSwiper> {

  //AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      final provider = Provider.of<CardProvider>(context, listen: false);
      provider.setScreenSize(size);
    });

    /*
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });

      audioPlayer.onDurationChanged.listen((newDuration) {
        setState(() {
          duration = newDuration;
        });
      });

      audioPlayer.onPositionChanged.listen((newPosition) {
        setState(() {
          position = newPosition;
        });
      });
    });
     */
  }

  @override
  Widget build(BuildContext context) => SizedBox.expand(
    child: widget.isFront ? buildFrontCard() : buildCard(),

    //child: buildCardSnd(),
    //child: widget.isFront ? buildFrontCard() : buildCardSnd(),
    //child: buildFrontCard()
  );

  Widget buildFrontCard() => GestureDetector(
    child: LayoutBuilder(
      builder: (context, constraints) {
        final provider = Provider.of<CardProvider>(context);
        final position = provider.position;
        final milliseconds = provider.isDragging ? 0 : 400;
        final center = constraints.smallest.center(Offset.zero);
        final angle = provider.angle * pi / 180;

        //provider.updateList();

        final rotatedMatrix = Matrix4.identity()..translate(center.dx, center.dy)..rotateZ(angle)..translate(-center.dx, -center.dy);
        return AnimatedContainer(
        duration: Duration(seconds: milliseconds),
        curve: Curves.easeInOut,
        transform: rotatedMatrix..translate(position.dx, position.dy),
        child: Stack(
            children: [
              buildCard(),
              //buildCardSnd(),
              /*
              //
              if (widget.tipo == 'image') ...[
                //DayScreen(),
                //buildFrontCard(),
                buildCard(),
              ] else ...[
                buildCardSnd(),
                //StatsScreen(),
              ]
               */
            ]
        ),
        );
      }
    ),
    onPanStart: (details){
      print('start');
      final provider = Provider.of<CardProvider>(context, listen: false);
      provider.startPosition(details);
    },
    onPanUpdate: (details){
      print('update');
      final provider = Provider.of<CardProvider>(context, listen: false);
      provider.updatePosition(details);
    },
    onPanEnd: (details){
      print('end');
      final provider = Provider.of<CardProvider>(context, listen: false);
      provider.endPosition();
    },
  );

  Widget buildCard() => ClipRRect(
    borderRadius: BorderRadius.circular(20.0),
    child: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(widget.url),
          fit: BoxFit.cover,
          //alignment: Alignment(-0.3, 0),
          alignment: Alignment(0, 0),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.transparent, Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.7, 1],
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              Spacer(),
              buildQuestion(),
            ],
          ),
        ),
      ),
    ),
  );

  Widget buildCardSnd() => ClipRRect(
    borderRadius: BorderRadius.circular(20.0),
    child: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/blank.png'),
          fit: BoxFit.cover,
          //alignment: Alignment(-0.3, 0),
          alignment: Alignment(0, 0),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.transparent, Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.7, 1],
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              Slider(
                min: 0,
                max: duration.inSeconds.toDouble(),
                value: position.inSeconds.toDouble(),
                onChanged: (value) async{
                  //final position = Duration(seconds: value.toInt());
                  //await audioPlayer.seek(position);
                  //await audioPlayer.resume();
                },
              ),
              CircleAvatar(
                radius: 35,
                child: IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    //Icons.pause,
                  ),
                  iconSize: 50,
                  onPressed: () async {
                    if (isPlaying){
                      //await audioPlayer.pause();
                    }else{
                      print('yyyyy');
                      //await audioPlayer.play(UrlSource(widget.url));
                    }
                  },
                ),
              ),
              //Spacer(),
              //buildQuestion(),
            ],
          ),
        ),
      ),
    ),
  );

  Widget buildQuestion() => Row(
    children: [
      Text(widget.question, style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),),
      const SizedBox(width: 16,),
      Text('', style: TextStyle(fontSize: 32, color: Colors.black),)
    ],
  );

}
