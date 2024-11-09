import 'package:custom_running_app/device_list_page.dart';
import 'package:custom_running_app/global%20widgets/default_app_bar.dart';
import 'package:custom_running_app/services/bluetooth_service.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

class HomePage extends WatchingStatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

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
    bool deviceConnected = watchPropertyValue((BluetoothService bt) => bt.isConnected);
    return Scaffold(
      appBar: DefaultAppBar(widget.title),
      body: Center(
          child: SizedBox(
        width: screenWidth * 0.9,
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          if (!deviceConnected)
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
          if (deviceConnected)
            ElevatedButton(
                onPressed: () async {
                  await GetIt.I.get<BluetoothService>().disconnectFromDevice();
                  setState(() {});
                },
                child: Text("Rozłącz z bieżnią"))
        ]),
      )),
    );
  }
}