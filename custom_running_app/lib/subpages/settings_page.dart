import 'package:biezniappka/login/login_page.dart';
import 'package:biezniappka/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    var titleCategoryTextStyle =
        TextStyle(fontWeight: FontWeight.w500, fontSize: screenWidth * 0.05, color: Colors.white);
    var subtitleCategoryTextStyle = TextStyle(fontSize: screenWidth * 0.04, color: Colors.white);
    var dbService = GetIt.I.get<DatabaseService>();
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
                    "Settings",
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
                  Expanded(
                    child: ListView(
                      children: [
                        Card(
                          color: Color(0xAD9B3BA4),
                          elevation: 5,
                          child: ListTile(
                            onTap: dbService.loggedIn
                                ? () {}
                                : () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage()),
                                    );
                                  },
                            leading: dbService.loggedIn
                                ? Icon(
                                    Icons.logout,
                                    size: screenWidth * 0.08,
                                    color: Colors.white,
                                  )
                                : Icon(
                                    Icons.login,
                                    size: screenWidth * 0.08,
                                    color: Colors.white,
                                  ),
                            title: dbService.loggedIn
                                ? Text(
                                    "Log out",
                                    style: titleCategoryTextStyle,
                                  )
                                : Text(
                                    "Log in",
                                    style: titleCategoryTextStyle,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}
