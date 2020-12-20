import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math';

class HomePage extends StatefulWidget {


  HomePage({Key key}) : super (key: key);

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  String greeting;



  @override
  void initState() {
    this.greeting = 'Hello! Let\'s play!';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  SafeArea(
        child: Material(
          color: Color.fromRGBO(100, 100, 110, 0.5),
          child: FittedBox(
            child: Container(
              width: 300,
              height: 570,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Text("T_ALIAS", style: TextStyle(fontSize: 32, color: Colors.deepOrangeAccent),),
                    height: 60
                  ),
                  Container(
                    height: 100,
                    child: buttonGame('Label'),
                  )
                ],
              )
            )
          )
        )
    );
  }

  Widget buttonGame(String buttonLabel) => ButtonGame(
    key: ValueKey("buttonGame"),
    buttonLabel: buttonLabel,
  );
}

class ButtonGame extends StatelessWidget{
  final Key key;
  final String buttonLabel;

  ButtonGame({
    this.key,
    this.buttonLabel
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialButton(
      color: Colors.green,
      child: Text("Начать игру"),
      onPressed: () {
        Navigator.pushReplacementNamed(context, "/chooseTeam");
      },
    );
  }
}