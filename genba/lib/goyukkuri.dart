import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:genba/camera.dart';

class Goyukkuri extends StatefulWidget {
  const Goyukkuri({Key? key}) : super(key: key);

  @override
  _GoyukkuriState createState() => _GoyukkuriState();
}

class _GoyukkuriState extends State<Goyukkuri> {
  final Future<String> _calculation = Future<String>.delayed(
      Duration(seconds: 6),
          () => '計算が終わりました'
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
          future: _calculation,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              return RaisedButton(onPressed: () => Navigator.of(context).pushAndRemoveUntil( MaterialPageRoute(builder: (context) => Camera()), (route) => false));
            } else {
              return Center(
                child: Column(
                  children: [
                    Padding(padding: EdgeInsets.only(top: 24)),
                    Image.asset("assets/annai.png"),
                    Text(
                        "ごゆっくりお過ごしください",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,)
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
