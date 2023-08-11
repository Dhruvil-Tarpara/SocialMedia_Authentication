import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_user/src/provider/model/model.dart';
import 'local_database.dart';

class FirebaseCloud {
  FirebaseCloud._();

  static final FirebaseCloud firebaseCloud = FirebaseCloud._();
  final FirebaseFirestore dbFirestore = FirebaseFirestore.instance;
  late CollectionReference collectionReference;
  late DocumentReference documentReference;
  final String _collectionName = "keep_notes";

  void createCollection() {
    collectionReference = dbFirestore.collection(_collectionName);
  }

  void createDocument() {
    documentReference =
        collectionReference.doc(SPHelper.prefs.getString("user_uid") ?? "");
  }

  Stream<QuerySnapshot<Object?>> getData() {
    return documentReference.collection("notes").snapshots();
  }

  void insertData({required Note note}) {
    documentReference.collection("notes").add(note.toJson());
  }

  void upDateData({required String doc, required Note note}) {
    documentReference.collection("notes").doc(doc).update(note.toJson());
  }

  void deleteData({required String doc}) {
    documentReference.collection("notes").doc(doc).delete();
  }
}
