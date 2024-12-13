import 'dart:convert';

class TrainingModel {
  DateTime trainingDate;
  Duration timeTrained;
  double distance;
  double elevation;
  double score;

  TrainingModel({DateTime? trainingDate, Duration? timeTrained, double? distance,
      double? elevation, double? score})
      : trainingDate = trainingDate ?? DateTime.now(),
        timeTrained = timeTrained ?? Duration(),
        distance = distance ?? 0,
        elevation = elevation ?? 0,
        score = score ?? 0;

  TrainingModel.fromJson(Map<String, dynamic> json) : this(
    trainingDate: DateTime.parse(jsonDecode(json["training_date"])),
    timeTrained: jsonDecode(json["time_trained"]),
    distance: jsonDecode(json["distance"]),
    elevation: jsonDecode(json["elevation"]),
    score: jsonDecode(json["score"])
    );

  Map<String, dynamic> toJson(){
    return {
      "training_date" : trainingDate.toUtc().toIso8601String(),
      "time_trained" : jsonEncode(timeTrained),
      "distance" : jsonEncode(distance),
      "elevation" : jsonEncode(elevation),
      "score" : jsonEncode(score)
    };
  }
}
