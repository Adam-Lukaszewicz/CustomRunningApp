import 'dart:convert';

import 'package:biezniappka/models/training_model.dart';

class AccountModel {
  int code;
  List<int> friendIds;
  List<TrainingModel> trainings;

  AccountModel({int? code, List<int>? friendIds, List<TrainingModel>? trainings})
      : code = code ?? 0,
        friendIds = friendIds ?? [],
        trainings = trainings ?? [];

  AccountModel.fromJson(Map<String, dynamic> json): this(
    code: jsonDecode(json["code"]),
    friendIds: List.from(jsonDecode(json["friend_ids"])),
    trainings: List.from(jsonDecode(json["trainings"])),
  );

  Map<String, dynamic> toJson(){
    return {
      "code": jsonEncode(code),
      "friend_ids":jsonEncode(friendIds),
      "trainings":jsonEncode(trainings),
    };
  }
}
