import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:projecto_fcs/widgets/buttons.dart';
import 'HomeScreenMobile.dart';

class OnBoardingPage extends StatelessWidget {
  OnBoardingPage({Key? key}) : super(key: key);
  final _pwController = TextEditingController();
  @override
  Widget build(BuildContext context) => SafeArea(

      child: IntroductionScreen(
        pages: [
          PageViewModel(
            title: 'A Community built for the everyday person',
            body: 'Default lorem ipsum description',
            image: Lottie.network('https://assets10.lottiefiles.com/packages/lf20_j2rjqphu.json'),
            decoration: getPageDecoration()
          ),
          PageViewModel(
              title: 'Science at the palm of your hands',
              body: 'Default lorem ipsum description',
              image: Lottie.network('https://assets8.lottiefiles.com/packages/lf20_wzbqr5lv.json'),
              decoration: getPageDecoration()
          ),
          PageViewModel(
              title: 'Citizen Science made easy',
              //body: 'Default lorem ipsum description',
              bodyWidget: Container(
                child: Column(
                  children: <Widget>[
                    Padding(
                      //padding: const EdgeInsets.only(left:15.0, right: 15.0, top: 0, bottom: 0),
                      padding: const EdgeInsets.only(left:8.0, right: 8.0, top: 0, bottom: 0),
                      child: TextField(
                        controller: _pwController,
                        obscureText: true,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password',
                            hintText: '********'
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              image: Lottie.network('https://assets4.lottiefiles.com/packages/lf20_jmuq5aha.json'),
              decoration: getPageDecoration(),
              footer: MyButtonTheme(buttonText: 'heya', faIcon: FaIcon(FontAwesomeIcons.google, color: Colors.blue,), mycolor: Colors.white, ),
            /*SizedBox(
                height: 48,
                child: Container(
                  padding: const EdgeInsets.only(left:8.0, right: 8.0, top: 0, bottom: 0),
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.black,
                      minimumSize: Size(double.infinity, 50),
                    ),
                    icon: FaIcon(FontAwesomeIcons.google, color: Colors.red,),
                    label: Text('Start'),
                    onPressed: () {

                    },
                  ),
                ),
              )*/
          ),
        ],
        showBackButton: true,
        skipOrBackFlex: 0,
        nextFlex: 0,
        back: Text('Back',
          style: TextStyle(
            fontWeight: FontWeight.w300,
          )
        ),
        next: Icon(Icons.arrow_forward),
        dotsDecorator: getDotDecoration(),
        done: Text('Read',
        style: TextStyle(
          fontWeight: FontWeight.w300,
        ),
        ),
        onDone: () => goToHome(context),
      ),
  );

  void goToHome(context) => Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (_) => HomeScreenMobile()),
  );

  PageDecoration getPageDecoration() => PageDecoration(
    titleTextStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
    bodyTextStyle: TextStyle(fontSize: 20),
    bodyPadding: EdgeInsets.all(16).copyWith(bottom: 0),
    imagePadding: EdgeInsets.all(24),
    pageColor: Colors.white
  );

  DotsDecorator getDotDecoration() => DotsDecorator(
    color: Color(0xFFBDBDBD),
    activeColor: Colors.blue,
    size: Size(10, 10),
    activeSize: Size(22, 10),
    activeShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
  );
}
