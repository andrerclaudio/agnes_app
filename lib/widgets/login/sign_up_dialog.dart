import 'package:agnes_app/generic/requests.dart';
import 'package:agnes_app/models/book_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';

class SigUpInit extends StatefulWidget {
  const SigUpInit({Key? key}) : super(key: key);

  @override
  State<SigUpInit> createState() => _SigUpInitState();
}

class _SigUpInitState extends State<SigUpInit> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextEditingController email = TextEditingController();

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
                      controller: email,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.email),
                        labelText: 'Digite o email que será cadastrado!',
                      ),
                      validator: (String? value) {
                        // TODO Think about it.
                        return (value == null || value.isEmpty)
                            ? 'Por favor, digite um e-mail válido!\n\n'
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
                                builder: (BuildContext context) =>
                                    WaitEmailValidation(
                                  email: email.text,
                                ),
                              ),
                            );
                          }
                        },
                        child: const Text('Cadastrar e-mail ...'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class WaitEmailValidation extends StatefulWidget {
  const WaitEmailValidation({Key? key, required this.email}) : super(key: key);

  final String email;

  @override
  State<WaitEmailValidation> createState() => _WaitEmailValidationState();
}

class _WaitEmailValidationState extends State<WaitEmailValidation> {
  late Future<EmailAdded> futureData;
  late final Future<List<EmailAdded>> _addEmailToApp =
      addEmailToApp(widget.email);

  bool _onEditing = true;

  // late String _code;

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
      body: FutureBuilder<List<EmailAdded>>(
        future: _addEmailToApp,
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
            List<EmailAdded> info = snapshot.data!;
            if (info[0].successOnRequest) {
              return Column(
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Center(
                      child: Text(
                        'Digite o código recebido no email cadastrado.',
                        overflow: TextOverflow.visible,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width,
                    child: Center(
                      child: VerificationCode(
                        keyboardType: TextInputType.number,
                        underlineColor: Colors.amber,
                        // If this is null it will use primaryColor: Colors.red from Theme
                        length: 6,
                        isSecure: true,
                        fullBorder: true,
                        cursorColor: Colors.blue,
                        onCompleted: (String value) {
                          setState(
                            () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WaitCodeConfirmation(
                                    code: value,
                                  ),
                                ),
                                ModalRoute.withName("/"),
                              );
                            },
                          );
                        },
                        onEditing: (bool value) {
                          setState(() {
                            _onEditing = value;
                          });
                          if (!_onEditing) FocusScope.of(context).unfocus();
                        },
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Center(
                  //     child: _onEditing
                  //         ? const Text('Please enter full code')
                  //         : Text('Your code: $_code'),
                  //   ),
                  // )
                ],
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

class WaitCodeConfirmation extends StatefulWidget {
  const WaitCodeConfirmation({Key? key, this.code}) : super(key: key);

  final String? code;

  @override
  State<WaitCodeConfirmation> createState() => _WaitCodeConfirmationState();
}

class _WaitCodeConfirmationState extends State<WaitCodeConfirmation> {
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
      body: SizedBox(width: width, height: height, child: Container()),
    );
  }
}
