import 'dart:math';
import 'package:flutter/material.dart';
import 'package:swipeit/results.dart';
import 'package:swipeit/size_utils.dart';

class SwipeScreen extends StatefulWidget {
  SwipeScreen({
    Key key,
    this.cardData,
    this.onYes,
    this.onNo,
    this.onTap,
  }) : super(key: key);

  final List cardData;

  final Function onYes;
  final Function onNo;
  final Function onTap;

  final Map<String, double> chartData = {};

  @override
  _SwipeScreenState createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen>
    with TickerProviderStateMixin {
  double opacityPos = 1.0;
  bool showNext = false;
  bool swipeLeft = true;
  bool _visible = false;
  AnimationController animation;
  int currentIndex = 0;
  Offset _swipe;
  Animation<double> _size;
  double _xPos = 80.toWidth;
  bool swipeStart = false;
  bool swipedRight = false;
  bool swipedLeft = false;
  bool yes = false;
  bool no = false;
  bool smallCardVisible = false;
  AnimationController controller;
  Animation<double> offsetAnimation;
  Animation<double> offsetAnimationRight;
  Animation<double> offsetAnimationAngle;
  final animatedAngleValue = pi / 66;
  List<String> namesSelected = [];
  @override
  void initState() {
    super.initState();

    _swipe = Offset.zero;
    animation = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    _size = Tween<double>(begin: 0.0, end: 1.0).animate(animation)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _visible = true;
          animation.reset();
        }
      });
    _size.addListener(() {
      setState(() {});
    });
    controller = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);

    offsetAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        }
        if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
    offsetAnimation.addListener(() {
      setState(() {});
    });

    offsetAnimationAngle =
        Tween<double>(begin: -animatedAngleValue, end: animatedAngleValue)
            .animate(controller)
              ..addStatusListener((status) {
                if (status == AnimationStatus.completed) {
                  controller.reverse();
                }
                if (status == AnimationStatus.dismissed) {
                  controller.forward();
                }
              });
    offsetAnimationAngle.addListener(() {
      setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.forward();
    });
  }

  int pageIndex = 0;
  double _angle = 0;
  String splitTextHeader(String text) {
    var splitText = text.split(' ');
    text = '${splitText[0]}\n${splitText.sublist(1).join(' ')}';
    return text;
  }

  @override
  void dispose() {
    controller.dispose();
    animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
              Color.fromRGBO(33, 147, 176, 1),
              Color.fromRGBO(109, 213, 237, 1),
            ])),
        child: IndexedStack(
          index: pageIndex,
          children: [
            for (var i = 0; i < widget.cardData.length; i++)
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: 0.toHeight, top: 100.toHeight),
                      child: Opacity(
                        opacity: (i == 0
                            ? swipeStart
                                ? _size.value
                                : 1.0
                            : _visible
                                ? swipeStart
                                    ? _size.value
                                    : 1.0
                                : (_size.value)),
                        child: Text(
                          widget.cardData[i]['name'],
                          style: TextStyle(
                              height: 36 / 32,
                              color: Colors.white,
                              fontSize: 66.toFont,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.6.toWidth),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Container(
                      height:
                          (MediaQuery.of(context).size.height - 200.toHeight),
                      width: MediaQuery.of(context).size.width,
                      child: Align(
                        alignment: Alignment.center,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Opacity(
                              opacity: no ? opacityPos : 0,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 150.toHeight, right: 30.toWidth),
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    'Not Interested',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 55.toFont,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      height: 22 / 18,
                                      letterSpacing: 1.6.toWidth,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Opacity(
                              opacity: yes ? opacityPos : 0,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 150.toHeight, left: 30.toWidth),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'Will Watch',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 55.toFont,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      height: 22 / 18,
                                      letterSpacing: 1.6.toWidth,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: _xPos,
                              child: GestureDetector(
                                onPanDown: (details) {},
                                onPanStart: (gesture) {},
                                onPanUpdate: (gesture) {
                                  setState(() {
                                    _swipe = _swipe + gesture.delta;
                                    _xPos = _swipe.dx;
                                    var opa =
                                        ((MediaQuery.of(context).size.width -
                                                    150.toWidth) -
                                                (_xPos.abs() - 80.toWidth)) /
                                            (MediaQuery.of(context).size.width -
                                                150.toWidth);

                                    if (opa > 0 && opa < 1.0) {
                                      opacityPos = opa;
                                    }
                                    if (_swipe.dx < -85.toWidth) {
                                      smallCardVisible = true;
                                    } else if (_swipe.dx > 165.toWidth) {
                                      smallCardVisible = true;
                                    } else {
                                      smallCardVisible = false;
                                    }
                                    if (_swipe.dx > 80.toWidth) {
                                      _angle = pi / 16;
                                      controller.stop();
                                      swipeStart = true;
                                      yes = true;
                                      no = false;
                                    } else if (_swipe.dx < 80.toWidth) {
                                      _angle = -pi / 16;
                                      controller.stop();
                                      swipeStart = true;
                                      no = true;
                                      yes = false;
                                    } else {
                                      swipeStart = false;

                                      _angle = 0;
                                    }
                                  });
                                },
                                onPanEnd: (gesture) {
                                  setState(() {
                                    _xPos = _swipe.dx;
                                    if (_swipe.dx < -60.toWidth) {
                                      swipedLeft = true;

                                      _xPos =
                                          -MediaQuery.of(context).size.width;
                                      widget.onNo();
                                      i == widget.cardData.length - 1
                                          ? widget.onTap()
                                          : resetAllData(i);
                                    } else if (_swipe.dx > 140.toWidth) {
                                      swipedRight = true;
                                      _xPos = MediaQuery.of(context).size.width;
                                      widget.onYes();
                                      namesSelected
                                          .add(widget.cardData[i]['name']);
                                      i == widget.cardData.length - 1
                                          ? Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ResultScreen(
                                                        data: namesSelected,
                                                      )),
                                            )
                                          : resetAllData(i);
                                    } else {
                                      controller.reset();
                                      controller.forward();

                                      smallCardVisible = false;

                                      _angle = 0.0;
                                      _swipe = Offset.zero;
                                      _xPos = 80.toWidth;
                                      swipedLeft = false;
                                      swipedRight = false;
                                      swipeStart = false;
                                      yes = false;
                                      no = false;
                                    }
                                  });
                                },
                                child: Transform.scale(
                                  scale: (i == 0
                                      ? 1
                                      : _visible
                                          ? 1
                                          : (_size.value)),
                                  child: Transform.rotate(
                                    angle: controller.isAnimating
                                        ? offsetAnimationAngle.value
                                        : _angle,
                                    child: Opacity(
                                      opacity: (i == 0
                                          ? swipeStart
                                              ? opacityPos
                                              : 1.0
                                          : _visible
                                              ? swipeStart
                                                  ? opacityPos
                                                  : 1.0
                                              : (_size.value)),
                                      child: Container(
                                        margin: EdgeInsets.all(0.0),
                                        padding: EdgeInsets.only(
                                            left: controller.isAnimating
                                                ? 16.toWidth -
                                                    (offsetAnimation.value *
                                                        16.toWidth)
                                                : 0.0,
                                            right: controller.isAnimating
                                                ? 6.0
                                                : 0),
                                        child: Container(
                                          height: 800.toHeight,
                                          width: 500.toWidth,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(12.0),
                                              gradient: LinearGradient(
                                                  begin: Alignment.topRight,
                                                  end: Alignment.bottomLeft,
                                                  colors: [
                                                    Color.fromRGBO(
                                                        33, 147, 176, 1),
                                                    Color.fromRGBO(
                                                        109, 213, 237, 1),
                                                  ])),
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                left: 60.toWidth,
                                                top: 80.toHeight,
                                                child: Icon(
                                                  Icons.arrow_back_ios,
                                                  size: 55,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Positioned(
                                                right: 60.toWidth,
                                                top: 80.toHeight,
                                                child: Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: Colors.white,
                                                  size: 55,
                                                ),
                                              ),
                                              Center(
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.0),
                                                  child: Image.asset(
                                                    widget.cardData[i]
                                                        ['imagePath'],
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void resetAllData(i) {
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        _visible = false;
        pageIndex = i + 1;
        _angle = 0.0;
        _swipe = Offset.zero;
        _xPos = 80.toWidth;
        swipedLeft = false;
        swipedRight = false;
        swipeStart = false;
        yes = false;
        no = false;
        controller.reset();
        controller.forward();
      });
      animation.forward();
    });
  }
}
