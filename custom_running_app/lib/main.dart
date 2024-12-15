import 'package:biezniappka/home_page.dart';
import 'package:biezniappka/services/bluetooth_service.dart';
import 'package:biezniappka/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:watch_it/watch_it.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Health().configure();
  var types = [HealthDataType.DISTANCE_DELTA, HealthDataType.WORKOUT];
  var permissions = [HealthDataAccess.WRITE, HealthDataAccess.WRITE];
  bool? result = await Health().hasPermissions(types, permissions: permissions);
  if(result != null){
    if(result == false){
      await Health().requestAuthorization(types, permissions: permissions);
    }
  }
  GetIt.I.registerSingleton<BluetoothService>(BluetoothService());
  GetIt.I.registerSingleton<DatabaseService>(DatabaseService());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var dbService = GetIt.I.get<DatabaseService>();
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'KronaOne',
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color(0xAD9B3BA4),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11)),
                  textStyle: TextStyle(fontFamily: 'KronaOne', fontSize: 32))),
        ),
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              dbService.assignUserSpecificData();
            }
            return HomePage();
          },
        ));
  }
}
