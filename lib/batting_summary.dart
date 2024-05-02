import 'package:flutter/cupertino.dart';
import 'package:score_keeper/matchData.dart';

class BattingSummary extends StatefulWidget {
  //String player1Name;
  //String player2Name;
  int player1Runs;
  int player2Runs;
  bool isPlayer1Batting;
  matchData? obj1;

  BattingSummary(
      {Key? key,
      this.obj1,
      this.player1Runs = 0,
      this.player2Runs = 0,
      this.isPlayer1Batting = true})
      : super(key: key);
  // BattingSummary(
  //     {Key? key,
  //     required this.player1Name,
  //     required this.player2Name,
  //     this.player1Runs = 0,
  //     this.player2Runs = 0,
  //     this.isPlayer1Batting = true})
  //     : super(key: key);

  @override
  State<StatefulWidget> createState() => _BattingSummaryState();
}

class _BattingSummaryState extends State<BattingSummary> {
  //int playerindex = int.tryParse(widget.obj1?.wickets);
  int playerindex = 0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Batting',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          Text("$playerindex"),
          // Text(
          //     '${widget.obj1!.team1Players[playerindex]}${widget.isPlayer1Batting ? '*' : ''}    ${widget.player1Runs}\n${widget.obj1!.team1Players[0]}${!widget.isPlayer1Batting ? '*' : ''}    ${widget.player2Runs}'),
        ],
      ),
    );
  }
}
