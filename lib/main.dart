import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bookScreen.dart';
import 'database/database.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title = 'isa';

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<>( 
    builder:
     Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.title)),
      ),
      body: SafeArea(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Working Title',
              ),
              FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  _database.createBook('Working Title');
                  // Navigator.push(
                  //     context,
                  //     PageRouteBuilder(
                  //       opaque: false,
                  //       pageBuilder: (BuildContext context, _, __) {
                  //         return BookScreen();
                  //       },
                  //     ));
                },
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}
