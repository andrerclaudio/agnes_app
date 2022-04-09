/*

Http related functions.
All requests are pointed to api.agnes.ooo

 */

import 'dart:convert';
import 'package:agnes_app/constant.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class BookInfo {
  final String bookName;
  final String bookAuthor;
  final String bookPublisher;
  final String bookIsbn;
  final String bookQtyPages;
  final String bookCoverLink;

  const BookInfo({
    required this.bookName,
    required this.bookAuthor,
    required this.bookPublisher,
    required this.bookIsbn,
    required this.bookQtyPages,
    required this.bookCoverLink,
  });

  factory BookInfo.fromJson(Map<String, dynamic> json) {
    return BookInfo(
      bookName: json['bookName'] as String,
      bookAuthor: json['bookAuthor'] as String,
      bookPublisher: json['bookPublisher'] as String,
      bookIsbn: json['bookIsbn'] as String,
      bookQtyPages: json['bookQtyPages'] as String,
      bookCoverLink: json['bookCoverLink'] as String,
    );
  }
}

List<BookInfo> parseBookInfo(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<BookInfo>((json) => BookInfo.fromJson(json)).toList();
}

Future<List<BookInfo>> fetchBookInfo(http.Client client) async {
  final response = await client.get(Uri.parse(Constant.apiBaseURL));

  return compute(parseBookInfo, response.body);
}
