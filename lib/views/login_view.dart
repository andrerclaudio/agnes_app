// Local
// Application
import 'package:agnes_app/generic/constant.dart';
import 'package:agnes_app/widgets/login/sign_up_dialog.dart';
import 'package:flutter/material.dart';

// import 'package:agnes_app/models/storage_item.dart';
// import 'package:agnes_app/services/secure_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // final StorageService _storageService = StorageService();
  // late List<StorageItem> _items;

  // void initList() async {
  //   // await _storageService.writeSecureData(StorageItem('firstLogin', 'agnes'));
  //
  //   // if (await _storageService.containsKeyInSecureData('firstLogin')) {
  //   //   Navigator.pushNamed(context, '/home');
  //   // }
  // }

  // Initialize the safe content.
  // @override
  // void initState() {
  //   super.initState();
  //   initList();
  // }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

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
          child: ListView(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(20),
                child: const Text(
                  Constant.loginTitleText,
                  style: Constant.loginTitleTextStyle,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: Constant.labelTextEmail,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: Constant.labelTextPassword,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  //forgot password screen
                },
                child: const Text(Constant.forgotPasswordText),
              ),
              Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  child: const Text(
                    Constant.signInText,
                    style: Constant.signInTextStyle,
                  ),
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/home', (route) => false);
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(Constant.doNotHaveAccountText),
                  TextButton(
                    child: const Text(
                      Constant.signUpText,
                      style: Constant.signUpTextStyle,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SigUpInit(
                            index: 0,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
