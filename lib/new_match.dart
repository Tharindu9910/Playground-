import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';
import 'package:score_keeper/database.dart';
import 'package:score_keeper/matchData.dart';
import 'package:score_keeper/player_score.dart';
import 'package:score_keeper/scorecard.dart';
import 'header.dart';

class NewMatch extends StatefulWidget {
  const NewMatch({Key? key}) : super(key: key);

  @override
  State<NewMatch> createState() => _NewMatchState();
}

class _NewMatchState extends State<NewMatch> {
  TextEditingController team1 = TextEditingController();
  TextEditingController team2 = TextEditingController();
  TextEditingController overs = TextEditingController();
  TextEditingController players = TextEditingController();
  TextEditingController playerTeam1 = TextEditingController();
  TextEditingController playerTeam2 = TextEditingController();
  String _selectedTeam = 'Team 1';
  bool team1batting = true;
  String errorTextVal = "";
  final _formKey = GlobalKey<FormState>();
  var id;
  int team1PlayerCount = 0;
  int team2PlayerCount = 0;

  //creating matchData object
  matchData currentMatch = matchData();
  List<PlayerScore> team1PlayerInfoList = [];
  List<PlayerScore> team2PlayerInfoList = [];

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    team1.dispose();
    team2.dispose();
    overs.dispose();
    players.dispose();
    playerTeam1.dispose();
    playerTeam2.dispose();
    super.dispose();
  }

  String get _errorText {
    final text = overs.value.text;
    if (text.isEmpty) {
      return 'Name can\'t be empty';
    }
    // return null if the text is valid
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          //resizeToAvoidBottomInset: false,
          appBar: Header(),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      keyboardType: TextInputType.name,
                      controller: team1,
                      decoration: const InputDecoration(
                        labelText: 'Team 1',
                        hintText: 'Enter team 1 name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Empty Field";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                        height: 16.0), // Add space of 16.0 logical pixels
                    TextFormField(
                      controller: team2,
                      decoration: const InputDecoration(
                        labelText: 'Team 2',
                        hintText: 'Enter team 2 name',
                        border: OutlineInputBorder(),
                        //errorText: errorTextVal.isEmpty ? null : errorTextVal
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Empty Field";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                        height: 16.0), // Add space of 16.0 logical pixels
                    Row(children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text('Overs'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              const Icon(Icons.remove),
                              const SizedBox(
                                  width:
                                      8.0), // Add space of 8.0 logical pixels
                              SizedBox(
                                width: 60.0,
                                height: 40.0,
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  controller: overs,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    //errorText: _errorText.isEmpty ? null : errorTextVal,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Empty";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(
                                  width:
                                      8.0), // Add space of 8.0 logical pixels

                              const Icon(Icons.add),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text('Players'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              const Icon(Icons.remove),
                              const SizedBox(
                                  width:
                                      8.0), // Add space of 8.0 logical pixels
                              SizedBox(
                                width: 60.0,
                                height: 40.0,
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  controller: players,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Empty";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(
                                  width:
                                      8.0), // Add space of 8.0 logical pixels

                              const Icon(Icons.add),
                            ],
                          ),
                        ],
                      ),
                    ]),
                    const SizedBox(
                        height: 16.0), // Add space of 16.0 logical pixels
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text("Who's batting first"),
                        DropdownButton<String>(
                          value: _selectedTeam,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedTeam = newValue!;
                            });
                          },
                          items:
                              <String>['Team 1', 'Team 2'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        Column(
                          children: [
                            const Row(
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(0.0, 5.0, 5.0, 10.0),
                                  child: Text("Enter player names"),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const SizedBox(
                                  width: 10.0,
                                ),
                                SizedBox(
                                  width: 135.0,
                                  child: TextFormField(
                                    keyboardType: TextInputType.name,
                                    controller: playerTeam1,
                                    decoration: InputDecoration(
                                      labelText: 'Team 1',
                                      hintText: 'name',
                                      border: OutlineInputBorder(),
                                      suffixIcon: IconButton(
                                        onPressed: playerTeam1.clear,
                                        icon: Icon(Icons.clear),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Empty Field";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 40.0,
                                  child: RawMaterialButton(
                                    onPressed: () {
                                      if (players.text != "") {
                                        if (team1PlayerCount <
                                            int.tryParse(players.text)!) {
                                          var playerScore1 = PlayerScore(
                                              player: playerTeam1.text,
                                              score: 0);
                                          team1PlayerInfoList.add(playerScore1);
                                          playerTeam1.text = "";
                                          team1PlayerCount++;
                                        } else {
                                          return;
                                        }
                                      }
                                    },
                                    elevation: 2.0,
                                    fillColor: Colors.white,
                                    padding: EdgeInsets.all(5.0),
                                    shape: CircleBorder(),
                                    child: const Icon(
                                      Icons.add,
                                      size: 20.0,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 12.0,
                                ),
                                SizedBox(
                                  width: 135.0,
                                  child: TextFormField(
                                    keyboardType: TextInputType.name,
                                    controller: playerTeam2,
                                    decoration: InputDecoration(
                                      labelText: 'Team 2',
                                      hintText: 'name',
                                      border: OutlineInputBorder(),
                                      suffixIcon: IconButton(
                                        onPressed: playerTeam2.clear,
                                        icon: Icon(Icons.clear),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Empty Field";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 40.0,
                                  child: RawMaterialButton(
                                    onPressed: () {
                                      if (players.text != "") {
                                        if (team2PlayerCount <
                                            int.tryParse(players.text)!) {
                                          var playerScore2 = PlayerScore(
                                              player: playerTeam2.text,
                                              score: 0);
                                          team2PlayerInfoList.add(playerScore2);
                                          playerTeam2.text = "";
                                          team2PlayerCount++;
                                        } else {
                                          return;
                                        }
                                      }
                                    },
                                    elevation: 2.0,
                                    fillColor: Colors.white,
                                    padding: EdgeInsets.all(5.0),
                                    shape: CircleBorder(),
                                    child: const Icon(
                                      Icons.add,
                                      size: 20.0,
                                      fill: 0.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 37.0),
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            id = randomAlphaNumeric(20);
                            //assign values for matchData object
                            currentMatch.overs = double.parse(overs.text);
                            currentMatch.playerCount = int.parse(players.text);
                            currentMatch.selectedTeam = _selectedTeam;
                            //json data handling
                            var team1PlayerJSONList = PlayerScore()
                                .playerScoresToJson(
                                    team1PlayerInfoList); //convert dartlist to json list
                            var team2PlayerJSONList = PlayerScore()
                                .playerScoresToJson(
                                    team2PlayerInfoList); //convert dartlist to json list

                            //Adding new match to database
                            Map<String, dynamic> matchInfoMap = {
                              "team1": team1.text,
                              "team1Overs": double.parse(overs.text),
                              "team1Score": 0,
                              "team1Wickets": int.parse(players.text),
                              "team2": team2.text,
                              "team2Overs": double.parse(overs.text),
                              "team2Score": 0,
                              "team2Wickets": int.parse(players.text),
                              "team1PlayerList": team1PlayerJSONList,
                              "team2PlayerList": team2PlayerJSONList,
                            };
                            await DatabaseMethods()
                                .addMatchDetails(matchInfoMap, id);
                            Fluttertoast.showToast(
                                msg: "Match Created",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black26,
                                textColor: Colors.white,
                                fontSize: 16.0);
                            //print data in console.....................................................................
                            // for (var i = 0;
                            //     i < currentMatch.team1Players.length;
                            //     i++) {
                            //   print(currentMatch.team1Players[i]);
                            // }
                            if (_selectedTeam == "Team 1") {
                              team1batting = true;
                            } else {
                              team1batting = false;
                            }

                            print("******");

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ScoreCard(
                                    //team1: team1.text,
                                    //team2: team2.text,
                                    docId: id!.toString(),
                                    oversInput: double.parse(overs.text),
                                    playerCountInput: int.parse(players.text),
                                    selectedTeam: _selectedTeam,
                                    team1Bat: team1batting,
                                  ),
                                ));

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Processing Data')),
                            );
                          }
                        },
                        child: const Text('Create Match'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


// showAlertDialog(BuildContext context) {
//   // Create button
//   Widget okButton = TextButton(
//     child: Text("OK"),
//     onPressed: () {
//       Navigator.of(context).pop();
//     },
//   );
// // Create AlertDialog
//   AlertDialog alert = AlertDialog(
//     title: Text("Empty"),
//     content: Text("Fill the empty fields"),
//     actions: [
//       okButton,
//     ],
//   );

//   // show the dialog
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return alert;
//     },
//   );
// }
