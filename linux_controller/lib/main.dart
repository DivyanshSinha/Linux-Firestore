import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase',
      home: MyHomePage(title: 'Firebase'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();

    Firebase.initializeApp();

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    var cmd = "";

    var output = '';

    var data = "";

    var appBarImage = Image.network(
      "https://bloximages.newyork1.vip.townnews.com/redandblack.com/content/tncms/assets/v3/editorial/4/59/45940eb2-5403-11e9-a843-db0e4491cc90/5ca13d8453042.image.jpg?resize=960%2C640",
      fit: BoxFit.cover,
    );

    NetworkImage backgroundImage = NetworkImage(
        "https://thumbs.dreamstime.com/z/blue-sky-clouds-abstract-art-background-watercolor-digital-artwork-136551201.jpg");

    getOutput() async {
      var url = "http://192.168.2.14/cgi-bin/sample5.py?x=" + cmd;
      var response = await http.get(url);
      data = response.body;
      // await new Future.delayed(const Duration(seconds: 2));
      setState(() {
        output = data;
      });
      print(data);
      print(output);

      var fs = FirebaseFirestore.instance;
      var key = cmd;

      await fs.collection("commands").add({"$key": "$data"});

      var d = await fs.collection("commands").get();
    }

    var appBody = CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
            expandedHeight: 0,
            floating: true,
            pinned: true,
            snap: false,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                "Linux Controller",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              background: appBarImage,
              centerTitle: true,
            )),
        SliverFillRemaining(
          child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
                image:
                    DecorationImage(image: backgroundImage, fit: BoxFit.cover)),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 30, right: 30, bottom: 15, top: 78),
                child: Column(children: <Widget>[
                  TextField(
                    autofocus: true,
                    autocorrect: false,
                    cursorColor: Colors.red[300],
                    onChanged: (value) => cmd = value.toString(),
                    style: TextStyle(color: Colors.red),
                    decoration: InputDecoration(
                        hintText: "Enter linux cmd command",
                        border: OutlineInputBorder(),
                        fillColor: Colors.blue[50],
                        filled: true),
                  ),
                  Center(
                    child: SizedBox(
                      width: 50,
                      height: 20,
                    ),
                  ),
                  Center(
                      child: FlatButton(
                    onPressed: () {
                      getOutput();
                    },
                    child: Text("GO"),
                    color: Colors.green[50],
                  )),
                  Center(
                    child: SizedBox(
                      width: 50,
                      height: 50,
                    ),
                  ),
                  Center(
                    child: Text(output ?? "Please enter your command"),
                  )
                ]),
              ),
            ),
          ),
        )
      ],
    );

    return Scaffold(
      body: appBody,
    );
  }
}
