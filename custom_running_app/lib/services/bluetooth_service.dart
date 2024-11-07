import 'dart:io';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:path_provider/path_provider.dart';

class BluetoothService {
  static bool serviceEnabled = false;
  static void initBluetooth() async {
    if (await FlutterBluePlus.isSupported == false) {
      print("Bluetooth not supported by this device");
      return;
    }
    if (Platform.isAndroid) {
      await FlutterBluePlus.turnOn();
    }
  }

  static void reconnectToLastDevice() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    File savedId = File('${appDir.path}/remoteId');
    if (savedId.existsSync()) {
      print("found save id");
      String bluetoothId = await savedId.readAsString();
      await BluetoothDevice.fromId(bluetoothId).connect();
    }
  }

  static Stream<List<ScanResult>> getBluetoothDeviceList() {
    var subscription = FlutterBluePlus.onScanResults.listen(
      (results) {
        if (results.isNotEmpty) {
          ScanResult r = results.last; // the most recently found device
          print(
              '${r.device.remoteId}: "${r.advertisementData.advName}" found!');
        } else {
          print("no devices");
        }
      },
      onError: (e) => print(e),
    );

// cleanup: cancel subscription when scanning stops
    FlutterBluePlus.cancelWhenScanComplete(subscription);

    FlutterBluePlus.adapterState.listen((states) async {
      if (states == BluetoothAdapterState.on) {
        await FlutterBluePlus.startScan(
            // *or* any of the specified names
            timeout: Duration(seconds: 30));
      }
    });

// Start scanning w/ timeout
// Optional: use `stopScan()` as an alternative to timeout
    return FlutterBluePlus.onScanResults;
  }

  static void testDevice(BluetoothDevice device) async {
    // listen for disconnection
    var subscription =
        device.connectionState.listen((BluetoothConnectionState state) async {
      if (state == BluetoothConnectionState.disconnected) {
        // 1. typically, start a periodic timer that tries to
        //    reconnect, or just call connect() again right now
        // 2. you must always re-discover services after disconnection!
        print(
            "${device.disconnectReason?.code} ${device.disconnectReason?.description}");
      }
    });

// cleanup: cancel subscription when disconnected
//   - [delayed] This option is only meant for `connectionState` subscriptions.
//     When `true`, we cancel after a small delay. This ensures the `connectionState`
//     listener receives the `disconnected` event.
//   - [next] if true, the the stream will be canceled only on the *next* disconnection,
//     not the current disconnection. This is useful if you setup your subscriptions
//     before you connect.
    device.cancelWhenDisconnected(subscription, delayed: true, next: true);

// Connect to the device
    await device.connect();
    // Note: You must call discoverServices after every re-connection!
    var services = await device.discoverServices();
    services.forEach((service) {
      if (service.serviceUuid.toString() ==
          "cd9cfc21-0ecc-42e5-bf22-48aa715ca112") {
        service.characteristics.forEach((characteristic) async {
          if (characteristic.uuid.toString() ==
              "66E5FFCE-AA96-4DC9-90C3-C62BBCCD29AC".toLowerCase()) {
            String toWrite = "TEST";
            characteristic.write(toWrite.codeUnits);
          }
          if (characteristic.uuid.toString() ==
              "142F29DD-B1F0-4FA8-8E55-5A2D5F3E2471".toLowerCase()) {
            if (characteristic.properties.read) {
              List<int> value = await characteristic.read();
              print(String.fromCharCodes(value));
            }
          }
        });
      }
      // do something with service
    });

// Disconnect from device
    await device.disconnect();

// cancel to prevent duplicate listeners
    subscription.cancel();
  }

  static Future<void> connectToDevice(BluetoothDevice device) async {
    await device.connect();
    Directory appDir = await getApplicationDocumentsDirectory();
    File savedId = File('${appDir.path}/remoteId');
    if (!savedId.existsSync()) {
      savedId.create();
    } else {
      savedId.deleteSync();
    }
    savedId.writeAsString(device.remoteId.str);
  }

  static Future<void> disconnectFromDevice() async {
    if (FlutterBluePlus.connectedDevices.isEmpty)
      throw Exception("No connected devices");
    BluetoothDevice device = FlutterBluePlus.connectedDevices.first;
    await device.disconnect();
    Directory appDir = await getApplicationDocumentsDirectory();
    File('${appDir.path}/remoteId').deleteSync();
  }

  static void writeSpeedToDevice(int speed) {
    if (FlutterBluePlus.connectedDevices.isEmpty)
      throw Exception("No connected devices");
    BluetoothDevice device = FlutterBluePlus.connectedDevices.first;
  }

  static bool deviceConnected() {
    return FlutterBluePlus.connectedDevices.isNotEmpty;
  }
}
