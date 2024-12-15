import 'package:biezniappka/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

class IntegrationPage extends StatefulWidget {
  const IntegrationPage({super.key});

  @override
  State<IntegrationPage> createState() => _IntegrationPageState();
}

class _IntegrationPageState extends State<IntegrationPage> {
  late bool local;

  @override
  void initState() {
    super.initState();
    local = GetIt.I.get<DatabaseService>().healthConnect;
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    var dbService = GetIt.I.get<DatabaseService>();
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF554FFF), Color(0xFFCE5521)]),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
            child: SizedBox(
          width: screenWidth * 0.9,
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            SizedBox(height: screenHeight * .1),
            Text(
              "Google Health Connect",
              style: TextStyle(color: Colors.white, fontSize: 40),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight * .05),
            Image.asset('files/ghclogo.png'),
            SizedBox(height: screenHeight * .12),
            Text(
              "Toggle integration with GHC",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            Switch(
                value: local,
                onChanged: (value) {
                  setState(() {
                    local = value;
                    dbService.savePref(value);
                  });
                })
          ]),
        )),
      ),
    );
  }
}
