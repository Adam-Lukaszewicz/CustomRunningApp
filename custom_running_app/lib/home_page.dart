import 'package:biezniappka/device_list_page.dart';
import 'package:biezniappka/services/bluetooth_service.dart';
import 'package:biezniappka/active_page.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

class HomePage extends WatchingStatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    GetIt.I.get<BluetoothService>().reconnectToLastDevice();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    // bool deviceConnected = watchPropertyValue((BluetoothService bt) => bt.isConnected);
    bool deviceConnected = true; //TYLKO POD DEV UI
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
            // if (!deviceConnected)
            //   Card(
            //     child: ListTile(
            //       onTap: () {
            //         Navigator.push(
            //                 context,
            //                 MaterialPageRoute(
            //                     builder: (context) => DeviceListPage()))
            //             .then((onValue) {
            //           setState(() {});
            //         });
            //       },
            //       title: Text("Nie połączono z urządzeniem"),
            //     ),
            //   ),
            // ElevatedButton(
            //     onPressed: deviceConnected
            //         ? () {
            //             Navigator.push(
            //                 context,
            //                 MaterialPageRoute(
            //                     builder: (context) => TrainingPage()));
            //           }
            //         : null,
            //     child: Text("Trening")),
            // if (deviceConnected)
            //   ElevatedButton(
            //       onPressed: () async {
            //         await GetIt.I.get<BluetoothService>().disconnectFromDevice();
            //         setState(() {});
            //       },
            //       child: Text("Rozłącz z bieżnią"))
            SizedBox(height: screenHeight * .05),
            Image.asset('files/logo.png'),
            SizedBox(height: screenHeight * .05),
            Text(
              "Bieżniapka",
              style: TextStyle(color: Colors.white, fontSize: 40),
            ),
            SizedBox(height: screenHeight * .15),
            ElevatedButton(
              onPressed: deviceConnected
                  ? () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ActivePage()));
                    }
                  : () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DeviceListPage()));
                    },
              child: Text("Start"),
            ),
            SizedBox(height: screenHeight * .015),
            ElevatedButton(onPressed: () {}, child: Text("Settings")),
            SizedBox(height: screenHeight * .015),
            ElevatedButton(onPressed: () {}, child: Text("Achievments")),
          ]),
        )),
      ),
    );
  }
}
