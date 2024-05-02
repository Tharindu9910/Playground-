import 'package:flutter/cupertino.dart';

class TeamScoreSummary extends StatefulWidget {
  final String team1;
  final String team2;
  int team1Score;
  int team2Score;
  double team1Overs;
  double team2Overs;
  int team1Wickets;
  int team2Wickets;

  TeamScoreSummary(
      {Key? key,
      required this.team1,
      required this.team2,
      this.team1Score = 0,
      this.team2Score = 0,
      this.team1Overs = 0.0,
      this.team2Overs = 0.0,
      this.team1Wickets = 0,
      this.team2Wickets = 0})
      : super(key: key);

  @override
  _TeamScoreSummaryState createState() => _TeamScoreSummaryState();
}

class _TeamScoreSummaryState extends State<TeamScoreSummary> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(widget.team1, style: const TextStyle(fontSize: 24.0)),
              Text(
                  '${widget.team1Score} - ${widget.team1Wickets}\n${widget.team1Overs} overs',
                  style: const TextStyle(fontSize: 20.0))
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(widget.team2, style: const TextStyle(fontSize: 24.0)),
              Text(
                  '${widget.team2Score} - ${widget.team2Wickets}\n${widget.team2Overs} overs',
                  style: const TextStyle(fontSize: 20.0))
            ],
          ),
        ]));
  }
}
