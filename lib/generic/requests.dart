/*

Http related functions.
All requests are pointed to api.agnes.ooo

 */

import 'dart:convert';

import 'package:agnes_app/generic/constant.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

// Reading screen class
class BookListStatus {
  final bool successOnRequest;
  final int errorCode;
  final bool readingInProgress;
  final bool readingPaused;
  final bool readingCanceled;
  final bool readingFinished;
  final Map bookInfo;

  const BookListStatus({
    required this.successOnRequest,
    required this.errorCode,
    required this.readingInProgress,
    required this.readingPaused,
    required this.readingCanceled,
    required this.readingFinished,
    required this.bookInfo,
  });

  factory BookListStatus.fromJson(Map<String, dynamic> json) {
    return BookListStatus(
      successOnRequest: json['successOnRequest'] as bool,
      errorCode: json['errorCode'] as int,
      readingInProgress: json['readingInProgress'] as bool,
      readingPaused: json['readingPaused'] as bool,
      readingCanceled: json['readingCanceled'] as bool,
      readingFinished: json['readingFinished'] as bool,
      bookInfo: json['bookInfo'] as Map,
    );
  }
}

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
class BookInfoByISBN {
  final bool successOnRequest;
  final int errorCode;
  final Map bookInfo;

  const BookInfoByISBN({
    required this.successOnRequest,
    required this.errorCode,
    required this.bookInfo,
  });

  factory BookInfoByISBN.fromJson(Map<String, dynamic> json) {
    return BookInfoByISBN(
      successOnRequest: json['successOnRequest'] as bool,
      errorCode: json['errorCode'] as int,
      bookInfo: json['bookInfo'] as Map,
    );
  }
}

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
class BookAdded {
  final bool successOnRequest;
  final int errorCode;
  final String title;
  final String isbn;

  const BookAdded({
    required this.successOnRequest,
    required this.errorCode,
    required this.title,
    required this.isbn,
  });

  factory BookAdded.fromJson(Map<String, dynamic> json) {
    return BookAdded(
      successOnRequest: json['successOnRequest'] as bool,
      errorCode: json['errorCode'] as int,
      title: json['title'] as String,
      isbn: json['isbn'] as String,
    );
  }
}

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
