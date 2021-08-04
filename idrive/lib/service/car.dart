import 'dart:convert';
import 'package:idrive/model/make.dart';
import 'package:http/http.dart' as http;
import 'package:idrive/model/model.dart';

class CarService {

  Future<Makes> fetchAllMakes() async {
    final response =
    await http.get(Uri.parse('https://vpic.nhtsa.dot.gov/api/vehicles/getallmakes?format=json'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Makes.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load makes');
    }
  }


  Future<Models> fetchModelsByMake(String make) async {
    final response =
    await http.get(Uri.parse("https://vpic.nhtsa.dot.gov/api/vehicles/getmodelsformake/$make?format=json"));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Models.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load models');
    }
  }
}