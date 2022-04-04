/*

Http related functions.
All requests are pointed to api.agnes.ooo

 */

import 'dart:convert';
import 'dart:io';
import 'package:agnes_app/constant.dart';
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
  try {
    final response = await http.get(
      Uri.parse(Constant.apiBaseURL),
      // headers: {
      //   "Authorization":
      //       ''
      // },
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Data.fromJson(jsonDecode(response.body));
    } else {
      return Data.fromJson({"dollarRate": "0.00"});
    }
  } on SocketException {
    return Data.fromJson({"dollarRate": "0.00"});
  } on HttpException {
    return Data.fromJson({"dollarRate": "0.00"});
  } on FormatException {
    return Data.fromJson({"dollarRate": "0.00"});
  }
}
