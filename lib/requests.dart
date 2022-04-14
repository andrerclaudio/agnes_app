/*

Http related functions.
All requests are pointed to api.agnes.ooo

 */

import 'dart:convert';
import 'package:agnes_app/constant.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

// Reading screen class
class BookInfo {
  final bool readingInProgress;
  final bool readingPaused;
  final bool readingCanceled;
  final bool readingFinished;
  final String title;
  final String author;
  final String publisher;
  final String isbn;
  final String pagesQty;
  final String coverLink;

  const BookInfo({
    required this.readingInProgress,
    required this.readingPaused,
    required this.readingCanceled,
    required this.readingFinished,
    required this.title,
    required this.author,
    required this.publisher,
    required this.isbn,
    required this.pagesQty,
    required this.coverLink,
  });

  factory BookInfo.fromJson(Map<String, dynamic> json) {
    return BookInfo(
      readingInProgress: json['readingInProgress'] as bool,
      readingPaused: json['readingPaused'] as bool,
      readingCanceled: json['readingCanceled'] as bool,
      readingFinished: json['readingFinished'] as bool,
      title: json['title'] as String,
      author: json['author'] as String,
      publisher: json['publisher'] as String,
      isbn: json['isbn'] as String,
      pagesQty: json['pagesQty'] as String,
      coverLink: json['coverLink'] as String,
    );
  }
}

List<BookInfo> parseBookInfo(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<BookInfo>((json) => BookInfo.fromJson(json)).toList();
}

Future<List<BookInfo>> fetchBookInfo(http.Client client) async {
  final response = await client.get(Uri.parse(Constant.apiReadingScreenURL));

  return compute(parseBookInfo, response.body);
}

// Fetch Book Info by ISBN code class
class BookInfoByISBN {
  final String title;
  final String author;
  final String publisher;
  final String isbn;
  final String pagesQty;
  final String genres;
  final String coverType;
  final String coverLink;
  final String ratingAverage;

  const BookInfoByISBN({
    required this.title,
    required this.author,
    required this.publisher,
    required this.isbn,
    required this.pagesQty,
    required this.genres,
    required this.coverType,
    required this.coverLink,
    required this.ratingAverage,
  });

  factory BookInfoByISBN.fromJson(Map<String, dynamic> json) {
    return BookInfoByISBN(
      title: json['title'] as String,
      author: json['author'] as String,
      publisher: json['publisher'] as String,
      isbn: json['isbn'] as String,
      pagesQty: json['pagesQty'] as String,
      genres: json['genres'] as String,
      coverType: json['coverType'] as String,
      coverLink: json['coverLink'] as String,
      ratingAverage: json['ratingAverage'] as String,
    );
  }
}

List<BookInfoByISBN> parseBookInfoByIsbn(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed
      .map<BookInfoByISBN>((json) => BookInfoByISBN.fromJson(json))
      .toList();
}

Future<List<BookInfoByISBN>> fetchBookInfoByIsbn(http.Client client) async {
  final response = await client.get(Uri.parse(Constant.apiFetchBookInfoURL));

  return compute(parseBookInfoByIsbn, response.body);
}
