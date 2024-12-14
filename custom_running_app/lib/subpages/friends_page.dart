import 'package:biezniappka/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:watch_it/watch_it.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  late TextEditingController inputCode;

  @override
  void initState() {
    super.initState();
    inputCode = TextEditingController();
  }

  @override
  void dispose() {
    inputCode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    var dbService = GetIt.I.get<DatabaseService>();
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
            SizedBox(
              height: screenHeight * .05,
            ),
            Text(
              "Manage friends",
              style: TextStyle(color: Colors.white, fontSize: 35, shadows: [
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
            Text(
              "Your code:",
              style: TextStyle(color: Colors.white, fontSize: 30, shadows: [
                BoxShadow(
                    blurRadius: 4,
                    offset: Offset(0, 4),
                    color: Color(0x40000000))
              ]),
              textAlign: TextAlign.center,
            ),
            Text(
              dbService.currentUserData.data.code.toString(),
              style: TextStyle(color: Colors.white, fontSize: 30, shadows: [
                BoxShadow(
                    blurRadius: 4,
                    offset: Offset(0, 4),
                    color: Color(0x40000000))
              ]),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: screenHeight * .1,
            ),
            SizedBox(
              width: screenWidth * 0.8,
              child: TextField(
                controller: inputCode,
                cursorColor: Colors.white,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text(
                      "Input your friend's code",
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ),
            SizedBox(
              height: screenHeight * .02,
            ),
            ElevatedButton(
              onPressed: () async {
                bool result = await dbService.currentUserData.data
                    .addFriend(int.parse(inputCode.text));
                String info = result ? "Successfully added friend" : "Failed to add friend";
              },
              child: Text(
                "Add friend",
                style: TextStyle(fontSize: 18),
              ),
            )
          ]),
        )),
      ),
    );
  }
}
