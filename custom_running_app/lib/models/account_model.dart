import 'dart:convert';

import 'package:biezniappka/models/training_model.dart';
import 'package:biezniappka/subpages/leaderboards_page.dart';

class AccountModel {
  int code;
  List<int> friendIds;
  List<TrainingModel> trainings;
  Map<String, double> cachedScores;

  AccountModel(
      {int? code,
      List<int>? friendIds,
      List<TrainingModel>? trainings,
      Map<String, double>? cachedScores})
      : code = code ?? 0,
        friendIds = friendIds ?? [],
        trainings = trainings ?? [],
        cachedScores = cachedScores ??
            <String, double>{"day": 0, "week": 0, "month": 0, "total": 0};

  AccountModel.fromJson(Map<String, dynamic> json)
      : this(
            code: jsonDecode(json["code"]),
            friendIds: List.from(jsonDecode(json["friend_ids"])),
            trainings: List.from(jsonDecode(json["trainings"])),
            cachedScores: Map.castFrom(jsonDecode(json["cached_scores"])).map(
                (key, value) => MapEntry(key.toString(), value as double)));

  Map<String, dynamic> toJson() {
    return {
      "code": jsonEncode(code),
      "friend_ids": jsonEncode(friendIds),
      "trainings": jsonEncode(trainings),
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
}
