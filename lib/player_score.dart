import 'dart:convert';

import 'package:flutter/foundation.dart';

class PlayerScore {
  String? player;
  int? score;

  PlayerScore({this.player, this.score});

  factory PlayerScore.fromJson(Map<String, dynamic> json) {
    return PlayerScore(
      player: json['player'],
      score: json['score'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'player': player,
      'score': score,
    };
  }

  List<PlayerScore> parsePlayerScores(String json) {
    final parsed = jsonDecode(json).cast<Map<String, dynamic>>();
    return parsed
        .map<PlayerScore>((json) => PlayerScore.fromJson(json))
        .toList();
  }

  String playerScoresToJson(List<PlayerScore> playerScores) {
    List<Map<String, dynamic>> jsonData =
        playerScores.map((playerScore) => playerScore.toJson()).toList();
    return jsonEncode(jsonData);
  }
}
