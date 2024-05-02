import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addMatchDetails(Map<String, dynamic> matchInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("MatchData")
        .doc(id)
        .set(matchInfoMap);
  }

  // Future<Stream<QuerySnapshot>> getMatchDetails() async {
  //   return await FirebaseFirestore.instance.collection("MatchData").snapshots();
  // }
}
