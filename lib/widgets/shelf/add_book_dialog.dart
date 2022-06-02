import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:agnes_app/generic/requests.dart';
import 'package:agnes_app/models/book_item.dart';
import 'package:flutter/material.dart';

class AddNewBook extends StatefulWidget {
  const AddNewBook({Key? key}) : super(key: key);

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
      body: const _AskIsbnCode(),
    );
  }
}

class _AskIsbnCode extends StatefulWidget {
  const _AskIsbnCode({Key? key}) : super(key: key);

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
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (_formKey.currentState!.validate()) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => FetchBookInfo(
                                isbn: isbnCode.text,
                              ),
                            ),
                          );
                        }
                      },
                      child: const Text('Procurar ...'),
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
  const FetchBookInfo({Key? key, required this.isbn}) : super(key: key);
  final String isbn;

  @override
  FetchBookInfoState createState() => FetchBookInfoState();
}

class FetchBookInfoState extends State<FetchBookInfo> {
  late Future<BookInfoByISBN> futureData;
  late final Future<List<BookInfoByISBN>> _fetchBookByIsbn =
      fetchBookInfoByIsbn(widget.isbn);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).padding.top),
        child: SizedBox(
          height: MediaQuery.of(context).padding.top,
        ),
      ),
      body: FutureBuilder<List<BookInfoByISBN>>(
        future: _fetchBookByIsbn,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: height * 0.3,
                    width: width * 0.5,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('./assets/graphics/sorry.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  const Text(
                    'Ooops! Algo deu errado. Tente novamente.',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    softWrap: false,
                    overflow: TextOverflow.visible,
                  ),
                ],
              ),
            );
          } else if (snapshot.hasData) {
            return BookInfoByIsbn(data: snapshot.data!);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class BookInfoByIsbn extends StatelessWidget {
  const BookInfoByIsbn({Key? key, required this.data}) : super(key: key);

  final List<BookInfoByISBN> data;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    if (data[0].successOnRequest) {
      final Map bookInfo = data[0].bookInfo;
      final String coverPic = bookInfo['coverPic'];
      final String title = bookInfo['title'];
      final String author = bookInfo['author'];
      final String publisher = bookInfo['publisher'];
      final String isbn = bookInfo['isbn'];
      final String pagesQty = bookInfo['pagesQty'];
      // final String description = bookInfo['description'];
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
          padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
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
                      border: Border.all(
                        color: Colors.grey,
                        width: 2,
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
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.grey,
                          width: 2,
                        ),
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
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(height * 0.2, 50),
                      maximumSize: Size(height * 0.2, 50),
                    ),
                    child: const Text('Iniciar leitura'),
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => AddNewBookToShelf(
                          isbn: isbn,
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(height * 0.2, 50),
                      maximumSize: Size(height * 0.2, 50),
                    ),
                    child: const Text('Voltar'),
                    onPressed: () => Navigator.pop(context, false),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      return SizedBox(
        height: height,
        width: width,
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Container(
            height: height * 0.3,
            width: width * 0.5,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('./assets/graphics/question.png'),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ),
      );
    }
  }
}

class AddNewBookToShelf extends StatefulWidget {
  const AddNewBookToShelf({Key? key, required this.isbn}) : super(key: key);
  final String isbn;

  @override
  State<AddNewBookToShelf> createState() => _AddNewBookToShelfState();
}

class _AddNewBookToShelfState extends State<AddNewBookToShelf> {
  late Future<BookAdded> futureData;
  late final Future<List<BookAdded>> _addNewBookToShelf =
      addNewBookToShelf(widget.isbn);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

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
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: height * 0.3,
                    width: width * 0.5,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('./assets/graphics/sorry.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  const Text(
                    'Oops! Algo deu errado. Tente novamente.',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    softWrap: false,
                    overflow: TextOverflow.visible,
                  ),
                ],
              ),
            );
          } else if (snapshot.hasData) {
            // TODO - Parser the response.
            List<BookAdded> info = snapshot.data!;
            if (info[0].successOnRequest) {
              Future.delayed(const Duration(seconds: 3), () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/home', (route) => false);
              });

              return AlertDialog(
                backgroundColor: Colors.blueGrey[100],
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
              return Container(
                height: height * 0.3,
                width: width * 0.5,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('./assets/graphics/sorry.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
