import 'package:custom_running_app/global%20widgets/default_app_bar.dart';
import 'package:custom_running_app/services/bluetooth_service.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

class DeviceListPage extends StatefulWidget{
  const DeviceListPage({super.key});

  @override
  State<DeviceListPage> createState() => _DeviceListPageState();
}

class _DeviceListPageState extends State<DeviceListPage> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context){
    return Stack(
      children: [Scaffold(
        appBar: const DefaultAppBar("Wybierz urządzenie"),
        body: Center(
          child: Column(
            children: [
              Expanded(
            child: StreamBuilder(
                stream: GetIt.I.get<BluetoothService>().getBluetoothDeviceList(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }
      
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
      
                  List<ListTile> listToReturn = snapshot.data!.map((device) {
                    return ListTile(
                      onTap: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        await GetIt.I.get<BluetoothService>().connectToDevice(device.device);
                        setState(() {
                          _isLoading = false;
                        });
                        if(context.mounted){
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
    );
  }
}