import 'package:agnes_app/Generic/requests.dart';
import 'package:flutter/material.dart';

class UserReadingScreen extends StatefulWidget {
  const UserReadingScreen({Key? key}) : super(key: key);

  @override
  UserReadingScreenState createState() => UserReadingScreenState();
}

class UserReadingScreenState extends State<UserReadingScreen> {
  late Future<BookListStatus> futureData;
  late final Future<List<BookListStatus>> _fetchBookListStatus =
      fetchBookListStatus();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return FutureBuilder<List<BookListStatus>>(
      future: _fetchBookListStatus,
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
          return BooksList(data: snapshot.data!);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class BooksList extends StatelessWidget {
  const BooksList({Key? key, required this.data}) : super(key: key);

  final List<BookListStatus> data;

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
            final String coverLink = bookInfo['coverLink'];
            final String title = bookInfo['title'];
            final String author = bookInfo['author'];
            final String publisher = bookInfo['publisher'];
            final String isbn = bookInfo['isbn'];
            final String pagesQty = bookInfo['pagesQty'];

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
                        image: NetworkImage(coverLink),
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
            );
          },
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
                image: AssetImage('./assets/graphics/no_books.png'),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ),
      );
    }
  }
}
