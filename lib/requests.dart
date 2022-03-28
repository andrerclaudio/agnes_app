/*

Http related functions.
All requests are pointed to api.agnes.ooo

 */

import 'dart:convert';

import 'package:http/http.dart' as http;

class Data {
  final String dollarRate;

  const Data({
    required this.dollarRate,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      dollarRate: json['dollarRate'],
    );
  }
}

Future<Data> fetchData() async {
  final response = await http.get(Uri.parse('http://api.agnes.ooo/currency'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Data.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load data');
  }
}
