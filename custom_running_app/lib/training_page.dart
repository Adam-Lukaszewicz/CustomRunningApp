import 'dart:async';

import 'package:custom_running_app/global%20widgets/default_app_bar.dart';
import 'package:custom_running_app/services/bluetooth_service.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

class TrainingPage extends StatefulWidget {
  const TrainingPage({super.key});

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
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
    var screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Scaffold(
          appBar: DefaultAppBar("Trening"),
          body: Center(
            child: SizedBox(
              width: screenWidth * 0.9,
              child: Column(
                children: [
                  Row(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              speed--;
                              GetIt.I.get<BluetoothService>().writeSpeedToDevice(speed);
                            });
                          }, child: Icon(Icons.remove)),
                      Text("$speed"),
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              speed++;
                              GetIt.I.get<BluetoothService>().writeSpeedToDevice(speed);
                            });
                          }, child: Icon(Icons.add)),
                    ],
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              angle--;
                              GetIt.I.get<BluetoothService>().writeAngleToDevice(angle);
                            });
                          }, child: Icon(Icons.remove)),
                      Text("$angle"),
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              angle++;
                              GetIt.I.get<BluetoothService>().writeAngleToDevice(angle);
                            });
                          }, child: Icon(Icons.add)),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        if (_inCountdown)
          const Opacity(
            opacity: 1,
            child: ModalBarrier(dismissible: false, color: Colors.green),
          ),
        if (_inCountdown)
          Center(
              child: Text(
            "$counterBuffer",
            style: TextStyle(
              color: Colors.white,
              fontSize: screenWidth * 0.35,
              //TODO: Usunąć dziwne żółte podkreślenie z nikąd
            ),
          )),
      ],
    );
  }
}
