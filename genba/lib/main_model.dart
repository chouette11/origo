import 'package:flutter/foundation.dart';
import 'package:genba/firebase_model.dart';
import 'package:genba/type.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class MainModel extends ChangeNotifier {
  Types? type;


  Future<void> init() async {

    type = await getFromFirebase('test',"ゲスト");
    notifyListeners();
  }

  updateType() async {
    type = await getFromFirebase('test',"ゲスト");
    notifyListeners();
  }
}