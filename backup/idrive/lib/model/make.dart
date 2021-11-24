// To parse this JSON data, do
//
//     final makes = makesFromJson(jsonString);

import 'dart:convert';

Makes makesFromJson(String str) => Makes.fromJson(json.decode(str));

String makesToJson(Makes data) => json.encode(data.toJson());

class Makes {
  Makes({
    required this.count,
    required this.message,
    this.searchCriteria,
    required this.results,
  });

  int count;
  String message;
  dynamic searchCriteria;
  List<Result> results;

  factory Makes.fromJson(Map<String, dynamic> json) => Makes(
    count: json["Count"],
    message: json["Message"],
    searchCriteria: json["SearchCriteria"],
    results: List<Result>.from(json["Results"].map((x) => Result.fromJson(x))),
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
  });

  int makeId;
  String makeName;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    makeId: json["Make_ID"],
    makeName: json["Make_Name"],
  );

  Map<String, dynamic> toJson() => {
    "Make_ID": makeId,
    "Make_Name": makeName,
  };
}
