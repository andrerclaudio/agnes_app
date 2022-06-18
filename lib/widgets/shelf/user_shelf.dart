/*
User Shelf related methods.
 */

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

/* -----------------------------------------------------------------------------
Show the Users active or paused readings.
----------------------------------------------------------------------------- */

class UserReadingScreen extends StatefulWidget {
  const UserReadingScreen(
      {Key? key, required this.email, required this.password})
      : super(key: key);

  final String email;
  final String password;

  @override
  UserReadingScreenState createState() => UserReadingScreenState();
}

class UserReadingScreenState extends State<UserReadingScreen> {
  late Future<UserShelfBooks> futureData;
  late Future<List<UserShelfBooks>> _fetchBookList =
      fetchBookList(widget.email, widget.password);

  @override
  void initState() {
    super.initState();
    setState(() {
      _fetchBookList = fetchBookList(widget.email, widget.password);
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return FutureBuilder<List<UserShelfBooks>>(
      future: _fetchBookList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return BooksList(
            data: snapshot.data!,
            email: widget.email,
            password: widget.password,
          );
        } else if (snapshot.hasError) {
          if ('${snapshot.error}' ==
              'Invalid argument: "Unauthorized access"') {
            Future.delayed(const Duration(seconds: 0), () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LoginPage(title: 'Agnes')));

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
                      builder: (context) => const LoginPage(title: 'Agnes')));

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
      },
    );
  }
}

class BooksList extends StatefulWidget {
  const BooksList(
      {Key? key,
      required this.data,
      required this.email,
      required this.password})
      : super(key: key);

  final List<UserShelfBooks> data;
  final String email;
  final String password;

  @override
  State<BooksList> createState() => _BooksListState();
}

class _BooksListState extends State<BooksList> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    // Validate whether the answer is valid or not
    if (widget.data[0].successOnRequest) {
      return SizedBox(
        height: height,
        width: width,
        child: ListView.builder(
          padding: const EdgeInsets.all(2),
          itemCount: widget.data.length,
          itemBuilder: (context, index) {
            final Map bookInfo = widget.data[index].bookInfo;
            final String coverPic = bookInfo['coverPic'];
            final String title = bookInfo['title'];
            final String author = bookInfo['author'];
            final String publisher = bookInfo['publisher'];
            final String isbn = bookInfo['isbn'];
            final String pagesQty = bookInfo['pagesQty'];

            // Convert the CoverPic Json String object into Image
            final pic = json.decode(coverPic);
            Uint8List bytesImage = const Base64Decoder().convert(pic);
            Image bookCover = Image.memory(bytesImage);

            return Padding(
              padding: const EdgeInsets.fromLTRB(2, 2, 2, 8),
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
                            image: bookCover.image,
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
                            children: <Widget>[
                              Row(
                                children: [
                                  const Text(
                                    'Nome: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Flexible(
                                    child: Text(
                                      title,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'Autor: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                            width: 1.0, color: Color(Constant.objectsColor)),
                      ),
                    ),
                    height: height * 0.04,
                    width: width,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => BookDetailScreen(
                              email: widget.email,
                              password: widget.password,
                              bookCover: bookCover,
                              bookInfo: bookInfo,
                            ),
                          ),
                        );
                      },
                      child:
                          const Text('Clique aqui para ver mais detalhes ...'),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    } else {
      return const NoActiveOrPausedReadingFoundMessage();
    }
  }
}

/* -----------------------------------------------------------------------------
Show the Users shelf.
----------------------------------------------------------------------------- */

class UserShelfScreen extends StatefulWidget {
  const UserShelfScreen({Key? key, required this.email, required this.password})
      : super(key: key);

  final String email;
  final String password;

  @override
  State<UserShelfScreen> createState() => _UserShelfScreenState();
}

class _UserShelfScreenState extends State<UserShelfScreen> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}

/* -----------------------------------------------------------------------------
Books details.
----------------------------------------------------------------------------- */

class BookDetailScreen extends StatefulWidget {
  const BookDetailScreen(
      {Key? key,
      required this.bookInfo,
      required this.bookCover,
      required this.email,
      required this.password})
      : super(key: key);

  final Map bookInfo;
  final Image bookCover;
  final String email;
  final String password;

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final String title = widget.bookInfo['title'];
    final String author = widget.bookInfo['author'];
    final String publisher = widget.bookInfo['publisher'];
    final String isbn = widget.bookInfo['isbn'];
    final String pagesQty = widget.bookInfo['pagesQty'];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).padding.top),
        child: SizedBox(
          height: MediaQuery.of(context).padding.top,
        ),
      ),
      body: SizedBox(
        height: height,
        width: width,
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: <Widget>[
            Column(
              children: [
                Container(
                  height: height * 0.35,
                  width: width * 0.5,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      image: widget.bookCover.image,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Container(
                  height: height * 0.02,
                  color: Colors.white,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: height * 0.04,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  UpdateBookStatus(
                                email: widget.email,
                                password: widget.password,
                                bookStatus: 'finished',
                                targetBookId: widget.bookInfo['targetBookId'],
                              ),
                            ),
                          );
                        },
                        child: const Text('Finalizar'),
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          left: BorderSide(
                              width: 2.0, color: Color(Constant.objectsColor)),
                          right: BorderSide(
                              width: 2.0, color: Color(Constant.objectsColor)),
                        ),
                      ),
                      height: height * 0.04,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  UpdateBookStatus(
                                email: widget.email,
                                password: widget.password,
                                bookStatus: 'paused',
                                targetBookId: widget.bookInfo['targetBookId'],
                              ),
                            ),
                          );
                        },
                        child: const Text('Pausar'),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.04,
                      // width: width,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  UpdateBookStatus(
                                email: widget.email,
                                password: widget.password,
                                bookStatus: 'canceled',
                                targetBookId: widget.bookInfo['targetBookId'],
                              ),
                            ),
                          );
                        },
                        child: const Text('Cancelar'),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: height * 0.02,
                  color: Colors.white,
                ),
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
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
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
          ],
        ),
      ),
    );
  }
}

class UpdateBookStatus extends StatefulWidget {
  const UpdateBookStatus(
      {Key? key,
      required this.email,
      required this.password,
      required this.bookStatus,
      required this.targetBookId})
      : super(key: key);

  final String email;
  final String password;
  final String bookStatus;
  final String targetBookId;

  @override
  State<UpdateBookStatus> createState() => _UpdateBookStatusState();
}

class _UpdateBookStatusState extends State<UpdateBookStatus> {
  late final Future<List<BookStatus>> _updateBookStatus = changeBookStatus(
      widget.email, widget.password, widget.bookStatus, widget.targetBookId);
  late Future<BookStatus> futureData;

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
      body: FutureBuilder<List<BookStatus>>(
          future: _updateBookStatus,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<BookStatus> info = snapshot.data!;

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

                if (widget.bookStatus == 'finished') {
                  return AlertDialog(
                    backgroundColor: const Color(Constant.objectsColor),
                    title: const Text('Você finalizou o livro.'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: const <Widget>[
                          Text('Parabéns!'),
                        ],
                      ),
                    ),
                  );
                } else if (widget.bookStatus == 'canceled') {
                  return const AlertDialog(
                    backgroundColor: Color(Constant.objectsColor),
                    title: Text('Você cancelou a leitura, que pena!'),
                  );
                } else if (widget.bookStatus == 'paused') {
                  return AlertDialog(
                    backgroundColor: const Color(Constant.objectsColor),
                    title: const Text('Você pausou a leitura.'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: const <Widget>[
                          Text('Espero que retorne em breve!'),
                        ],
                      ),
                    ),
                  );
                }
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
