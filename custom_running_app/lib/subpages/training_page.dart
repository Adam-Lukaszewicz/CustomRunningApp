import 'dart:async';
import 'dart:math';

import 'package:elliptical_progress_bar/elliptical_progress_bar.dart';
import 'package:flutter/material.dart';

class TrainingPage extends StatefulWidget {
  const TrainingPage({super.key});

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  bool training = true;
  double elevationClimbed = 0;
  double distanceTravalled = 0;
  late Timer trainingTimer;
  int timeElapsed = -4;
  double incline = 0;
  double speed = 0;
  @override
  void initState() {
    super.initState();
    trainingTimer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (training) {
        setState(() {
          timeElapsed++;
        });
      }
    });
  }

  @override
  void dispose() {
    trainingTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Center(
      child: SizedBox(
        width: screenWidth * 0.8,
        child: Column(
          children: [
            SizedBox(
              height: screenHeight * .05,
            ),
            Container(
              height: screenHeight * .3,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(11),
                  color: Color(0xAD9B3BA4),
                  boxShadow: [
                    BoxShadow(
                        color: Color(0x40000000),
                        spreadRadius: 0,
                        blurRadius: 4,
                        offset: Offset(0, 4)),
                  ]),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                        EllipticalProgressBar(
                          fillColor: Colors.green,
                          bgColor: Color(0xFFB19292),
                          progress: distanceTravalled%400/400,
                          showCenterProgress: false,
                          thickness: 15,
                        ),
                        Image.asset('files/track.png')
                        ]
                      )
                    ],
                  ),
            ),
            SizedBox(
              height: screenHeight * .03,
            ),
            SizedBox(
              height: screenHeight * .251,
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        height: screenHeight * .12,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(35),
                            color: Color(0xAD9B3BA4),
                            boxShadow: [
                              BoxShadow(
                                  color: Color(0x40000000),
                                  spreadRadius: 0,
                                  blurRadius: 4,
                                  offset: Offset(0, 4)),
                            ]),
                        child: Column(
                          children: [
                            SizedBox(
                              height: screenHeight * .01,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: screenWidth * .04),
                                  child: Text(
                                    "Elevation",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(right: screenWidth * .04),
                                  child: Text(
                                    "Duration",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: screenWidth * .04),
                                  child: Text(
                                    "${elevationClimbed.toStringAsFixed(0)} m",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 26),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(right: screenWidth * .04),
                                  child: Text(
                                    "${timeElapsed ~/ 60}:${timeElapsed % 60}",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 26),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * .011,
                      ),
                      Container(
                        height: screenHeight * .12,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(35),
                            color: Color(0xAD9B3BA4),
                            boxShadow: [
                              BoxShadow(
                                  color: Color(0x40000000),
                                  spreadRadius: 0,
                                  blurRadius: 4,
                                  offset: Offset(0, 4)),
                            ]),
                        child: Column(
                          children: [
                            SizedBox(
                              height: screenHeight * .015,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: screenWidth * .04),
                                  child: Text(
                                    incline.toStringAsFixed(1),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 26),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(right: screenWidth * .04),
                                  child: Text(
                                    speed.toStringAsFixed(1),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 26),
                                  ),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: screenWidth * .04),
                                  child: Text(
                                    "Incline",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(right: screenWidth * .04),
                                  child: Text(
                                    "Speed",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: FilledButton(
                        style: FilledButton.styleFrom(
                          shape: CircleBorder(),
                        ),
                        onPressed: () {
                          setState(() {
                            training = !training;
                          });
                        },
                        child: training
                            ? Icon(
                                Icons.pause,
                                size: screenWidth * .3,
                                color: Colors.black,
                              )
                            : Icon(
                                Icons.play_arrow,
                                size: screenWidth * .3,
                                color: Colors.black,
                              )),
                  )
                ],
              ),
            ),
            SizedBox(height: screenHeight * .03,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: screenHeight * .2,
                  width: screenWidth * .25,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      color: Color(0xAD9B3BA4),
                      boxShadow: [
                        BoxShadow(
                            color: Color(0x40000000),
                            spreadRadius: 0,
                            blurRadius: 4,
                            offset: Offset(0, 4)),
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ClipPath(
                        clipper: UpwardTriangleClipper(),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              incline += 0.5;
                            });
                          },
                          child: Container(
                            width: screenWidth * .22,
                            height: screenHeight * 0.05,
                            decoration: BoxDecoration(
                            color: Color(0XFF65306A),
                            ),
                          ),
                        ),
                      ),
                      Text("Incline", style: TextStyle(color: Colors.white, fontSize: 20),),
                      ClipPath(
                        clipper: DownwardTriangleClipper(),
                        child: InkWell(
                          onTap: (){
                            setState(() {
                              if(incline > 0){
                                incline -= 0.5;
                              }
                            });
                          },
                          child: Container(
                            width: screenWidth * .22,
                            height: screenHeight * 0.05,
                            decoration: BoxDecoration(
                            color: Color(0XFF65306A),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: screenWidth * 0.15,),
                Container(
                  height: screenHeight * .2,
                  width: screenWidth * .25,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(35),
                      color: Color(0xAD9B3BA4),
                      boxShadow: [
                        BoxShadow(
                            color: Color(0x40000000),
                            spreadRadius: 0,
                            blurRadius: 4,
                            offset: Offset(0, 4)),
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ClipPath(
                        clipper: UpwardTriangleClipper(),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              speed += 0.5;
                            });
                          },
                          child: Container(
                            width: screenWidth * .22,
                            height: screenHeight * 0.05,
                            decoration: BoxDecoration(
                            color: Color(0XFF65306A),
                            ),
                          ),
                        ),
                      ),
                      Text("Speed", style: TextStyle(color: Colors.white, fontSize: 20),),
                      ClipPath(
                        clipper: DownwardTriangleClipper(),
                        child: InkWell(
                          onTap: (){
                            setState(() {
                              if(speed > 0){
                                speed -= 0.5;
                              }
                            });
                          },
                          child: Container(
                            width: screenWidth * .22,
                            height: screenHeight * 0.05,
                            decoration: BoxDecoration(
                            color: Color(0XFF65306A),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DownwardTriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width/2, size.height);
    path.lineTo(0, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
  
}

class UpwardTriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width/2, 0);
    path.lineTo(0, size.height);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }

}