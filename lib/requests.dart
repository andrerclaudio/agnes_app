/*

Http related functions.
All requests are pointed to api.agnes.ooo

 */

import 'dart:convert';

import 'package:http/http.dart' as http;

class Data {
  final String apiVersion;
  final String message;
  final String status;

  const Data({
    required this.apiVersion,
    required this.message,
    required this.status,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      apiVersion: json['apiVersion'],
      message: json['message'],
      status: json['status'],
    );
  }
}

Future<Data> fetchData() async {
  final response = await http.get(Uri.parse('http://api.agnes.ooo/'));

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
