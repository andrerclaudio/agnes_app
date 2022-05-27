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
        'http://192.168.0.163:8000/library/fetch_book_information?isbnCode=$isbn'),
    headers: {
      "Content-Type": "application/json",
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
    // 'http://api.agnes.ooo/library/fetch_book_information?isbnCode=$isbn'),
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
        'http://192.168.0.163:8000/user/shelf/add_new_book?isbnCode=$isbn'),
    headers: {
      "Content-Type": "application/json",
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
    // 'http://api.agnes.ooo/user/shelf/add_new_book?isbnCode=$isbn'),
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
    Uri.parse('http://192.168.0.163:8000/unknown/validate_email?email=$email'),
    // 'http://api.agnes.ooo/unknown/validate_email?email=$email'),
  );

  return compute(newEmailInfo, response.body);
}

// Add User to Application
List<CreateUser> newUserInfo(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<CreateUser>((json) => CreateUser.fromJson(json)).toList();
}

Future<List<CreateUser>> addUserToApp(String email) async {
  final response = await http.Client().post(
    Uri.parse('http://192.168.0.163:8000/unknown/create_user?email=$email'),
    // 'http://api.agnes.ooo/unknown/create_user?email=$email'),
  );

  return compute(newUserInfo, response.body);
}
