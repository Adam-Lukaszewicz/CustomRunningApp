import 'package:custom_running_app/home_page.dart';
import 'package:custom_running_app/services/bluetooth_service.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

void main() {
  GetIt.I.registerSingleton<BluetoothService>(BluetoothService());
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'KronaOne',
        elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Color(0xAD9B3BA4),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
          textStyle: TextStyle(
            fontFamily: 'KronaOne',
            fontSize: 32
          )
        )),
      ),
      home: const HomePage(),
    );
  }
}
