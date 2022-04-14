import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../requests.dart';

class AddNewReading extends StatefulWidget {
  const AddNewReading({Key? key}) : super(key: key);

  @override
  State<AddNewReading> createState() => _AddNewReadingState();
}

class _AddNewReadingState extends State<AddNewReading> {
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
  _AskIsbnCodeState createState() {
    return _AskIsbnCodeState();
  }
}

class _AskIsbnCodeState extends State<_AskIsbnCode> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  // void _fetchBookInfo() {
  //   Navigator.of(context).push(
  //     MaterialPageRoute(
  //       builder: (BuildContext context) {
  //         return const FetchBookInfo();
  //       },
  //     ),
  //   );
  // }

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
      fetchBookInfoByIsbn(http.Client(), widget.isbn);

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
            return BookInfoByIsbn(info: snapshot.data!);
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
  const BookInfoByIsbn({Key? key, required this.info}) : super(key: key);

  final List<BookInfoByISBN> info;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    if (true) {
      return SizedBox(
        height: height,
        width: width,
        child: ListView.builder(
          padding: const EdgeInsets.all(2),
          itemCount: info.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(2, 2, 2, 4),
              child: Row(
                children: [
                  Container(
                    height: height * 0.25,
                    width: width * 0.35,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      image: DecorationImage(
                        image: NetworkImage(info[index].coverLink),
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
                                  info[index].title,
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
                                  info[index].author,
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
                                  info[index].publisher,
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
                                  info[index].isbn,
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
                                  info[index].pagesQty,
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
            );
          },
        ),
      );
    }
  }
}
