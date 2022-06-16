/*
User Shelf related methods.
 */

import 'dart:convert';
import 'dart:typed_data';

import 'package:agnes_app/constant.dart';
import 'package:agnes_app/models/book_item.dart';
import 'package:agnes_app/services/requests.dart';
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
          return BooksList(data: snapshot.data!);
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

class BooksList extends StatelessWidget {
  const BooksList({Key? key, required this.data}) : super(key: key);

  final List<UserShelfBooks> data;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    // Validate whether the answer is valid or not
    if (data[0].successOnRequest) {
      return SizedBox(
        height: height,
        width: width,
        child: ListView.builder(
          padding: const EdgeInsets.all(2),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final Map bookInfo = data[index].bookInfo;
            final String coverPic = bookInfo['coverPic'];
            final String title = bookInfo['title'];
            final String author = bookInfo['author'];
            final String publisher = bookInfo['publisher'];
            final String isbn = bookInfo['isbn'];
            final String pagesQty = bookInfo['pagesQty'];

            // Convert the CoverPic Json String object into Image
            final pic = json.decode(coverPic);
            Uint8List bytesImage = const Base64Decoder().convert(pic);
            Image img = Image.memory(bytesImage);

            return Padding(
              padding: const EdgeInsets.fromLTRB(2, 2, 2, 4),
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
                    // color: Colors.white,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text('Detalhes sobre a leitura ...'),
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
