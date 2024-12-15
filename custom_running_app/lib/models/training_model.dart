import 'dart:convert';

class TrainingModel {
  DateTime trainingStart;
  DateTime trainingEnd;
  Duration timeTrained;
  double distance;
  double elevation;
  double score;

  TrainingModel({DateTime? trainingStart, DateTime? trainingEnd, Duration? timeTrained, double? distance,
      double? elevation, double? score})
      : trainingStart = trainingStart ?? DateTime.now(),
        trainingEnd = trainingEnd ?? DateTime.now(),
        timeTrained = timeTrained ?? Duration(),
        distance = distance ?? 0,
        elevation = elevation ?? 0,
        score = score ?? 0;

  TrainingModel.fromJson(Map<String, dynamic> json) : this(
    trainingStart: DateTime.parse(json["training_start"]),
    trainingEnd: DateTime.parse(json["training_end"]),
    timeTrained: Duration(seconds: jsonDecode(json["time_trained"])),
    distance: jsonDecode(json["distance"]),
    elevation: jsonDecode(json["elevation"]),
    score: jsonDecode(json["score"])
    );

  Map<String, dynamic> toJson(){
    return {
      "training_start" : trainingStart.toUtc().toIso8601String(),
      "training_end" : trainingEnd.toUtc().toIso8601String(),
      "time_trained" : jsonEncode(timeTrained.inSeconds),
      "distance" : jsonEncode(distance),
      "elevation" : jsonEncode(elevation),
      "score" : jsonEncode(score)
    };
  }
}
