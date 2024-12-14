import 'package:biezniappka/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';

class LeaderboardsPage extends StatefulWidget {
  const LeaderboardsPage({super.key});

  @override
  State<LeaderboardsPage> createState() => _LeaderboardsPageState();
}

enum Filter { day, week, month}

class _LeaderboardsPageState extends State<LeaderboardsPage> {
  Filter currentFilter = Filter.week;

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
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
                    "Leaderboards",
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
                    child: Row(
                      children: [
                        SizedBox(width: screenWidth * 0.02,),
                        Text(
                          "Top this",
                          style: TextStyle(color: Colors.white, fontSize: 24),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(width: screenWidth * 0.04,),
                        DropdownButtonHideUnderline(
                            child: DropdownButton<Filter>(
                              alignment: Alignment.bottomCenter,
                              dropdownColor: Color(0xFF554FFF),
                              value: currentFilter,
                              style: TextStyle(
                                
                                color: Colors.white,
                                fontSize: 24,
                                fontFamily: 'KronaOne'                               
                              ),
                              icon: Image.asset('files/customIcons/filterarrows.png'),
                              items: [
                          DropdownMenuItem(
                            value: Filter.day,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: Text("Day"),
                            ),
                          ),
                          DropdownMenuItem(
                            value: Filter.week,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: Text("Week"),
                            ),
                          ),
                          DropdownMenuItem(
                            value: Filter.month,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: Text("Month"),
                            ),
                          ),
                        ], onChanged: (Filter? newFilter) {
                          if(newFilter != null){
                            setState(() {
                              currentFilter = newFilter;
                            });
                          }
                        }))
                      ],
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
                    child: ListView.builder(
                      itemCount: dbService.friendsData.length + 1,
                      itemBuilder: (BuildContext context, int index){
                        List<(String, double)> nickScores = [];
                        nickScores.add((dbService.currentUserData.data.nick, dbService.currentUserData.data.getScore(currentFilter)));
                        for(final key in dbService.friendsData.keys){
                          nickScores.add((dbService.friendsData[key]!.nick, dbService.friendsData[key]!.getScore(currentFilter)));
                        }
                        nickScores.sort((a, b){
                          return b.$2.compareTo(a.$2);
                        });
                        return ListTile(
                          leading: Text("${index+1}."),
                          title: Text(nickScores[index].$1),
                          trailing: Text(nickScores[index].$2.toString()),
                        );
                    })
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
