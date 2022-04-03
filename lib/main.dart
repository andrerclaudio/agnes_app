import 'package:agnes_app/requests.dart';
import 'package:flutter/material.dart';

void main() {
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agnes Application UI',
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => const MyHomePage(title: 'Agnes'),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/home': (context) => const MySecondPage(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.grey, scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    TextEditingController nameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.blue,
      //   // Here we take the value from the MyHomePage object that was created by
      //   // the App.build method, and use it to set our appbar title.
      //   title: const Center(child: Text('Agnes')),
      // ),
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
                  'Agnes',
                  style: TextStyle(
                    color: Color(0xff78af9f),
                    fontWeight: FontWeight.w500,
                    fontSize: 40,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'E-mail',
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
                    labelText: 'Senha',
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  //forgot password screen
                },
                child: const Text(
                  'Esqueceu a senha?',
                ),
              ),
              Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  child: const Text(
                    'Entrar',
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xff363639),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/home', (route) => false);
                  },
                ),
              ),
              Row(
                children: <Widget>[
                  const Text('Não tem uma conta?'),
                  TextButton(
                    child: const Text(
                      'Criar',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xff78af9f),
                      ),
                    ),
                    onPressed: () {
                      //signup screen
                    },
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MySecondPage extends StatefulWidget {
  const MySecondPage({Key? key}) : super(key: key);

  @override
  _MySecondPageState createState() => _MySecondPageState();
}

class _MySecondPageState extends State<MySecondPage> {
  late Future<Data> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Screen'),
      ),
      body: Center(
        child: Column(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FutureBuilder<Data>(
                  future: futureData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('R\$${snapshot.data!.dollarRate}'),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    // By default, show a loading spinner.
                    return const LinearProgressIndicator();
                  },
                ),
              ],
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                child: const Text(
                  'Sair',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xff363639),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/', (route) => false);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
