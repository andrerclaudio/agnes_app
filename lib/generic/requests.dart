/*

Http related functions.
All requests are pointed to api.agnes.ooo

 */

import 'dart:convert';

import 'package:agnes_app/generic/constant.dart';
import 'package:agnes_app/models/book_item.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

// Send the User Email to Application ------------------------------------------
List<UserSignUpCredentials> userEmailInfo(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed
      .map<UserSignUpCredentials>(
          (json) => UserSignUpCredentials.fromJson(json))
      .toList();
}

Future<List<UserSignUpCredentials>> addEmailToApp(String email) async {
  final response = await http.Client().post(
    Uri.parse('http://192.168.0.163:8000/unknown/validate_email?email=$email'),
    // Uri.parse('http://api.agnes.ooo/unknown/validate_email?email=$email'),
    headers: {"Content-Type": "application/json"},
  );

  if ((response.statusCode == 200) || (response.statusCode == 201)) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return compute(userEmailInfo, response.body);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

// Send the Verification Code to Application -----------------------------------
List<UserSignUpCredentials> userCodeInfo(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed
      .map<UserSignUpCredentials>(
          (json) => UserSignUpCredentials.fromJson(json))
      .toList();
}

Future<List<UserSignUpCredentials>> checkVerificationCode(
    String email, String code) async {
  final response = await http.Client().get(
    Uri.parse(
        'http://192.168.0.163:8000/unknown/validate_code?email=$email&code=$code'),
    // 'http://api.agnes.ooo/unknown/validate_code?email=$email&code=$code'),
    headers: {"Content-Type": "application/json"},
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return compute(userCodeInfo, response.body);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

// Add User to Application -----------------------------------------------------
List<CreateUserForm> createUser(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed
      .map<CreateUserForm>((json) => CreateUserForm.fromJson(json))
      .toList();
}

Future<List<CreateUserForm>> addUserToApp(String email, String password) async {
  final response = await http.Client().post(
    Uri.parse(
        'http://192.168.0.163:8000/unknown/create_user?email=$email&password=$password'),
    // Uri.parse('http://api.agnes.ooo/unknown/create_user?email=$email'),
    headers: {"Content-Type": "application/json"},
  );

  if (response.statusCode == 201) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return compute(createUser, response.body);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

// -----------------------------------------------------------------------------

// Reading screen class
List<BookListStatus> parseBookListStatus(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed
      .map<BookListStatus>((json) => BookListStatus.fromJson(json))
      .toList();
}

Future<List<BookListStatus>> fetchBookListStatus(
    String email, String password) async {
  var temp = base64Encode('$email:$password'.codeUnits);

  final response = await http.Client().get(
    Uri.parse(Constant.apiReadingScreenURL),
    headers: {
      "Content-Type": "application/json",
      "authorization": 'Basic $temp'
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

Future<List<BookInfoByISBN>> fetchBookInfoByIsbn(
    String email, String password, String isbn) async {
  var temp = base64Encode('$email:$password'.codeUnits);

  final response = await http.Client().get(
    Uri.parse(
        'http://192.168.0.163:8000/library/fetch_book_information?isbnCode=$isbn'),
    // 'http://api.agnes.ooo/library/fetch_book_information?isbnCode=$isbn'),
    headers: {
      "Content-Type": "application/json",
      "authorization": 'Basic $temp'
    },
  );

  return compute(parseBookInfoByIsbn, response.body);
}

// Add Book by ISBN code class
List<BookAdded> newBookInfo(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<BookAdded>((json) => BookAdded.fromJson(json)).toList();
}

Future<List<BookAdded>> addNewBookToShelf(
    String email, String password, String isbn) async {
  var temp = base64Encode('$email:$password'.codeUnits);

  final response = await http.Client().post(
    Uri.parse(
        'http://192.168.0.163:8000/user/shelf/add_new_book?isbnCode=$isbn'),
    // 'http://api.agnes.ooo/user/shelf/add_new_book?isbnCode=$isbn'),
    headers: {
      "Content-Type": "application/json",
      "authorization": 'Basic $temp'
    },
  );

  return compute(newBookInfo, response.body);
}
