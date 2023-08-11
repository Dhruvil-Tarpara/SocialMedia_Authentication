import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_user/src/constant/global.dart';
import 'package:get_user/src/provider/model/model.dart';
import 'local_database.dart';

class FirebaseCloud {
  FirebaseCloud._();

  static final FirebaseCloud firebaseCloud = FirebaseCloud._();
  final FirebaseFirestore dbFirestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  late CollectionReference collectionReference;
  late DocumentReference documentReference;
  final String _collectionName = "keep_notes";
  final String _chaildCollectionName = "notes";

  void createCollection() {
    collectionReference = dbFirestore.collection(_collectionName);
  }

  void createDocument() {
    documentReference =
        collectionReference.doc(SPHelper.prefs.getString(Global.userUid) ?? "");
  }

  Stream<QuerySnapshot<Object?>> getData() {
    return documentReference.collection(_chaildCollectionName).snapshots();
  }

  void insertData({required Note note}) {
    documentReference.collection(_chaildCollectionName).add(note.toJson());
  }

  void upDateData({required String doc, required Note note}) {
    documentReference
        .collection(_chaildCollectionName)
        .doc(doc)
        .update(note.toJson());
  }

  void deleteData({required String doc}) {
    documentReference.collection(_chaildCollectionName).doc(doc).delete();
  }

  Future<String> getImageURl() async {
    Reference reference = firebaseStorage
        .refFromURL("gs://get-user-dc086.appspot.com/assets_logo/search.png");
    String data = await reference.getDownloadURL();
    return data;
  }

  Future<bool> getFolder() async {
    try {
      final ListResult data =
          await firebaseStorage.ref().child("assets_logo").list();
      final List<Reference> allFiles = data.items;
      for (var element in allFiles) {
        Global.allImage[element.name] = await element.getDownloadURL();
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
