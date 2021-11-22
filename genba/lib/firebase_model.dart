import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:genba/type.dart';


Future<Types?> getFromFirebase(String collectionName, String uid) async {
  final collection = FirebaseFirestore.instance.collection(collectionName);
  try {
    final doc = await collection.doc(uid).get();
    return Types(doc);
  } catch (e) {
    print(e);
    return null;
  }
}

Future postToFirebase(String collectionName, String fieldName, dynamic data, String uid) async {
  final collection = FirebaseFirestore.instance.collection(collectionName);
  try {
    return collection
        .doc(uid)
        .set(
      <String, dynamic>{
        fieldName: data
      },
      SetOptions(merge: true),
    );
  } catch (e) {
    print(e);
  }
}