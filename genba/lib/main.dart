import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:genba/camera.dart';
import 'package:genba/firebase_model.dart';
import 'package:genba/goyukkuri.dart';
import 'package:genba/image.dart';
import 'package:genba/main_model.dart';
import 'package:genba/type.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: FaceDetectPage()));
}

class FaceDetectPage extends StatelessWidget {
  const FaceDetectPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Camera();
  }
}

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {

  @override
  void initState() {
    final player = AudioCache();
    player.play("aisatu.mp3");
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Future<String> _calculation = Future<String>.delayed(
        Duration(seconds: 2),
            () => '計算が終わりました'
    );
    return ChangeNotifierProvider<MainModel>(
      create: (_) => MainModel(),
      child: Scaffold(
        body: SafeArea(
          child: FutureBuilder(
            future: _calculation,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.hasData) {
                return QRViewExample();
              } else {
                return Center(
                  child: Column(
                    children: [
                      Padding(padding: EdgeInsets.only(top: 24)),
                      Image.asset("assets/annai.png"),
                      Text(
                          "いらっしゃいませ!",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  QRViewController? mycontroller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool isQR = true;
  bool isPass = false;


  @override
  Widget build(BuildContext context) {
    final type = context.select<MainModel, Types?>
      ((MainModel model) => model.type);
    return Consumer<MainModel>(builder: (context, model, child) {

      void _onQRViewCreated(QRViewController controller) {
        setState(() {
          mycontroller = controller;
        });
        controller.scannedDataStream.listen((scanData) {
          setState(() {
            result = scanData;
          });
        });
      }

      void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
        log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
        if (!p) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('no Permission')),
          );
        }
      }

      Widget _buildQrView(BuildContext context) {
        // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
        var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
            ? 150.0
            : 300.0;
        // To ensure the Scanner view is properly sizes after rotation
        // we need to listen for Flutter SizeChanged notification and update controller
        return QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
          overlay: QrScannerOverlayShape(
              borderColor: Colors.red,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: scanArea),
          onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
        );
      }

      return Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(flex: 4, child: _buildQrView(context)),
            Expanded(
              flex: 1,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    if (result != null)
                      Container(
                        margin: EdgeInsets.only(left: 16, right: 16),
                        child: Column(
                          children: [
                            Text(
                                'お部屋の暗証番号はこちらです',
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Text(
                                    "${result!.code}",
                                ),
                                SizedBox(width: 16),
                                ElevatedButton(
                                    onPressed: () => Navigator.of(context).pushAndRemoveUntil( MaterialPageRoute(builder: (context) => Goyukkuri()), (route) => false),
                                    child: Text("確認")),
                              ],
                            )
                          ],
                        ),

                      )
                    else
                      Container(
                        margin: EdgeInsets.only(left: 16, right: 16),
                          child: const Text('QRコードをかざしてください')),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}

