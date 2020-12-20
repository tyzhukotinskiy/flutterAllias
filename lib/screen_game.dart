import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math';
import 'db.dart';
import 'model.dart';
import 'team.dart';

class GamePage extends StatefulWidget {
  //Key key;
 // List<String> words;

  GamePage({Key key}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  String word;
  int answerSuccess;
  int countWord;
  int currentTeamId;
  int nextTeamId;
  int answerFailed;
  Team next;
  Team current;
  List<String> words = [
    'Джабора', 'Marazm', 'Papuha', 'Student', 'Darovane dytja', 'Batko',
    'Vozhnya', 'dfweewv', 'Papvwewuha', 'Stwesudent', 'Darovsdcane dytja', 'Basdvtko',
    'Джабо123ра', 'Mara32zm', '12Papuha', 'Studesdvnt', 'Darovane sddytja', 'sdvBatko',
    'Джаборdwcа', 'Mar222azm', 'Papu12dwsha', 'Stude12dsnt', 'Da22rovane dytja', 'dwBatko',
    'Джабо2dwра', 'Mara23fazm', 'Paf23puha', 'Stu2ddent', 'Darovanqd32e dytja', 'Baqwdwtko',
  ];

  @override
  void initState() {
    word = words[new Random().nextInt(words.length-1)];
    answerSuccess = 0;
    answerFailed = 0;
    countWord = 0;

    initTeam();

    super.initState();
  }

  void initTeam() async {

    List<Map<String, dynamic>> currentT = await DB.queryTakeCurrent(Team.table);
    if (currentT.length < 1) {
      List<Map<String, dynamic>> currentTeamQuery = await DB.queryTakeFirst(Team.table);
      var currentTeam = currentTeamQuery.map((item) => Team.fromMap(item)).toList();
      this.currentTeamId = currentTeam[0].id;
      this.current = currentTeam[0];

      // print("INIT");
      // print(_resultsQ[0]);
      // print("INIT");
      //
      //
      // print("NEXT");
      // print(nextTeam);
      // print("NEXT");
    } else {
      var currentTeam = currentT.map((item) => Team.fromMap(item)).toList();
      this.currentTeamId = currentTeam[0].id;
      this.current = currentTeam[0];

      print("NEXT");
      print(currentT);
      print("NEXT");
    }

    List<Map<String, dynamic>> nextTeamQuery = await DB.queryTakeNext(Team.table, this.currentTeamId);
    var nextTeam = nextTeamQuery.map((item) => Team.fromMap(item)).toList();
    this.nextTeamId = nextTeam[0].id;
    this.next = nextTeam[0];

    print("Current Team Id: " + this.currentTeamId.toString());
    print("Next Team Id: " + this.nextTeamId.toString());

    //
    // List<Map<String, dynamic>> _results = await DB.query(Team.table);
    // print(11111111111111111);
    // print(_results);
    // print(11111111111111111);
    // var teams = _results.map((item) => Team.fromMap(item)).toList();
    // print(2222);
    // print(teams[0].name);
    // teams[0].points++;
    // dynamic result = await DB.update(Team.table, teams[0]);
    // print(2222);
    // // DB.getTeam(1);
    // // setState(() { });

    this.updateNext();
  }

  // @override
  // void didUpdateWidget(GamePage oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   word = 'Somenthing else';
  // }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
            child: Material(
                color: Color.fromRGBO(200, 100, 0, 1),
                child: FittedBox (
                    child: Container (
                      width: 300,
                      height: 570,
                      color: Color.fromRGBO(250, 12, 24, 0.9),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 100,
                              width: 300,
                              color: Color.fromRGBO(213, 41, 122, 1),
                              child: Row(
                                children: [
                                  Container (
                                    width: 180,
                                    child: Text("Отгадано слов: " + answerSuccess.toString()),
                                  ),
                                  Container(
                                    child: buttonSuccess('Правильно!', true),
                                  )
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Container(
                                  height: 300,
                                  width: 300,
                                  color: Color.fromRGBO(13, 41, 122, 1),
                                  child: Center(
                                    child: Text(word, style: TextStyle(color: Colors.white, fontSize: 32))
                                  ),
                                ),

                              ]
                            ),
                            Container(
                              height: 100,
                              width: 300,
                              color: Color.fromRGBO(13, 241, 222, 0.7),
                              child: Row(
                                children: [
                                  Container (
                                    width: 165,
                                    child: Text("Пропущено слов: " + answerFailed.toString()),
                                  ),
                                  Container(
                                    child: buttonSuccess('Неправильно!', false),
                                  )
                                ],
                              ),
                            ),
                          ]
                      ),
                    )
                )
            )

    );
  }

  Widget buttonStopGame(String buttonLabel) => ButtonSuccess(
    key: ValueKey("buttonStopGame"),
    buttonLabel: buttonLabel,
    onPressed: (){
      Navigator.pushReplacementNamed(context, "/results");
    },
  );

  Widget buttonSuccess(String buttonLabel, bool isRight) => ButtonSuccess(
    key: ValueKey("buttonSuccess"),
    isSelected: true,
    someInt: 5,
    buttonLabel: buttonLabel,
    onPressed: (){
      Answer("wordValue Peredaly", isRight);
    },
  );

  void refresh() async {

    // List<Map<String, dynamic>> _resultsQ = await DB.queryById(Team.table);
    // print(84837);
    // print(_resultsQ);
    // print(23789);
    //
    //
    // List<Map<String, dynamic>> _results = await DB.query(Team.table);
    // print(11111111111111111);
    // print(_results);
    // print(11111111111111111);
    // var teams = _results.map((item) => Team.fromMap(item)).toList();
    // print(2222);
    // print(teams[0].name);
    this.current.points++;
    dynamic result = await DB.update(Team.table, this.current);
    print(2222);
    // DB.getTeam(1);
    // setState(() { });
  }

  void updateNext() async {
    this.current.next = 0;
    dynamic resultC = await DB.update(Team.table, this.current);

    print("CURRENT AFTER UPDATE");
    print(this.current);

    this.next.next = 1;
    dynamic result = await DB.update(Team.table, this.next);
  }

  void Answer(String wordValue, bool isRight) => setState(() {
    Random random = new Random();
    this.word = words[new Random().nextInt(words.length-1)];
    if(isRight) {
      this.answerSuccess++;
      print('rightAnswer');
      // var itemTeam = DB.getTeam(1);
      // var Wteams = itemTeam.map((item) => Team.fromMap(item)).toList();
      // print(Wteams);

      refresh();
    }
    else {
      this.answerFailed++;
      print('wrongAnswer');
    }
    this.countWord++;
    if (this.countWord == 10) {
      this.updateNext();
      Navigator.pushReplacementNamed(context, "/results");
    }
  });
}

class ButtonSuccess  extends StatelessWidget {
  final Key key;
  final bool isSelected;
  final int someInt;
  final String buttonLabel;
  final VoidCallback onPressed;

  ButtonSuccess({
    this.key,
    this.isSelected,
    this.someInt,
    this.buttonLabel,
    this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        color: Color.fromRGBO(1, 255, 46, 1),
        child: Text(this.buttonLabel),
        onPressed: () {
          Random random = new Random();
          print('Nazhaly na knopku ta vyvely resultata na konsol' + random.nextInt(100).toString());
          onPressed();
        }
    );
  }
}

class ButtonStopGame  extends StatelessWidget {
  final Key key;
  final String buttonLabel;
  final VoidCallback onPressed;

  ButtonStopGame({
    this.key,
    this.buttonLabel,
    this.onPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        color: Color.fromRGBO(255, 25, 26, 0.9),
        child: Text(this.buttonLabel),
        onPressed: () {
          print('Zupynyly hru!');
          onPressed();
        }
    );
  }
}