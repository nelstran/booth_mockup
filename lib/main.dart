import 'dart:ffi';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const Booth());
}

class Booth extends StatelessWidget {
  const Booth({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var mainColor = Color.fromARGB(255, 44, 94, 168);
    return MaterialApp(
      title: 'Booth',
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.robotoMonoTextTheme(
          Theme.of(context).textTheme,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: mainColor,
          brightness: Brightness.dark
          ),
          appBarTheme: AppBarTheme(
            color: mainColor,
            titleTextStyle: GoogleFonts.robotoMono(
              color: Colors.white,
              fontSize: 30,
            )
          ),
          listTileTheme: ListTileThemeData(
            tileColor: Colors.grey.shade700,
            titleTextStyle: GoogleFonts.robotoMono(
              fontSize: 25
            )
          ),
          cardColor: Colors.black54,
          canvasColor: Colors.grey,
      ),
      home: const MyHomePage(title: 'Booth'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

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
  List<SessionObj> sessions = [
    SessionObj(field: "CS", level: "2420", topic: "A3"),
    SessionObj(field: "CS", level: "4400", topic: "midterm", maxNum: 4),
    SessionObj(field: "HIST", level: "1010", topic: "Essay 1", currNum: 5, maxNum: 10)
  ];
  @override
  Widget build(BuildContext context) {
    sessions.sort((a, b) => a.dist.compareTo(b.dist));
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          widget.title,
          style: Theme.of(context).appBarTheme.titleTextStyle
          ),
        actions: const <Widget>[
          Padding(padding: EdgeInsets.only(right:20),
            child: Icon(Icons.settings),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < 3; i++)
              sessionTile(context, sessions[i]),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), 
    );
  }
}

class SessionObj{
  final String field;
  final String level;
  final String topic;
  int dist;
  int currNum;
  int maxNum;

  SessionObj({
    required this.field,
    required this.level,
    required this.topic,
    int? dist,
    int? currNum,
    int? maxNum,
    }) 
    : 
    dist = dist ?? 10 + Random().nextInt(100 - 10 + 1),
    currNum = currNum ?? 1,
    maxNum = maxNum ?? 0;

}
Padding sessionTile(BuildContext context, SessionObj session) {
    String roomStr = "";
    if (session.maxNum != 0){
      roomStr = "\n[${session.currNum}/${session.maxNum}]";
    }
    return Padding(
              padding: const EdgeInsets.only(
                top: 5,
                left: 5,
                right: 5,
              ),
              child:
              Card(
                elevation: 2,
                child: ClipPath(
                  clipper: ShapeBorderClipper(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    )
                  ),
                  child: Container(
                    height: 80,
                    decoration: const BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          color:Colors.green, 
                          width: 10,
                        )
                      )
                    ),
                    child: ListTile(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          )
                        ),
                        tileColor: Theme.of(context).listTileTheme.tileColor,
                        leading: const Icon(Icons.person),
                        title: Text('${session.field} ${session.level}'),
                        subtitle: Text('Working on: ${session.topic}'),
                        trailing: Text('${session.dist} m$roomStr'),
                        visualDensity: const VisualDensity(
                          horizontal:4,
                        ),
                      )
                  ),
                )
              )
            );
  }
