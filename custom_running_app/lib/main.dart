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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const HomePage(title: "title"),
    );
  }
}
