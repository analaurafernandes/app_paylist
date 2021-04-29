import 'package:flutter/material.dart';
import 'utilitarios.dart';
import 'package:sqflite/sqflite.dart';

class TelaContas extends StatefulWidget {
  @override
  _TelaContas createState() => _TelaContas();
}

class _TelaContas extends State<TelaContas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.orangeAccent[200]),
          actions: <Widget>[
            PopupMenuButton(itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(child: Text('Flutter')),
                PopupMenuItem(child: Text('Android')),
              ];
            })
          ],
        ),
        body: new Stack(
          children: <Widget>[
            new Container(
                decoration: new BoxDecoration(
                    image: new DecorationImage(
                        image: AssetImage(
                            'assets/images/background_clean.png'),
                        fit: BoxFit.cover))
            ),
          ],
        )
    );
  }
}