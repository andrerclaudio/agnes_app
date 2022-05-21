/*

Http related functions.
All requests are pointed to api.agnes.ooo

 */

import 'dart:convert';

import 'package:agnes_app/generic/constant.dart';
import 'package:agnes_app/models/book_item.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

// Reading screen class
List<BookListStatus> parseBookListStatus(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed
      .map<BookListStatus>((json) => BookListStatus.fromJson(json))
      .toList();
}

Future<List<BookListStatus>> fetchBookListStatus() async {
  const String token = '';
  final response = await http.Client().get(
    Uri.parse(Constant.apiReadingScreenURL),
    headers: {
      "Content-Type": "application/json",
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );

  return compute(parseBookListStatus, response.body);
}

// Fetch Book Info by ISBN code class
List<BookInfoByISBN> parseBookInfoByIsbn(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed
      .map<BookInfoByISBN>((json) => BookInfoByISBN.fromJson(json))
      .toList();
}

Future<List<BookInfoByISBN>> fetchBookInfoByIsbn(String isbn) async {
  const String token = '';
  final response = await http.Client().get(
    Uri.parse(
        'http://192.168.0.163:8000/query?function=fetchBookInfo&isbn=$isbn'),
    headers: {
      "Content-Type": "application/json",
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
    // 'http://api.agnes.ooo/query?function=fetchBookInfo&isbn=$isbn'),
  );

  return compute(parseBookInfoByIsbn, response.body);
}

// Add Book by ISBN code class
List<BookAdded> newBookInfo(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<BookAdded>((json) => BookAdded.fromJson(json)).toList();
}

Future<List<BookAdded>> addNewBookToShelf(String isbn) async {
  const String token = '';
  final response = await http.Client().post(
    Uri.parse(
        'http://192.168.0.163:8000/post?function=addNewBook&isbnCode=$isbn'),
    headers: {
      "Content-Type": "application/json",
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
    // 'http://api.agnes.ooo/post?function=addNewBook&isbnCode=$isbn'),
  );

  return compute(newBookInfo, response.body);
}

// Add Email to Application
List<EmailAdded> newEmailInfo(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<EmailAdded>((json) => EmailAdded.fromJson(json)).toList();
}

Future<List<EmailAdded>> addEmailToApp(String email) async {
  final response = await http.Client().post(
    Uri.parse(
        'http://192.168.0.163:8000/unknown?function=validateEmail&email=$email'),
    // 'http://api.agnes.ooo/unknown?function=validateEmail&email=$email'),
  );

  return compute(newEmailInfo, response.body);
}
