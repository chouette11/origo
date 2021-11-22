import 'package:cloud_firestore/cloud_firestore.dart';

class Types {
  String text = '';
  Types(DocumentSnapshot doc) {
    final data = doc.data() as Map;
    text = data['text'] as String;
  }
}