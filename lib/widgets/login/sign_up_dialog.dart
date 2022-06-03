// Local
// Application
import 'package:agnes_app/generic/constant.dart';
import 'package:agnes_app/generic/requests.dart';
import 'package:agnes_app/models/book_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';

class SigUpInit extends StatefulWidget {
  const SigUpInit({Key? key}) : super(key: key);

  @override
  State<SigUpInit> createState() => _SigUpInitState();
}

class _SigUpInitState extends State<SigUpInit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).padding.top),
        child: SizedBox(
          height: MediaQuery.of(context).padding.top,
        ),
      ),
      body: const _AskUserEmail(),
    );
  }
}

class _AskUserEmail extends StatefulWidget {
  const _AskUserEmail({Key? key}) : super(key: key);

  @override
  State<_AskUserEmail> createState() => _AskUserEmailState();
}

class _AskUserEmailState extends State<_AskUserEmail> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextEditingController email = TextEditingController();

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SizedBox(
      height: height,
      width: width,
      child: Padding(
        padding: const EdgeInsets.all(25),
        // the Form here
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  helperText: 'email@email.com',
                  labelText: 'Enter your email',
                  icon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                controller: email,
                validator: (value) {
                  // Check if this field is empty
                  if (value == null || value.isEmpty) {
                    return 'This field is required';
                  }
                  if (!RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+.[a-zA-Z]+")
                      .hasMatch(value)) {
                    return "Please enter a valid email address";
                  }
                  // the email is valid
                  return null;
                },
              ),
              TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            _SendUserEmail(email: email.text),
                      ),
                    );
                  }
                },
                child: const Text('Check Email'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SendUserEmail extends StatefulWidget {
  const _SendUserEmail({Key? key, required this.email}) : super(key: key);

  final String email;

  @override
  State<_SendUserEmail> createState() => _SendUserEmailState();
}

class _SendUserEmailState extends State<_SendUserEmail> {
  late Future<UserSignUpCredentials> futureData;
  late final Future<List<UserSignUpCredentials>> _sendEmail =
      addEmailToApp(widget.email);

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
      body: FutureBuilder<List<UserSignUpCredentials>>(
        future: _sendEmail,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<UserSignUpCredentials> info = snapshot.data!;

            // The email was checked
            if (info[0].successOnRequest) {
              Future.delayed(const Duration(seconds: 0), () {
                Navigator.of(context).pop();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => _AskUserCode(email: widget.email),
                  ),
                );
              });

              return const SizedBox();
            } else {
              // Email already in use Error Message
              return const EmailAlreadyInUseMessage();
            }
          } else if (snapshot.hasError) {
            // Unknown Error Message
            return const UnknownErrorMessage();
          }

          return Center(
            child: SpinKitChasingDots(
              color: const Color(Constant.objectsColor),
              size: width * 0.3,
              duration: const Duration(milliseconds: 1500),
            ),
          );
        },
      ),
    );
  }
}

class _AskUserCode extends StatefulWidget {
  const _AskUserCode({Key? key, required this.email}) : super(key: key);

  final String email;

  @override
  State<_AskUserCode> createState() => _AskUserCodeState();
}

class _AskUserCodeState extends State<_AskUserCode> {
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
      body: Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Center(
              child: Text(
                'Por favor, digite o código recebido no email que cadastrado.',
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
                underlineColor: const Color(Constant.objectsColor),
                length: 6,
                isSecure: true,
                fullBorder: true,
                cursorColor: const Color(Constant.objectsColor),
                onCompleted: (String value) {
                  setState(
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => _SendUserCode(
                            code: value,
                            email: widget.email,
                          ),
                        ),
                      );
                    },
                  );
                },
                onEditing: (bool value) {
                  setState(() {});
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SendUserCode extends StatefulWidget {
  const _SendUserCode({Key? key, required this.code, required this.email})
      : super(key: key);

  final String email;
  final String code;

  @override
  State<_SendUserCode> createState() => _SendUserCodeState();
}

class _SendUserCodeState extends State<_SendUserCode> {
  late Future<UserSignUpCredentials> futureData;
  late final Future<List<UserSignUpCredentials>> _sendCode =
      checkVerificationCode(widget.email, widget.code);

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
      body: FutureBuilder<List<UserSignUpCredentials>>(
        future: _sendCode,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<UserSignUpCredentials> info = snapshot.data!;

            // The email was checked
            if (info[0].successOnRequest) {
              Future.delayed(const Duration(seconds: 0), () {
                Navigator.of(context).pop();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        _AskUserInformation(email: widget.email),
                  ),
                );
              });

              return const SizedBox();
            } else {
              if (info[0].errorCode == 105) {
                // The Code is wrong Error Message
                return const WrongValidationCodeMessage();
              } else if (info[0].errorCode == 106) {
                // Email already Checked Error Message
                return const EmailAlreadyCheckedMessage();
              }
            }
          } else if (snapshot.hasError) {
            // Unknown Error Message
            return const UnknownErrorMessage();
          }

          return Center(
            child: SpinKitChasingDots(
              color: const Color(Constant.objectsColor),
              size: width * 0.3,
              duration: const Duration(milliseconds: 1500),
            ),
          );
        },
      ),
    );
  }
}

class _AskUserInformation extends StatefulWidget {
  const _AskUserInformation({Key? key, required this.email}) : super(key: key);

  final String email;

  @override
  State<_AskUserInformation> createState() => _AskUserInformationState();
}

class _AskUserInformationState extends State<_AskUserInformation> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextEditingController userPassword = TextEditingController();

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
          padding: const EdgeInsets.all(25),
          // the Form here
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    helperText:
                        'Não use a mesma senha que você usa para acessar o\n'
                        'email que foi cadastrado!',
                    labelText: 'Digite sua senha.',
                    icon: Icon(Icons.password),
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  controller: userPassword,
                  validator: (value) {
                    // Check if this field is empty
                    if (value == null || value.isEmpty) {
                      return 'O campo SENHA é necessário';
                    }
                    if (!RegExp(
                            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                        .hasMatch(value)) {
                      return "A senha deve conter:\n\n"
                          "Pelo menos 1 letra minúscula;\n"
                          "Pelo menos 1 letra maiúscula;\n"
                          "Pelo menos 1 número;\n"
                          "Pelo menos 1 caracter especial;\n"
                          "Pelo menos 8 dígitos;";
                    }
                    // the email is valid
                    return null;
                  },
                ),
                TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              _SendUserInformation(
                                  email: widget.email,
                                  password: userPassword.text),
                        ),
                      );
                    }
                  },
                  child: const Text('Cadastrar a senha!'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SendUserInformation extends StatefulWidget {
  const _SendUserInformation(
      {Key? key, required this.email, required this.password})
      : super(key: key);

  final String email;
  final String password;

  @override
  State<_SendUserInformation> createState() => _SendUserInformationState();
}

class _SendUserInformationState extends State<_SendUserInformation> {
  late Future<CreateUserForm> futureData;
  late final Future<List<CreateUserForm>> _sendPassword =
      addUserToApp(widget.email, widget.password);

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
      body: FutureBuilder<List<CreateUserForm>>(
        future: _sendPassword,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<CreateUserForm> info = snapshot.data!;

            // The email was checked
            if (info[0].successOnRequest) {
              Future.delayed(const Duration(seconds: 0), () {
                Navigator.of(context).pop();

                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/', (route) => false);
              });

              return const SizedBox();
            }
          } else if (snapshot.hasError) {
            // Unknown Error Message
            return const UnknownErrorMessage();
          }

          return Center(
            child: SpinKitChasingDots(
              color: const Color(Constant.objectsColor),
              size: width * 0.3,
              duration: const Duration(milliseconds: 1500),
            ),
          );
        },
      ),
    );
  }
}

// -----------------------------------------------------------------------------

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
