import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../requests.dart';

class ReadingScreen extends StatefulWidget {
  const ReadingScreen({Key? key}) : super(key: key);

  @override
  ReadingScreenState createState() => ReadingScreenState();
}

class ReadingScreenState extends State<ReadingScreen> {
  late Future<BookInfo> futureData;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return FutureBuilder<List<BookInfo>>(
      future: fetchBookInfo(http.Client()),
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
          return BookReadingList(info: snapshot.data!);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class BookReadingList extends StatelessWidget {
  const BookReadingList({Key? key, required this.info}) : super(key: key);

  final List<BookInfo> info;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    var activeReadingIndex = <int>[];
    var pausedReadingIndex = <int>[];

    // Let's find the active readings and the ones that are paused
    for (int i = 0; i < info.length; i++) {
      if (info[i].readingInProgress) {
        activeReadingIndex.add(i);
      } else if (info[i].readingPaused) {
        pausedReadingIndex.add(i);
      }
    }

    if ((activeReadingIndex.isNotEmpty) || (pausedReadingIndex.isNotEmpty)) {
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
    } else {
      return SizedBox(
        height: height,
        width: width,
        child: const Text('Text'),
      );
    }
  }
}
