/*

Erros Dialogs Widgets.

 */

import 'package:flutter/material.dart';

class ErrorsConstants {
  // success = 100
  static const noActiveOrPausedReadingWasFound = 101;
  static const noBookWasFoundWithTheGivenIsbnCode = 102;
  static const bookHasAlreadyBeenAddedToBookShelf = 103;
  static const emailHasAlreadyBeenAddedToApplication = 104;
  static const wrongValidationCode = 105;
  static const emailAlreadyChecked = 106;
}

class WrongValidationCodeMessage extends StatelessWidget {
  const WrongValidationCodeMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
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
              'Oops! O código que você digitou não é o mesmo que foi enviado'
              'para o seu email.\n'
              'Tente novamente, por favor!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              softWrap: true,
              overflow: TextOverflow.visible,
              maxLines: 4,
            ),
          ],
        ),
      ),
    );
  }
}

class UnknownErrorMessage extends StatelessWidget {
  const UnknownErrorMessage({Key? key}) : super(key: key);

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
      body: SizedBox(
        height: height,
        width: width,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: height * 0.3,
                  width: width * 0.5,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('./assets/graphics/problem.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const Text(
                  'Oops! Alguma coisa inesperada aconteceu.\n'
                  'Tente novamente, por favor!',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  maxLines: 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UnauthorizedAccessMessage extends StatelessWidget {
  const UnauthorizedAccessMessage({Key? key}) : super(key: key);

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
      body: SizedBox(
        height: height,
        width: width,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
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
                  'Usuário ou senha incorretos!',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  maxLines: 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EmailAlreadyCheckedMessage extends StatelessWidget {
  const EmailAlreadyCheckedMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
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
              'Oops! O email já foi verificado.\n'
              'Use as suas credenciais para iniciar!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              softWrap: true,
              overflow: TextOverflow.visible,
              maxLines: 4,
            ),
          ],
        ),
      ),
    );
  }
}

class EmailAlreadyInUseMessage extends StatelessWidget {
  const EmailAlreadyInUseMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
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
              'Oops! O email que você está digitando já está sendo utilizado.\n'
              'Tente outro, por favor!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              softWrap: true,
              overflow: TextOverflow.visible,
              maxLines: 4,
            ),
          ],
        ),
      ),
    );
  }
}

class NoBookFoundByIsbnMessage extends StatelessWidget {
  const NoBookFoundByIsbnMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
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
              'Oops! Não encontrei o livro utilizando o código ISBN digitado.\n'
              'Confirme o código e tente novamente, por favor!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              softWrap: true,
              overflow: TextOverflow.visible,
              maxLines: 4,
            ),
          ],
        ),
      ),
    );
  }
}

class BookAlreadyAddedToShelfMessage extends StatelessWidget {
  const BookAlreadyAddedToShelfMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
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
              'Oops! Esse mesmo livro já está na sua estante.\n'
              'Confirme o código e tente novamente, por favor!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              softWrap: true,
              overflow: TextOverflow.visible,
              maxLines: 4,
            ),
          ],
        ),
      ),
    );
  }
}

class NoActiveOrPausedReadingFoundMessage extends StatelessWidget {
  const NoActiveOrPausedReadingFoundMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

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
