import 'package:custom_running_app/device_list_page.dart';
import 'package:custom_running_app/global%20widgets/default_app_bar.dart';
import 'package:custom_running_app/services/bluetooth_service.dart';
import 'package:flutter/material.dart';

void main() async {
  await BluetoothService.reconnectToLastDevice();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: DefaultAppBar(widget.title),
      body: Center(
          child: SizedBox(
        width: screenWidth * 0.9,
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          if (!BluetoothService.deviceConnected())
            Card(
              child: ListTile(
                onTap: () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DeviceListPage()))
                      .then((onValue) {
                    setState(() {});
                  });
                },
                title: Text("Nie połączono z urządzeniem"),
              ),
            ),
          if (BluetoothService.deviceConnected())
            ElevatedButton(
                onPressed: () async {
                  await BluetoothService.disconnectFromDevice();
                  setState(() {});
                },
                child: Text("Rozłącz z bieżnią"))
        ]),
      )),
    );
  }
}
