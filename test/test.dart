import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addData(String collection, Map<String, dynamic> data) async {
  await FirebaseFirestore.instance.collection(collection).add(data);
}

Future<List<Map<String, dynamic>>> getData(String collection) async {
  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection(collection).get();

  return querySnapshot.docs
      .map((DocumentSnapshot document) =>
          Map<String, dynamic>.from(document.data() as Map))
      .toList();
}


Future<void> updateData(String collection, String documentId,
    Map<String, dynamic> newData) async {
      await FirebaseFirestore.instance
          .collection(collection)
          .doc(documentId)
          .update(newData);
}


Future<void> deleteData(String collection, String documentId) async {
  await FirebaseFirestore.instance
      .collection(collection)
      .doc(documentId)
      .delete();
}


