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
  final bool successOnRequest;
  final int errorCode;
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
    required this.successOnRequest,
    required this.errorCode,
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
      successOnRequest: json['successOnRequest'] as bool,
      errorCode: json['errorCode'] as int,
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
  final bool successOnRequest;
  final int errorCode;
  final String title;
  final String author;
  final String publisher;
  final String isbn;
  final String pagesQty;
  final String genres;
  final String coverType;
  final String coverLink;
  final String ratingAverage;
  final String description;
  final String language;
  final String link;

  const BookInfoByISBN({
    required this.successOnRequest,
    required this.errorCode,
    required this.title,
    required this.author,
    required this.publisher,
    required this.isbn,
    required this.pagesQty,
    required this.genres,
    required this.coverType,
    required this.coverLink,
    required this.ratingAverage,
    required this.description,
    required this.language,
    required this.link,
  });

  factory BookInfoByISBN.fromJson(Map<String, dynamic> json) {
    return BookInfoByISBN(
      successOnRequest: json['successOnRequest'] as bool,
      errorCode: json['errorCode'] as int,
      title: json['title'] as String,
      author: json['author'] as String,
      publisher: json['publisher'] as String,
      isbn: json['isbn'] as String,
      pagesQty: json['pagesQty'] as String,
      genres: json['genres'] as String,
      coverType: json['coverType'] as String,
      coverLink: json['coverLink'] as String,
      ratingAverage: json['ratingAverage'] as String,
      description: json['description'] as String,
      language: json['language'] as String,
      link: json['link'] as String,
    );
  }
}

List<BookInfoByISBN> parseBookInfoByIsbn(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed
      .map<BookInfoByISBN>((json) => BookInfoByISBN.fromJson(json))
      .toList();
}

Future<List<BookInfoByISBN>> fetchBookInfoByIsbn(
    http.Client client, String isbn) async {
  final response = await client.get(
    Uri.parse(
        // 'http://192.168.0.163:8000/query?function=fetchBookInfo&isbn=$isbn'),
        'http://api.agnes.ooo/query?function=fetchBookInfo&isbn=$isbn'),
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

Future<List<BookAdded>> addNewBookToShelf(
    http.Client client, String isbn) async {
  final response = await client.post(
    Uri.parse(
        // 'http://192.168.0.163:8000/post?function=addNewBook&isbnCode=$isbn'),
        'http://api.agnes.ooo/post?function=addNewBook&isbnCode=$isbn'),
  );

  return compute(newBookInfo, response.body);
}
