import 'dart:async';

import 'package:biezniappka/services/bluetooth_service.dart';
import 'package:biezniappka/subpages/leaderboards_page.dart';
import 'package:biezniappka/subpages/integration_page.dart';
import 'package:biezniappka/subpages/settings_page.dart';
import 'package:biezniappka/subpages/training_page.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

class ActivePage extends StatefulWidget {
  const ActivePage({super.key});

  @override
  State<ActivePage> createState() => _ActivePageState();
}

class _ActivePageState extends State<ActivePage> {
  int currentIndex = 0;
  List<Widget> bodies = [
    TrainingPage(),
    LeaderboardsPage(),
    IntegrationPage(),
    SettingsPage(),
  ];

  bool _inCountdown = true;
  late Timer startBuffer;
  int counterBuffer = 3;

  int speed = 0;
  int angle = 0;

  @override
  void initState() {
    super.initState();
    startBuffer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        counterBuffer--;
        if (counterBuffer == 0) {
          _inCountdown = false;
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF554FFF), Color(0xFFCE5521)]),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black38, spreadRadius: 0, blurRadius: 10),
                  ]),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: NavigationBar(
                    onDestinationSelected: (newIndex) {
                      setState(() {
                        currentIndex = newIndex;
                      });
                    },
                    selectedIndex: currentIndex,
                    backgroundColor: Color(0x8AFF8F53),
                    indicatorColor: Colors.transparent,
                    labelBehavior:
                        NavigationDestinationLabelBehavior.alwaysHide,
                    destinations: [
                      NavigationDestination(
                        icon: Image.asset(
                          'files/bottomNavBar/training.png',
                          width: 50,
                          height: 50,
                        ),
                        label: "Training",
                        selectedIcon: Image.asset(
                          'files/bottomNavBar/training.png',
                          width: 50,
                          height: 50,
                          color: Color(0x9CE9FC95),
                        ),
                      ),
                      NavigationDestination(
                          icon: Image.asset(
                            'files/bottomNavBar/achievments.png',
                            width: 50,
                            height: 50,
                          ),
                          label: "Achievments",
                          selectedIcon: Image.asset(
                          'files/bottomNavBar/achievments.png',
                          width: 50,
                          height: 50,
                          color: Color(0x9CE9FC95),
                        ),),
                      NavigationDestination(
                          icon: Image.asset(
                            'files/bottomNavBar/integration.png',
                            width: 50,
                            height: 50,
                          ),
                          label: "Integration",
                          selectedIcon: Image.asset(
                          'files/bottomNavBar/integration.png',
                          width: 50,
                          height: 50,
                          color: Color(0x9CE9FC95),
                        ),),
                      NavigationDestination(
                          icon: Image.asset(
                            'files/bottomNavBar/settings.png',
                            width: 50,
                            height: 50,
                          ),
                          label: "Settings",
                          selectedIcon: Image.asset(
                          'files/bottomNavBar/settings.png',
                          width: 50,
                          height: 50,
                          color: Color(0x9CE9FC95),
                        ),),
                    ]),
              ),
            ),
            body: bodies.elementAt(currentIndex)
          ),
        ),
        if (_inCountdown)
          Scaffold(
            backgroundColor: Colors.purple,
            body: Center(
                child: Text(
              "$counterBuffer",
              style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth * 0.35,
              ),
            )),
          ),
      ],
    );
  }
}
