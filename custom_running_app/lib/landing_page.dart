import 'package:custom_running_app/home_page.dart';
import 'package:custom_running_app/services/bluetooth_service.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Stack(
        children: [Scaffold(
          body: Center(
            child: SizedBox(
              width: screenWidth * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(),
                  Text("TU LOGO KIEDYŚ"),
                  SizedBox(),
                  ElevatedButton(onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    await BluetoothService.initBluetooth();
                    await BluetoothService.reconnectToLastDevice();
                    setState(() {
                      _isLoading = false;
                    });
                    if(context.mounted){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(title: "title")));
                    }
                  }, child: Text("Rozpocznij"))
                ],
              ),
            ),
          ),
        ),
        if (_isLoading)
          const Opacity(
            opacity: 0.8,
            child: ModalBarrier(dismissible: false, color: Colors.black),
          ),
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
        ]
      ),
    );
  }
}
