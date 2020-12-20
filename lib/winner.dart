import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class WinnerPage extends StatefulWidget {

  WinnerPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  WinnerPageState createState() => WinnerPageState();
}

class WinnerPageState extends State<WinnerPage> {

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
  }

  void _delete(Team item) async {

    DB.delete(Team.table, item);

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

    takeWinner();
    
    super.initState();
  }

  void takeWinner() async {

        List<Map<String, dynamic>> winner = await DB.queryTakeWinner(Team.table);
        var winnerTeam = winner.map((item) => Team.fromMap(item)).toList();
        print("ASYNC SLI");
        print(winnerTeam);
        //return " Несколько команд прошли порог победы! Победу одержали: " + winnerTeam[0].name;

        setState(() => this.teamMinValue = "  Победу одержали: " + winnerTeam[0].name );
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar( title: Text("Результат игры...") ),
      body: SafeArea(
          child: Column(
            children: [

              Container(
                  height: 300,
                  child: textEnd("fd")

              )
            ],
          )
      ),

    );
  }

  dynamic textEnd(String buttonLabel) {
    return
      Container(
        child: Column(
          children: [
            Text(
                this.teamMinValue,
                textAlign: TextAlign.center, style: TextStyle(color: Colors.red, fontSize: 28)
            ),
            MaterialButton(
              color: Colors.teal,
              child: Text("Завершить игру"),
              onPressed: ()=> SystemNavigator.pop(),
            )
          ],
        )

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