import 'dart:convert';

class TrainingModel {
  DateTime trainingDate;
  Duration timeTrained;
  double distance;
  double elevation;

  TrainingModel({DateTime? trainingDate, Duration? timeTrained, double? distance,
      double? elevation})
      : trainingDate = trainingDate ?? DateTime.now(),
        timeTrained = timeTrained ?? Duration(),
        distance = distance ?? 0,
        elevation = elevation ?? 0;

  TrainingModel.fromJson(Map<String, dynamic> json) : this(
    trainingDate: DateTime.parse(jsonDecode(json["training_date"])),
    timeTrained: jsonDecode(json["time_trained"]),
    distance: jsonDecode(json["distance"]),
    elevation: jsonDecode(json["elevation"]) 
    );
}
