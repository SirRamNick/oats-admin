import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference alumni =
      FirebaseFirestore.instance.collection('alumni');

  final CollectionReference stats =
      FirebaseFirestore.instance.collection('statistics');

  final CollectionReference empStats =
      FirebaseFirestore.instance.collection('employment_status');

  // Create functionality is passed onto the Alumni Site

  // Read
  Future getAlumnus(String docID) => alumni.doc(docID).get();

  // Delete
  Future deleteAlumnus(String? docID) => alumni.doc(docID).delete();
}
