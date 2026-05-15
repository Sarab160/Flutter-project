import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HistoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collection reference
  CollectionReference get _historyCollection =>
      _firestore.collection('users').doc(_auth.currentUser?.uid).collection('history');

  // Save prediction
  Future<void> savePrediction({
    required String category,
    required double aqiscore,
    required String location,
    required List<double> features,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _historyCollection.add({
      'category': category,
      'aqiscore': aqiscore,
      'location': location,
      'features': features,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Get prediction history
  Stream<QuerySnapshot> getHistoryStream() {
    return _historyCollection
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
