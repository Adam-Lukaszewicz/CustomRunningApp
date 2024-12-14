import 'dart:convert';

import 'package:biezniappka/models/training_model.dart';
import 'package:biezniappka/services/database_service.dart';
import 'package:biezniappka/subpages/leaderboards_page.dart';
import 'package:watch_it/watch_it.dart';

class AccountModel {
  int code;
  String nick;
  List<int> friendIds;
  List<TrainingModel> trainings;
  Map<String, double> cachedScores;

  AccountModel(
      {int? code,
      String? nick,
      List<int>? friendIds,
      List<TrainingModel>? trainings,
      Map<String, double>? cachedScores})
      : code = code ?? 0,
        nick = nick ?? "Guest",
        friendIds = friendIds ?? [],
        trainings = trainings ?? [],
        cachedScores = cachedScores ??
            <String, double>{"day": 0, "week": 0, "month": 0, "total": 0};

  AccountModel.fromJson(Map<String, dynamic> json)
      : this(
            code: jsonDecode(json["code"]),
            nick: json["nick"],
            friendIds: List.from(jsonDecode(json["friend_ids"])),
            cachedScores: Map.castFrom(jsonDecode(json["cached_scores"])).map(
                (key, value) => MapEntry(key.toString(), value as double)));

  Map<String, dynamic> toJson() {
    return {
      "code": jsonEncode(code),
      "nick": nick,
      "friend_ids": jsonEncode(friendIds),
      "cached_scores": jsonEncode(cachedScores)
    };
  }

  void updateCache(){
    double dayScore = 0;
    double weekScore = 0;
    double monthScore = 0;
    double totalScore = 0;
    for (var training in trainings) {
      totalScore += training.score;
      if(DateTime.now().difference(training.trainingDate).inDays < 30){
        monthScore += training.score;
        if(DateTime.now().difference(training.trainingDate).inDays < 7){
          weekScore += training.score;
          if(DateTime.now().difference(training.trainingDate).inDays < 1){
            dayScore += training.score;
          }
        }
      }
    }
    cachedScores.update("day", (value) => dayScore);
    cachedScores.update("week", (value) => weekScore);
    cachedScores.update("month", (value) => monthScore);
    cachedScores.update("total", (value) => totalScore);
  }
  
  double getScore(Filter filter){
    return switch(filter){
      Filter.day => cachedScores["day"]!,
      Filter.week => cachedScores["week"]!,
      Filter.month => cachedScores["month"]!,
    };
  }

  void setNickname(String nickname){
    nick = nickname;
    GetIt.I.get<DatabaseService>().updateAccount(this);
  }
  
  Future<bool> addFriend(int code) async {
    var dbService = GetIt.I.get<DatabaseService>();
    for (var friendCode in friendIds){
      if(friendCode == code){
        return false;
      }
    }
    if(await dbService.checkCodeViability(code)){
      friendIds.add(code);
      dbService.updateAccount(this);
      dbService.updateFriends();
      return true;
    }else{
      return false;
    }
  }
}
