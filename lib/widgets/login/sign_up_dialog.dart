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
  late Future<VerificationStep> futureData;
  late final Future<List<VerificationStep>> _addEmailToApp =
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
      body: FutureBuilder<List<VerificationStep>>(
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
            List<VerificationStep> info = snapshot.data!;
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
                                    email: widget.email,
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
  const WaitCodeConfirmation({Key? key, this.code, required this.email})
      : super(key: key);

  final String? code;
  final String email;

  @override
  State<WaitCodeConfirmation> createState() => _WaitCodeConfirmationState();
}

class _WaitCodeConfirmationState extends State<WaitCodeConfirmation> {
  late Future<VerificationStep> futureData;
  late final Future<List<VerificationStep>> _checkVerificationCode =
      checkVerificationCode(widget.email, widget.code as String);

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
      body: FutureBuilder<List<VerificationStep>>(
        future: _checkVerificationCode,
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
            List<VerificationStep> info = snapshot.data!;
            if (info[0].successOnRequest) {
              Future.delayed(const Duration(seconds: 2), () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        NewUserForm(email: widget.email),
                  ),
                );
              });

              return AlertDialog(
                backgroundColor: Colors.blueGrey[100],
                title: const Text('O email foi verificado!'),
                // content: SingleChildScrollView(
                //   child: ListBody(
                //     children: const <Widget>[
                //       Text('A leitura foi iniciada.'),
                //       Text('Você verá o livro na aba "Lendo".'),
                //     ],
                //   ),
                // ),
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

class NewUserForm extends StatefulWidget {
  const NewUserForm({Key? key, required this.email}) : super(key: key);

  final String email;

  @override
  State<NewUserForm> createState() => _NewUserFormState();
}

class _NewUserFormState extends State<NewUserForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  // email RegExp
  // we'll use this RegExp to check if the
  // form's emailAddress value entered is a valid
  // emailAddress or not and raise a validation error
  // for the erroneous case
  final _emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+.[a-zA-Z]+");

  @override
  Widget build(BuildContext context) {
    TextEditingController userPassword = TextEditingController();

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    // Build a Form widget using the _formKey created above.
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
                  // Text(
                  //   'Email: $widget.email',
                  //   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  //   softWrap: false,
                  //   overflow: TextOverflow.visible,
                  // ),
                  FocusTraversalGroup(
                    descendantsAreFocusable: true,
                    child: TextFormField(
                      controller: userPassword,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.password),
                        helperText:
                            'Cadastre uma senha forte, utilizando números e letras!',
                        helperMaxLines: 4,
                        labelText: 'Cadastre a senha de acesso ao aplicativo!',
                      ),
                      validator: (String? value) {
                        // TODO Think about it.
                        return (value == null || value.isEmpty)
                            ? 'Por favor, digite a senha que será cadastrada!\n\n'
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
                                    CreateUserToApp(
                                        password: userPassword.text,
                                        email: widget.email),
                              ),
                            );
                          }
                        },
                        child: const Text('Cadastrar ...'),
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

class CreateUserToApp extends StatefulWidget {
  const CreateUserToApp({Key? key, required this.password, required this.email})
      : super(key: key);

  final String password;
  final String email;

  @override
  State<CreateUserToApp> createState() => _CreateUserToAppState();
}

class _CreateUserToAppState extends State<CreateUserToApp> {
  late Future<CreateUser> futureData;
  late final Future<List<CreateUser>> _addUserToApp =
      addUserToApp(widget.email, widget.password);

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
      body: FutureBuilder<List<CreateUser>>(
        future: _addUserToApp,
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
            List<CreateUser> info = snapshot.data!;
            if (info[0].successOnRequest) {
              Future.delayed(const Duration(seconds: 3), () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/home', (route) => false);
              });

              return AlertDialog(
                backgroundColor: Colors.blueGrey[100],
                title: const Text('A senha foi cadastrada com sucesso!'),
                // content: SingleChildScrollView(
                //   child: ListBody(
                //     children: const <Widget>[
                //       Text('A leitura foi iniciada.'),
                //       Text('Você verá o livro na aba "Lendo".'),
                //     ],
                //   ),
                // ),
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
