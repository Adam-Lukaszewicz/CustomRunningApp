import 'package:custom_running_app/services/bluetooth_service.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

class DeviceListPage extends StatefulWidget {
  const DeviceListPage({super.key});

  @override
  State<DeviceListPage> createState() => _DeviceListPageState();
}

class _DeviceListPageState extends State<DeviceListPage> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Stack(children: [
      Container(
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
              width: screenWidth * 0.88,
              child: Column(
                children: [
                  SizedBox(
                    height: screenHeight * .05,
                  ),
                  Text(
                    "Connect to the treadmill",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        shadows: [
                          BoxShadow(
                              blurRadius: 4,
                              offset: Offset(0, 4),
                              color: Color(0x40000000))
                        ]),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: screenHeight * .12,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Bluetooth devices",
                      style: TextStyle(color: Colors.white, fontSize: 24),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFFA06DCC), Color(0xFFBD713A)]),
                          borderRadius: BorderRadius.circular(11),
                    ),
                    height: screenHeight * 0.5,
                    child: StreamBuilder(
                        stream: GetIt.I
                            .get<BluetoothService>()
                            .getBluetoothDeviceList(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Something went wrong');
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }

                          List<ListTile> listToReturn =
                              snapshot.data!.map((device) {
                            return ListTile(
                              onTap: () async {
                                setState(() {
                                  _isLoading = true;
                                });
                                await GetIt.I
                                    .get<BluetoothService>()
                                    .connectToDevice(device.device);
                                setState(() {
                                  _isLoading = false;
                                });
                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
                              },
                              title: Text(device.device.advName),
                              leading: Text(device.device.remoteId.str),
                            );
                          }).toList();
                          return ListView(
                            children: listToReturn,
                          );
                        }),
                  ),
                ],
              ),
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
    ]);
  }
}
