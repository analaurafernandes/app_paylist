import 'package:flutter/material.dart';
import 'utilitarios.dart';

class TelaCadastro extends StatefulWidget {
  @override
  _TelaCadastro createState() => _TelaCadastro();
}

class _TelaCadastro extends State<TelaCadastro> {
  var email  = "";
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
                                  style: TextStyle(color: Colors.black, decorationColor: Colors.black),
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.alternate_email_outlined, color: Colors.orangeAccent[200], size: 22),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.orangeAccent[200]
                                          )
                                      ),
                                      labelText: 'E-mail:',
                                      labelStyle: TextStyle(color: Colors.black, fontSize: 18),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.orangeAccent[200]
                                          )
                                      )
                                  ),
                                  onChanged: (String input){
                                    setState(() {
                                      email = input;
                                    });
                                  },
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: TextFormField(
                                    cursorColor: Colors.orangeAccent[200],
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.person, color: Colors.orangeAccent[200], size: 22),
                                        focusColor: Colors.black,
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.orangeAccent[200]
                                            )
                                        ),
                                        labelText: 'Login:',
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
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  child: TextFormField(
                                    cursorColor: Colors.orangeAccent[200],
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.lock, color: Colors.orangeAccent[200], size: 22),
                                        focusColor: Colors.black,
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
                                    child: botaoSalvarBancoUsuario("Cadastrar", context, {'email' : email, 'login' : login, 'senha' : senha})
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