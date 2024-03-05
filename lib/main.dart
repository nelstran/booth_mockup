import 'dart:collection';
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

ColorRibbons colorLibrary = ColorRibbons();

class Booth extends StatelessWidget {
  const Booth({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    // Main color of the app
    var mainColor = const Color.fromARGB(255, 44, 94, 168);

    return MaterialApp(
      title: 'Booth',

      theme: ThemeData(
        useMaterial3: true,
        //Set default text to Roboto Mono
        textTheme: GoogleFonts.robotoMonoTextTheme(
          Theme.of(context).textTheme,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: mainColor,
          brightness: Brightness.dark
          ),
        // Set color scheme and font styling per widget
        appBarTheme: AppBarTheme(
          color: mainColor,
          titleTextStyle: GoogleFonts.robotoMono(
            color: Colors.white,
            fontSize: 30,
          ),
        ),
        listTileTheme: ListTileThemeData(
          tileColor: Colors.grey.shade700,
          titleTextStyle: GoogleFonts.robotoMono(
            fontSize: 25
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Colors.blue.shade600,
          backgroundColor: Colors.grey.shade800,
          unselectedItemColor: Colors.white
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blue.shade600,
        ),
      ),
      home: const MyHomePage(title: 'Booth'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  // Create list of sessions for mock up
  List<SessionObj> sessions = [
    SessionObj(field: "CS", level: "2420", topic: "A3", currNum: 2, maxNum: 10),
    SessionObj(field: "WRTG", level: "1010", topic: "Portfolio"),
    SessionObj(field: "CS", level: "1410", topic: "PA-01", maxNum: 2),
    SessionObj(field: "CS", level: "4000", topic: "Design Document", currNum: 9, maxNum: 11),
    SessionObj(field: "WRTG", level: "5000", topic: "Midterm"),
    SessionObj(field: "ENG", level: "1000", topic: "Q1"),
    SessionObj(field: "HIST", level: "2420", topic: "Chapter 4", currNum: 2, maxNum: 3),
    SessionObj(field: "MATH", level: "1400", topic: "Equations"),
    SessionObj(field: "MATH", level: "4400", topic: "Midterm", maxNum: 4),
    SessionObj(field: "HIST", level: "1010", topic: "Essay 1", currNum: 5, maxNum: 10),
    SessionObj(field: "MATH", level: "2210", topic: "Parametric equations", currNum: 4, maxNum: 5)
  ];

  int currPageIndex = 0;
  @override
  Widget build(BuildContext context) {

    // Sort the sessions by distance
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
            child: Icon(Icons.settings), //Icon for now, will add button later
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget> [
            for (var i = 0; i < sessions.length; i++)
              sessionTile(context, sessions[i]),
          ]
        )
      ),
      // This was part of skeleton code, use for creating a session?
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        tooltip: 'Increment',
        backgroundColor: Theme.of(context).floatingActionButtonTheme.backgroundColor,
        child: const Icon(Icons.add),
      ), 
      // Navigation bar placeholder
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int i){
          setState(() {
            currPageIndex = i;
          });
        },
        currentIndex: currPageIndex,
        type: BottomNavigationBarType.fixed, // Need this to change background color
        selectedItemColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
        backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        unselectedIconTheme: Theme.of(context).bottomNavigationBarTheme.unselectedIconTheme,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: "Map",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.data_thresholding),
            label: "Usage",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}

/// Custom class to represent sessions that hold the field, class, and assignment to display
/// 
/// Distance will be generated by how far the user is from the session. If there is no max number 
/// specified, assume there is no person limit. Each session will always have at least 1 person in it.
///
class SessionObj{
  final String field;
  final String level;
  final String topic;
  int dist;
  int currNum;
  int maxNum;
  Color color;


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
    maxNum = maxNum ?? 0,
    color = colorLibrary.addField(field); // Group sessions by the Field they're in
}

/// Class to group sessions by field, currently we generate a random color for each new 
/// field that is added. If that field is already present, use that existing color.
/// 
/// Might not be used, just thought it would look nicer to separate sessions even 
/// though we will implement a filter.
/// 
/// Currently, colors are random but might want to add more vibrant colors specifically.
class ColorRibbons{
  HashMap fields = HashMap();

  Color addField(String field){
    Random rng = Random();
    if(!fields.containsKey(field)){
      double hue = rng.nextDouble() * 360.0; // Random hue value between 0 and 360
      double saturation = rng.nextDouble() * 0.4 + 0.6; // Saturation between 0.6 and 1.0
      double value = rng.nextDouble() * 0.4 + 0.6; // Value (brightness) between 0.6 and 1.0

      fields[field] = HSVColor.fromAHSV(1.0, hue, saturation, value).toColor();
    }
    return fields[field];
  }
}


// This represents the widget itself and holds session data
Padding sessionTile(BuildContext context, SessionObj session) {
  // If no max is specified, assume there is no limit
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
            child: Card( // Complicated way to add color ribbons to the listTile, not sure how to do it properly
              elevation: 2,
              child: ClipPath( // Round the corners of the ribbon
                clipper: ShapeBorderClipper(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  )
                ),
                child: Container( // This holds both the color ribbon and the listTile itself
                  // height: hei,
                  constraints: const BoxConstraints(
                    minHeight: 80,
                    maxHeight: 130,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: session.color, 
                        width: 10,
                      )
                    )
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric( // Center contents inside listTile
                      vertical: 5,
                      horizontal: 15), 
                    onTap: () {},
                    shape: const RoundedRectangleBorder( // Round the corners of the listTile
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      )
                    ),
                    // Use Theme to easily change styles from one location.
                    tileColor: Theme.of(context).listTileTheme.tileColor,
                    leading: const Icon(Icons.person), //Placeholder, thinking about user profile picture
                    title: Text('${session.field} ${session.level}'),
                    subtitle: Text('Working on: ${session.topic}'),
                    trailing: Text('${session.dist} m$roomStr', textAlign: TextAlign.end,),
                    visualDensity: const VisualDensity(
                      horizontal:4,
                    ),
                  )
                ),
              )
            )
          );
  }
