/*
Add book to User Shelf methods.
 */

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:agnes_app/constant.dart';
import 'package:agnes_app/models/book_item.dart';
import 'package:agnes_app/services/requests.dart';
import 'package:agnes_app/views/home_view.dart';
import 'package:agnes_app/views/login_view.dart';
import 'package:agnes_app/widgets/errors_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AddNewBook extends StatefulWidget {
  const AddNewBook({Key? key, required this.email, required this.password})
      : super(key: key);

  final String email;
  final String password;

  @override
  State<AddNewBook> createState() => _AddNewBookState();
}

class _AddNewBookState extends State<AddNewBook> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).padding.top),
        child: SizedBox(
          height: MediaQuery.of(context).padding.top,
        ),
      ),
      body: _AskIsbnCode(email: widget.email, password: widget.password),
    );
  }
}

class _AskIsbnCode extends StatefulWidget {
  const _AskIsbnCode({Key? key, required this.email, required this.password})
      : super(key: key);

  final String email;
  final String password;

  @override
  _AskIsbnCodeState createState() => _AskIsbnCodeState();
}

class _AskIsbnCodeState extends State<_AskIsbnCode> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextEditingController isbnCode = TextEditingController();

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    // Build a Form widget using the _formKey created above.
    return SizedBox(
      height: height,
      width: width,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FocusTraversalGroup(
                  descendantsAreFocusable: true,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: isbnCode,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.format_size_sharp),
                      helperText:
                          'Você encontra o código ISBN próximo ao código de barras, no verso do livro. \nPor exemplo: 978-8576573937',
                      helperMaxLines: 4,
                      labelText: 'Digite o código ISBN',
                    ),
                    validator: (String? value) {
                      // TODO Think about it.
                      return (value == null || value.isEmpty)
                          ? 'Por favor, digite o código ISBN.\n\n'
                          : null;
                    },
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            const Color(Constant.objectsColor)),
                      ),
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => FetchBookInfo(
                                email: widget.email,
                                password: widget.password,
                                isbn: isbnCode.text,
                              ),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        'Procurar ...',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FetchBookInfo extends StatefulWidget {
  const FetchBookInfo(
      {Key? key,
      required this.email,
      required this.password,
      required this.isbn})
      : super(key: key);

  final String email;
  final String password;
  final String isbn;

  @override
  FetchBookInfoState createState() => FetchBookInfoState();
}

class FetchBookInfoState extends State<FetchBookInfo> {
  late Future<BookInformation> futureData;
  late final Future<List<BookInformation>> _fetchBookByIsbn =
      fetchBookInfoByIsbn(widget.email, widget.password, widget.isbn);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).padding.top),
        child: SizedBox(
          height: MediaQuery.of(context).padding.top,
        ),
      ),
      body: FutureBuilder<List<BookInformation>>(
          future: _fetchBookByIsbn,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return BookInfoByIsbn(
                  email: widget.email,
                  password: widget.password,
                  data: snapshot.data!);
            } else if (snapshot.hasError) {
              if ('${snapshot.error}' ==
                  'Invalid argument: "Unauthorized access"') {
                Future.delayed(const Duration(seconds: 0), () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const LoginPage(title: 'Agnes')));

                  // Unknown Error Message
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UnauthorizedAccessMessage(),
                    ),
                  );
                });
              } else {
                Future.delayed(const Duration(seconds: 0), () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const LoginPage(title: 'Agnes')));

                  // Unknown Error Message
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UnknownErrorMessage(),
                    ),
                  );
                });
              }
            }
            return Center(
              child: SpinKitChasingDots(
                color: const Color(Constant.objectsColor),
                size: width * 0.3,
                duration: const Duration(milliseconds: 1500),
              ),
            );
          }),
    );
  }
}

class BookInfoByIsbn extends StatefulWidget {
  const BookInfoByIsbn(
      {Key? key,
      required this.email,
      required this.password,
      required this.data})
      : super(key: key);

  final String email;
  final String password;
  final List<BookInformation> data;

  @override
  State<BookInfoByIsbn> createState() => _BookInfoByIsbnState();
}

class _BookInfoByIsbnState extends State<BookInfoByIsbn> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    if (widget.data[0].successOnRequest) {
      final Map bookInfo = widget.data[0].bookInfo;
      final String coverPic = bookInfo['coverPic'];
      final String title = bookInfo['title'];
      final String author = bookInfo['author'];
      final String publisher = bookInfo['publisher'];
      final String isbn = bookInfo['isbn'];
      final String pagesQty = bookInfo['pagesQty'];
      final String description = bookInfo['description'];
      // final String link = bookInfo['link'];
      // final String genres = bookInfo['genres'];
      // final String coverType = bookInfo['coverType'];
      // final String language = bookInfo['language'];
      // final String ratingAverage = bookInfo['ratingAverage'];

      // Convert the CoverPic Json String object into Image
      final pic = json.decode(coverPic);
      Uint8List bytesImage = const Base64Decoder().convert(pic);
      Image img = Image.memory(bytesImage);

      return SizedBox(
        height: height,
        width: width,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 4, 4),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: height * 0.25,
                    width: width * 0.35,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      image: DecorationImage(
                        image: img.image,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Container(
                    height: height * 0.25,
                    width: width * 0.01,
                    color: Colors.white,
                  ),
                  Expanded(
                    child: Container(
                      height: height * 0.25,
                      alignment: Alignment.topLeft,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Nome: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Flexible(
                                child: Text(
                                  title,
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                'Autor: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Flexible(
                                child: Text(
                                  author,
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                'Editora: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Flexible(
                                child: Text(
                                  publisher,
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                'Isbn: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Flexible(
                                child: Text(
                                  isbn,
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                'Qtd. de pág.: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Flexible(
                                child: Text(
                                  pagesQty,
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                description,
                maxLines: 10,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color(Constant.objectsColor),
                      minimumSize: Size(height * 0.2, 50),
                      maximumSize: Size(height * 0.2, 50),
                    ),
                    child: const Text(
                      'Iniciar leitura',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => AddNewBookToShelf(
                          email: widget.email,
                          password: widget.password,
                          isbn: isbn,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // const SizedBox(height: 10),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     ElevatedButton(
              //       style: ElevatedButton.styleFrom(
              //         primary: const Color(Constant.objectsColor),
              //         minimumSize: Size(height * 0.2, 50),
              //         maximumSize: Size(height * 0.2, 50),
              //       ),
              //       child: const Text(
              //         'Adicionar na Lista de Desejos',
              //         textAlign: TextAlign.center,
              //         style: TextStyle(
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //       onPressed: () => Navigator.pop(context, false),
              //     ),
              //   ],
              // ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color(Constant.objectsColor),
                      minimumSize: Size(height * 0.2, 50),
                      maximumSize: Size(height * 0.2, 50),
                    ),
                    child: const Text(
                      'Voltar',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () => Navigator.pop(context, false),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      return const NoBookFoundByIsbnMessage();
    }
  }
}

class AddNewBookToShelf extends StatefulWidget {
  const AddNewBookToShelf(
      {Key? key,
      required this.email,
      required this.password,
      required this.isbn})
      : super(key: key);

  final String email;
  final String password;
  final String isbn;

  @override
  State<AddNewBookToShelf> createState() => _AddNewBookToShelfState();
}

class _AddNewBookToShelfState extends State<AddNewBookToShelf> {
  late Future<BookAdded> futureData;
  late final Future<List<BookAdded>> _addNewBookToShelf =
      addNewBookToShelf(widget.email, widget.password, widget.isbn);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).padding.top),
        child: SizedBox(
          height: MediaQuery.of(context).padding.top,
        ),
      ),
      body: FutureBuilder<List<BookAdded>>(
          future: _addNewBookToShelf,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<BookAdded> info = snapshot.data!;

              if (info[0].successOnRequest) {
                Future.delayed(const Duration(seconds: 3), () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => HomePage(
                          email: widget.email, password: widget.password),
                    ),
                  );
                });

                return AlertDialog(
                  backgroundColor: const Color(Constant.objectsColor),
                  title: const Text('Você adicionou o livro a sua estante!'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: const <Widget>[
                        Text('A leitura foi iniciada.'),
                        Text('Você verá o livro na aba "Lendo".'),
                      ],
                    ),
                  ),
                );
              } else {
                if (info[0].errorCode ==
                    ErrorsConstants.noBookWasFoundWithTheGivenIsbnCode) {
                  return const NoBookFoundByIsbnMessage();
                } else if (info[0].errorCode ==
                    ErrorsConstants.bookHasAlreadyBeenAddedToBookShelf) {
                  return const BookAlreadyAddedToShelfMessage();
                }
              }
            } else if (snapshot.hasError) {
              if ('${snapshot.error}' ==
                  'Invalid argument: "Unauthorized access"') {
                Future.delayed(const Duration(seconds: 0), () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const LoginPage(title: 'Agnes')));

                  // Unknown Error Message
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UnauthorizedAccessMessage(),
                    ),
                  );
                });
              } else {
                Future.delayed(const Duration(seconds: 0), () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const LoginPage(title: 'Agnes')));

                  // Unknown Error Message
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UnknownErrorMessage(),
                    ),
                  );
                });
              }
            }

            return Center(
              child: SpinKitChasingDots(
                color: const Color(Constant.objectsColor),
                size: width * 0.3,
                duration: const Duration(milliseconds: 1500),
              ),
            );
          }),
    );
  }
}
