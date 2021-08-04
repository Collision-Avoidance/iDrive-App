// To parse this JSON data, do
//
//     final models = modelsFromJson(jsonString);

import 'dart:convert';

Models modelsFromJson(String str) => Models.fromJson(json.decode(str));

String modelsToJson(Models data) => json.encode(data.toJson());

class Models {
  Models({
    required this.count,
    required this.message,
    required this.searchCriteria,
    required this.results,
  });

  int count;
  String message;
  String searchCriteria;
  List<Result> results;

  factory Models.fromJson(Map<String, dynamic> json) => Models(
        count: json["Count"],
        message: json["Message"],
        searchCriteria: json["SearchCriteria"],
        results:
            List<Result>.from(json["Results"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Count": count,
        "Message": message,
        "SearchCriteria": searchCriteria,
        "Results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}

class Result {
  Result({
    required this.makeId,
    required this.makeName,
    required this.modelId,
    required this.modelName,
  });

  int makeId;
  String makeName;
  int modelId;
  String modelName;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        makeId: json["Make_ID"],
        makeName: json["Make_Name"],
        modelId: json["Model_ID"],
        modelName: json["Model_Name"],
      );

  Map<String, dynamic> toJson() => {
        "Make_ID": makeId,
        "Make_Name": makeName,
        "Model_ID": modelId,
        "Model_Name": modelName,
      };
}

