import 'package:projecto_fcs/deprecated/widgets/bottom_bar.dart';
import 'package:projecto_fcs/deprecated/widgets/carousel.dart';
import 'package:projecto_fcs/deprecated/widgets/featured_heading.dart';
import 'package:projecto_fcs/deprecated/widgets/featured_tiles.dart';
import 'package:projecto_fcs/deprecated/widgets/floating_quick_access_bar.dart';
import 'package:projecto_fcs/deprecated/widgets/main_heading.dart';
import 'package:projecto_fcs/deprecated/widgets/menu_drawer.dart';
import 'package:projecto_fcs/deprecated/widgets/top_bar_contents.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  double _scrollPosition = 0;
  double _opacity = 0;

  _scrollListener() {
    setState(() {
      _scrollPosition = _scrollController.position.pixels;
    });
  }

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    _opacity = _scrollPosition < screenSize.height * 0.40
        ? _scrollPosition / (screenSize.height * 0.40)
        : 1;

    return Scaffold(
      //o que faz a imagem ficar atrás dos botões da AppBar
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size(screenSize.width, 70),
        child: TopBarContents(_opacity),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    child: SizedBox(
                      height: screenSize.height * 0.65,
                      width: screenSize.width,
                      child: Image.asset(
                        'assets/images/background.png',
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      FloatingQuickAccessBar(screenSize: screenSize),
                      FeaturedHeading(screenSize: screenSize),
                      FeaturedTiles(screenSize: screenSize),
                      MainHeading(screenSize: screenSize),
                      MainCarousel(),
                      SizedBox(height: screenSize.height/10),
                      BottomBar(),
                    ],
                  ),
                ],
              ),
            ],
          ),
      ),
    );
  }
}
