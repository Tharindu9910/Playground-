import 'package:flutter/material.dart';
import 'header.dart';
import 'new_match.dart';
import 'theme.dart';
import 'team_score_summary.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  //firebase initialization
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false, // Remove the debug banner
    // ... other app configurations
    title: 'PlayGround',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppTheme.primaryColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryColor,
          foregroundColor: Colors.white,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
    ),
    home: Home(),
  ));
}

class Home extends StatelessWidget {
  final db = FirebaseFirestore.instance;
  var matchSummary;

  //const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(),
      body: StreamBuilder<QuerySnapshot>(
        stream: db.collection('MatchData').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.data == null) {
              return const SizedBox.shrink();
            }
            return ListView(
              children: snapshot.data!.docs.map((doc) {
                matchSummary = doc.data();
                List<TeamScoreSummary> firestoreData = [
                  TeamScoreSummary(
                    team1: matchSummary['team1'],
                    team2: matchSummary['team2'],
                    team1Score: matchSummary['team1Score'],
                    team2Score: matchSummary['team2Score'],
                    team1Wickets: matchSummary['team1Wickets'],
                    team2Wickets: matchSummary['team2Wickets'],
                    team1Overs: matchSummary['team1Overs'],
                    team2Overs: matchSummary['team2Overs'],
                  ),
                ];
                final TeamScoreSummary match = firestoreData[0];

                return Column(
                  children: <Widget>[
                    match,
                    const Divider(thickness: 2),
                  ],
                );
              }).toList(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewMatch()),
          );
        },
        child: const Text('New'),
      ),
    );
  }
}
