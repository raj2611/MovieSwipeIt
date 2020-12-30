import 'package:swipeit/swipe.dart';
import 'package:swipeit/results.dart';
import 'package:swipeit/size_utils.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  @override
  State createState() => new SplashPageState();
}

class SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  bool showFloatingButton = false;
  bool showTextInput = false;
  bool hideTextInput = false;
  double _top = 10;
  String inputName = "";
  AnimationController animationController;
  Animation<int> welcomeStringCount;
  List<String> namesSelected = [];
  static const String welcomeString =
      "Hey there! Lets swipe some good movies and save it for later to watch.";
  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
      duration: Duration(seconds: 5),
      vsync: this,
    );
    welcomeStringCount =
        StepTween(begin: 0, end: welcomeString.length).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeIn,
    ))
          ..addStatusListener((state) {
            if (state == AnimationStatus.completed) {
              setState(() {
                showFloatingButton = true;
              });
            }
          })
          ..addListener(() {
            setState(() {});
          });
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: new Scaffold(
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                Color.fromRGBO(33, 147, 176, 1),
                Color.fromRGBO(109, 213, 237, 1),
              ])),
          child: Stack(
            children: [
              welcomeStringCount == null ? null : getAnimatedCrossFade(),
              _getAnimatedText(),
              Align(
                alignment: Alignment.bottomRight,
                child: getAnimatedOpacityButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getAnimatedCrossFade() {
    return AnimatedCrossFade(
      duration: Duration(milliseconds: 800),
      alignment: Alignment.centerLeft,
      firstChild: _getTextTypewriterExplicitAnimation(),
      firstCurve: Curves.fastOutSlowIn,
      secondChild: _hideTextInputWidget(),
      secondCurve: Curves.easeIn,
      crossFadeState:
          showTextInput ? CrossFadeState.showSecond : CrossFadeState.showFirst,
    );
  }

  _getTextTypewriterExplicitAnimation() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: 250,
        margin: EdgeInsets.all(24),
        child: AnimatedBuilder(
          animation: welcomeStringCount,
          builder: (BuildContext context, Widget child) {
            String text = welcomeString.substring(0, welcomeStringCount.value);
            return Text(text,
                style: TextStyle(
                    height: 1.5,
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold));
          },
        ),
      ),
    );
  }

  _getAnimatedText() {
    return AnimatedPositioned(
      duration: Duration(seconds: 3),
      curve: Curves.bounceOut,
      child: _getAnimatedOpacityText(),
      top: _top,
      left: 16,
    );
  }

  _getAnimatedOpacityText() {
    return AnimatedOpacity(
      duration: Duration(seconds: 1),
      curve: Curves.easeIn,
      opacity: hideTextInput ? 1 : 0,
      child: InkWell(
        onTap: () {},
        child: Container(
          child: Text(
            "Hey, $inputName >",
            style: TextStyle(
                fontSize: 33, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  getAnimatedOpacityButton() {
    return AnimatedOpacity(
      duration: Duration(seconds: 1),
      curve: Curves.easeIn,
      opacity: showFloatingButton ? 1 : 0,
      child: getButton(),
    );
  }

  getButton() {
    return Padding(
      padding: EdgeInsets.all(24),
      child: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SwipeScreen(
                      cardData: [
                        {
                          'name': 'Before Sunrise',
                          'imagePath': 'assets/images/beforesunrise.jpg'
                        },
                        {
                          'name': 'Pulp Fiction',
                          'imagePath': 'assets/images/pulpfiction.jpg'
                        },
                        {
                          'name': 'Harry Potter',
                          'imagePath': 'assets/images/harrypotter.png',
                        },
                        {
                          'name': 'Tamasha',
                          'imagePath': 'assets/images/tamasha.jpg',
                        }
                      ],
                      onNo: () {
                        print('No');
                      },
                      onYes: () {
                        print('Yes');
                      },
                      onTap: () {
                        print('Tap');
                      },
                    )),
          );
        },
        backgroundColor: Colors.white,
        child: Icon(
          Icons.arrow_forward_ios,
          color: Colors.black38,
        ),
      ),
    );
  }

  _hideTextInputWidget() {
    return AnimatedOpacity(
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
      opacity: hideTextInput ? 0 : 1,
      child: _getTextInput(),
    );
  }

  _getTextInput() {
    return Padding(
      padding: EdgeInsets.all(32),
      child: Container(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                "Hey, May I know your name?",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 18,
              ),
              Theme(
                data: ThemeData(
                  splashColor: Colors.transparent,
                  primaryColor: Colors.white,
                  accentColor: Colors.white,
                  hintColor: Colors.white,
                ),
                child: TextFormField(
                  // onChanged: (value) {
                  //   setState(() {
                  //     inputName = value;
                  //   });
                  // },
                  // maxlines: 2,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(55.0),
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 1.0,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(55.0),
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 1.0,
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: Colors.black26,
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
