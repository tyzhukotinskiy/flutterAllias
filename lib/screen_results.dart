import 'package:flutter/material.dart';
import 'team.dart';
import 'db.dart';

// void main() async {
//
//   WidgetsFlutterBinding.ensureInitialized();
//
//   await DB.init();
//   DB.deleteAll();
//   runApp(MyApp());
// }

// class ChooseTeamPage extends StatelessWidget {
//
//   @override
//   Widget build(BuildContext context) {
//
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData( primarySwatch: Colors.indigo ),
//       home: MyHomePage(title: 'Flutter SQLite Demo App'),
//     );
//   }
// }

class ResultsPage extends StatefulWidget {

  ResultsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {

  String _name;
  String teamMinValue = "";

  List<Team> _teams = [];

  TextStyle _style = TextStyle(color: Colors.white, fontSize: 24);

  List<Widget> get _items => _teams.map((item) => format(item)).toList();

  Widget format(Team item) {
    print('item');
    print(item);
    return Dismissible(
      key: Key(item.id.toString()),
      child: Padding(
          padding: EdgeInsets.fromLTRB(20, 12, 20, 12),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(item.name, style: _style),
                  Text(item.points.toString(), style: _style),
                ]
            ),

      ),
    );
  }

  void _toggle(Team item) async {

    item.points = 0;
    item.next = 0;
    dynamic result = await DB.update(Team.table, item);
    print(result);
    refresh();
  }

  void _delete(Team item) async {

    DB.delete(Team.table, item);
    refresh();
  }

  void _save() async {

    Navigator.of(context).pop();
    Team item = Team(
      name: _name,
      points: 0,
      next: 0,
    );

    await DB.insert(Team.table, item);
    setState(() => _name = '' );
    refresh();
  }

  void _create(BuildContext context) {

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Create New Task"),
            actions: <Widget>[
              FlatButton(
                  child: Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop()
              ),
              FlatButton(
                  child: Text('Save'),
                  onPressed: () => _save()
              )
            ],
            content: TextField(
              autofocus: true,
              decoration: InputDecoration(labelText: 'Task Name', hintText: 'e.g. pick up bread'),
              onChanged: (value) { _name = value; },
            ),
          );
        }
    );
  }

  @override
  void initState() {

    refresh();
    takeWinner();
    super.initState();
  }

  void takeWinner() async {
    List<Map<String, dynamic>> isNextRound = await DB.queryIsNextRound(Team.table);
    print("IS NEXT");
    print(isNextRound);
    if(isNextRound.length < 1) {
      print("NU hot' zasly");
      this.teamMinValue = "Раунд окончен: подведем итог! Игра продолжается";
      print(this.teamMinValue);
      List<Map<String, dynamic>> possibleWinners = await DB.queryTakePossibleWinners(Team.table);
      print("BNJU");
      print(possibleWinners);
      if(possibleWinners.length > 1) {
        print("ODIN!");
        List<Map<String, dynamic>> winner = await DB.queryTakeWinner(Team.table);
        var winnerTeam = winner.map((item) => Team.fromMap(item)).toList();
        this.teamMinValue += " Несколько команд прошли порог победы! Победу одержали: " + winnerTeam[0].name;
        Navigator.pushReplacementNamed(context, '/winner');
      } else if(possibleWinners.length > 0){
        print("NUUUU IH MNOGI!");
        var winnerTeam = possibleWinners.map((item) => Team.fromMap(item)).toList();
        this.teamMinValue += " Победу одержали: " + winnerTeam[0].name;
        Navigator.pushReplacementNamed(context, '/winner');
      }
    }
  }

  void refresh() async {

    List<Map<String, dynamic>> _results = await DB.query(Team.table);
    print(11111111111111111);
    print(_results);
    print(11111111111111111);
    _teams = _results.map((item) => Team.fromMap(item)).toList();
    DB.getTeam(1);
    setState(() { });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar( title: Text("Команды") ),
        body: SafeArea(
            child: Column(
              children: [
                Container(
                    color: Colors.green,
                    height: 520.0,
                    width:390,
                    child: Column(
                      children: [
                        Container(
                            height: 400.0,
                            child: ListView( scrollDirection: Axis.vertical, children: _items )
                        ),
                        Container(
                          height: 100.0,
                          width: 300.0,
                          child: buttonBeginGame('Начать игру'),
                        )
                      ],
                    )
                ),
                Container(
                    height: 100,
                    child: Center(
                      child: Text(this.teamMinValue, textAlign: TextAlign.center, style: TextStyle(color: Colors.red, fontSize: 28)),
                    )

                )
              ],
            )
        ),

    );
  }

  dynamic buttonBeginGame(String buttonLabel) {
      print("BUTTONBEGIN");
      print(this.teamMinValue);
      if (this.teamMinValue == "")
        this.teamMinValue = "ПРОДОЛЖАЕМ!";
      return ButtonBeginGame(
        key: ValueKey("buttonBeginGame"),
        buttonLabel: buttonLabel,
      );

  }
}

class ButtonBeginGame extends StatelessWidget{
  final Key key;
  final String buttonLabel;

  ButtonBeginGame({
    this.key,
    this.buttonLabel
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialButton(
      color: Colors.redAccent,
      child: Text("Продолжить игру!", style: TextStyle(color: Colors.white, fontSize: 24)),
      onPressed: () {
        Navigator.pushReplacementNamed(context, "/game");
      },
    );
  }
}