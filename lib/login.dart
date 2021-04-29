import 'package:flutter/material.dart';
import 'utilitarios.dart';
import 'package:sqflite/sqflite.dart';

class TelaLogin extends StatefulWidget {
  @override
  _TelaLogin createState() => _TelaLogin();
}

class _TelaLogin extends State<TelaLogin> {
  var login = "";
  var senha = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.orangeAccent[200]),
          actions: <Widget>[
            PopupMenuButton(itemBuilder: (BuildContext context){
              return[
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
                          image: AssetImage('assets/images/background_inicial.png'),
                          fit: BoxFit.cover))
              ),
              new Center(
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(64, 0, 64, 0),
                      child: Container(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                TextFormField(
                                  cursorColor: Colors.orangeAccent[200],
                                  style: TextStyle(color: Colors.black, decorationColor: Colors.white),
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.person, color: Colors.orangeAccent[200], size: 22),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.orangeAccent[200]
                                          )
                                      ),
                                      labelText: 'Usuário:',
                                      labelStyle: TextStyle(color: Colors.black, fontSize: 18),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.orangeAccent[200]
                                          )
                                      )
                                  ),
                                  onChanged: (String input){
                                    setState(() {
                                      login = input;
                                    });
                                  },
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: TextFormField(
                                    cursorColor: Colors.orangeAccent[200],
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.lock, color: Colors.orangeAccent[200], size: 22),
                                        focusColor: Colors.orangeAccent[200],
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.orangeAccent[200]
                                            )
                                        ),
                                        labelText: 'Senha:',
                                        labelStyle: TextStyle(color: Colors.black, fontSize: 18),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.orangeAccent[200]
                                            )
                                        )
                                    ),
                                    onChanged: (String input){
                                      setState(() {
                                        senha = input;
                                      });
                                    },
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
                                    child: botaoVerificaPermissao("Entrar", context, {'login' : login, 'senha' : senha})
                                )

                              ]
                          )
                      )
                  )
              )
            ]
        )
    );
  }
}