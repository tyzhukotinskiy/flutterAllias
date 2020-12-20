import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math';
import 'screen_game.dart';
import 'screen_home.dart';
import 'chooseTeam.dart';
import 'screen_results.dart';
import 'package:sqflite/sqflite.dart';
import 'team.dart';
import 'db.dart';
import 'winner.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DB.init();
  DB.deleteAll();

  runApp(MyApp());
}

const words = [
  'Джабора', 'Marazm', 'Papuha', 'Student', 'Darovane dytja', 'Batko',
  'Vozhnya', 'dfweewv', 'Papvwewuha', 'Stwesudent', 'Darovsdcane dytja', 'Basdvtko',
  'Джабо123ра', 'Mara32zm', '12Papuha', 'Studesdvnt', 'Darovane sddytja', 'sdvBatko',
  'Джаборdwcа', 'Mar222azm', 'Papu12dwsha', 'Stude12dsnt', 'Da22rovane dytja', 'dwBatko',
  'Джабо2dwра', 'Mara23fazm', 'Paf23puha', 'Stu2ddent', 'Darovanqd32e dytja', 'Baqwdwtko',
];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: HomePage(),
        routes: <String, WidgetBuilder> {
          //'/home' : (BuildContext context) => HomePage(),
          '/game' : (BuildContext context) => GamePage(),
          '/chooseTeam' : (BuildContext context) => ChooseTeamPage(),
          '/results' : (BuildContext context) => ResultsPage(),
          '/winner' : (BuildContext context) => WinnerPage()
        }
    );
  }
}
