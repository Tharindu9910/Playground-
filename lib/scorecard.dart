// ignore_for_file: prefer_const_constructors

import 'dart:ffi';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:score_keeper/matchData.dart';
import 'package:score_keeper/player_score.dart';
import 'header.dart';
import 'team_score_summary.dart';
import 'batting_summary.dart';

class ScoreCard extends StatefulWidget {
  final String? docId;
  final double? oversInput;
  final int? playerCountInput;
  final String? selectedTeam;
  final bool? team1Bat;
  ScoreCard({
    Key? key,
    required this.docId,
    this.oversInput,
    this.playerCountInput,
    this.selectedTeam,
    this.team1Bat,
  }) : super(key: key);

  @override
  State<ScoreCard> createState() => _ScoreCardState();
}

class _ScoreCardState extends State<ScoreCard> {
  final db = FirebaseFirestore.instance;
  var currentMatch;
  int target = 0;
  int currentInningsScore = 0;
  int team1Score = 0;
  int team2Score = 0;
  int wicketCount = 0;
  int team1Wickets = 0;
  int team2Wickets = 0;
  int inningsBallCount = 0;
  int ballCount = 0;
  double overCount = 0.0;
  double team1OverCount = 0.0;
  double team2OverCount = 0.0;

  double currentRR = 0;
  double requiredRR = 0;

  int player1Index = 0;
  int player2Index = 1;
  String? player1Name;
  String? player2Name;
  int player1Runs = 0;
  int player2Runs = 0;
  bool isFirstInnings = true;
  bool team1batting = true;
  bool isPlayer1Batting = true;
  bool matchwon = false;
  List<PlayerScore> team1PlayerDecodedList = [];
  List<PlayerScore> team2PlayerDecodedList = [];

  @override
  void initState() {
    super.initState();
    team1batting = widget.team1Bat!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("MatchData")
                    .doc(widget.docId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Stack(
                      children: [
                        _buildScoreCard(context, snapshot),
                        Align(
                          alignment: Alignment.center,
                          child: Visibility(
                              visible: snapshot.connectionState ==
                                  ConnectionState.waiting,
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height *
                                          0.1), //Center the CircleProgressIndicator genarally for any device
                                  child: CircularProgressIndicator())),
                        ),
                      ],
                    );
                  }
                }),
            // const Padding(
            //   padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
            // ),
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          if (currentInningsScore != target ||
                              currentInningsScore == 0) {
                            if (ballCount < inningsBallCount) {
                              setState(() {
                                ballCount++;
                                overCount = ballCount ~/ 6 +
                                    (ballCount % 6) /
                                        10.0; //overcount calculation
                                if (isPlayer1Batting) {
                                  player1Runs++;
                                } else {
                                  player2Runs++;
                                }
                                currentInningsScore++;
                                double cRRtemp =
                                    currentInningsScore / ballCount;
                                currentRR = roundDouble(
                                    cRRtemp, 2); //Current Required Run Rate
                              });

                              final updateField = db
                                  .collection("MatchData")
                                  .doc(widget.docId.toString());
                              if (team1batting) {
                                team1Score = currentInningsScore;
                                team1OverCount = overCount;
                                await updateField
                                    .update({"team1Score": team1Score});
                                await updateField
                                    .update({"team1Overs": team1OverCount});
                              } else {
                                team2Score = currentInningsScore;
                                team2OverCount = overCount;
                                await updateField
                                    .update({"team2Score": team2Score});
                                await updateField
                                    .update({"team2Overs": team2OverCount});
                              }
                            }
                          } else {
                            setState(() {
                              matchwon = true;
                            });
                          }
                        },
                        child: const Text('1')),
                    ElevatedButton(
                        onPressed: () async {
                          int test = 2;
                          if (currentInningsScore != target ||
                              currentInningsScore == 0) {
                            if (ballCount < inningsBallCount) {
                              setState(() {
                                ballCount++;
                                overCount = ballCount ~/ 6 +
                                    (ballCount % 6) /
                                        10.0; //overcount calculation
                                if (isPlayer1Batting) {
                                  player1Runs += test;
                                } else {
                                  player2Runs += test;
                                }
                                currentInningsScore += test;
                                double cRRtemp =
                                    currentInningsScore / ballCount;
                                currentRR = roundDouble(
                                    cRRtemp, 2); //Current Required Run Rate
                              });

                              final updateField = db
                                  .collection("MatchData")
                                  .doc(widget.docId.toString());
                              if (team1batting) {
                                team1Score = currentInningsScore;
                                team1OverCount = overCount;
                                await updateField
                                    .update({"team1Score": team1Score});
                                await updateField
                                    .update({"team1Overs": team1OverCount});
                              } else {
                                team2Score = currentInningsScore;
                                team2OverCount = overCount;
                                await updateField
                                    .update({"team2Score": team2Score});
                                await updateField
                                    .update({"team2Overs": team2OverCount});
                              }
                            }
                          } else {
                            setState(() {
                              matchwon = true;
                            });
                          }
                        },
                        child: const Text('2')),
                    ElevatedButton(
                        onPressed: () async {
                          final updateField = db
                              .collection("MatchData")
                              .doc(widget.docId.toString());
                          await updateField
                              .update({"team1Score": FieldValue.increment(3)});
                        },
                        child: const Text('3')),
                    ElevatedButton(
                        onPressed: () async {
                          final updateField = db
                              .collection("MatchData")
                              .doc(widget.docId.toString());
                          await updateField
                              .update({"team1Score": FieldValue.increment(4)});
                        },
                        child: const Text('4')),
                    ElevatedButton(
                        onPressed: () async {
                          final updateField = db
                              .collection("MatchData")
                              .doc(widget.docId.toString());
                          await updateField
                              .update({"team1Score": FieldValue.increment(6)});
                        },
                        child: const Text('6')),
                  ],
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () async {
                            if (ballCount < inningsBallCount) {
                              if (wicketCount < widget.playerCountInput! - 1) {
                                setState(() {
                                  overCount++;
                                  wicketCount++;
                                  overCount =
                                      ballCount ~/ 6 + (ballCount % 6) / 10.0;
                                  if (isPlayer1Batting) {
                                    player1Index = wicketCount + 1;
                                    player1Runs = 0;
                                  } else {
                                    player2Index = wicketCount + 1;
                                    player2Runs = 0;
                                  }
                                });
                                final updateField = db
                                    .collection("MatchData")
                                    .doc(widget.docId.toString());
                                if (team1batting) {
                                  team1Wickets = wicketCount;
                                  await updateField
                                      .update({"team1Overs": overCount});
                                  await updateField
                                      .update({"team1Wickets": team1Wickets});
                                } else {
                                  team2Wickets = wicketCount;
                                  await updateField
                                      .update({"team2Overs": overCount});
                                  await updateField
                                      .update({"team2Wickets": team2Wickets});
                                }
                              }
                            }
                          },
                          child: const Text('W')),
                      ElevatedButton(
                          onPressed: () async {
                            final updateField = db
                                .collection("MatchData")
                                .doc(widget.docId.toString());
                            await updateField.update(
                                {"team1Score": FieldValue.increment(1)});
                          },
                          child: const Text('NB')),
                      ElevatedButton(
                          onPressed: () async {
                            final updateField = db
                                .collection("MatchData")
                                .doc(widget.docId.toString());
                            if (isFirstInnings) {
                              await updateField.update(
                                  {"team1Score": FieldValue.increment(1)});
                            } else {
                              await updateField.update(
                                  {"team2Score": FieldValue.increment(1)});
                            }
                          },
                          child: const Text('WD')),
                      ElevatedButton(
                          onPressed: () async {
                            final updateField = db
                                .collection("MatchData")
                                .doc(widget.docId.toString());
                            await updateField.update(
                                {"team1Overs": FieldValue.increment(0.1)});
                          },
                          child: const Text('B')),
                      ElevatedButton(
                          onPressed: () async {}, child: const Text('LB')),
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isPlayer1Batting = !isPlayer1Batting;
                              // int temp = player1Index;
                              // player1Index = player2Index;
                              // player2Index = temp;
                            });
                          },
                          child: const Text('Switch bat')),
                      ElevatedButton(
                          onPressed: () async {},
                          child: const Text('End over')),
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isFirstInnings = !isFirstInnings;
                              if (widget.selectedTeam == "Team 1") {
                                team1batting = false;
                              } else {
                                team1batting = true;
                              }

                              target = currentInningsScore + 1;
                              int tempBallCount =
                                  (widget.oversInput!.round()) * 6;
                              double temp = currentInningsScore / tempBallCount;
                              requiredRR =
                                  roundDouble(temp, 2); //Required Run Rate
                              currentRR = 0;
                              ballCount = 0;
                              overCount = 0;
                              wicketCount = 0;
                              player1Runs = 0;
                              player1Index = 0;
                              player2Runs = 0;
                              player2Index = 0;
                              currentInningsScore = 0;
                            });
                          },
                          child: const Text('End Inning')),
                    ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(onPressed: () {}, child: const Text('Undo')),
                    ElevatedButton(onPressed: () {}, child: const Text('Redo')),
                  ],
                )
              ],
            ),
            // ScorecardModifiers(
            //     docId: widget.docId.toString(), obj1: widget.obj1)
          ]),
    );
  }

  Widget _buildScoreCard(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.hasData) {
      currentMatch = snapshot.data;
      String team1PlayerList = currentMatch['team1PlayerList'];
      team1PlayerDecodedList = PlayerScore()
          .parsePlayerScores(team1PlayerList); //convert json list to dartlist
      String team2PlayerList = currentMatch['team2PlayerList'];
      team2PlayerDecodedList = PlayerScore()
          .parsePlayerScores(team2PlayerList); //convert json list to dartlist

      return Column(
        children: [
          //Text(widget.obj1!.overs.toString()), ......................................
          TeamScoreSummary(
            team1: currentMatch!['team1'],
            team2: currentMatch['team2'],
            team1Score: team1Score,
            team2Score: team2Score,
            team1Wickets: team1Wickets,
            team2Wickets: team2Wickets,
            team1Overs: team1OverCount,
            team2Overs: team2OverCount,
          ),
          const Divider(thickness: 2),
          _buildTeamStatus(context),
          const Divider(thickness: 2),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Column(
                  //crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const Text('Batting',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    Builder(builder: (context) {
                      if (wicketCount < widget.playerCountInput! - 1) {
                        if (team1batting) {
                          player1Name =
                              team1PlayerDecodedList[player1Index].player;
                          player2Name =
                              team1PlayerDecodedList[player2Index].player;
                        } else {
                          player1Name =
                              team2PlayerDecodedList[player1Index].player;
                          player2Name =
                              team2PlayerDecodedList[player2Index].player;
                        }
                        return Text(
                            '$player1Name${isPlayer1Batting ? '*' : ''}    $player1Runs\n$player2Name${!isPlayer1Batting ? '*' : ''}    $player2Runs');
                      } else {
                        print("Match Ended");
                        return Text("Match Ended");
                      }
                    }),
                  ],
                ),
              ],
            ),
          )
        ],
      );
    } else {
      return Text("Error1");
    }
  }

  Widget _buildTeamStatus(BuildContext context) {
    inningsBallCount = (widget.oversInput!.round() * 6);
    if (isFirstInnings) {
      if (team1batting) {
        return Center(
            child: Text(
          '${currentMatch!['team1']} is Batting first\nRun Rate: $currentRR',
          style: const TextStyle(fontSize: 20.0),
        ));
      } else {
        return Center(
            child: Text(
          '${currentMatch!['team2']} is Batting first\nRun Rate: $currentRR',
          style: const TextStyle(fontSize: 20.0),
        ));
      }
    } else if (!matchwon) {
      if (team1batting) {
        return Center(
            child: Text(
          '${currentMatch!['team1']} needs $target runs to win\nCurrent Run Rate: $currentRR\nRequired Run Rate: $requiredRR',
          style: const TextStyle(fontSize: 20.0),
        ));
      } else {
        return Center(
            child: Text(
          '${currentMatch!['team2']} needs $target runs to win\nCurrent Run Rate: $currentRR\nRequired Run Rate: $requiredRR',
          style: const TextStyle(fontSize: 20.0),
        ));
      }
    } else {
      return Center(
          child: Text(
        'Match Won',
        style: const TextStyle(fontSize: 20.0),
      ));
    }
  }
}

double roundDouble(double value, int places) {
  double roundedValue = double.parse((value).toStringAsFixed(2));
  return roundedValue;
}

buildShowDialog(BuildContext context) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      });
}
