import 'package:flutter/material.dart';
import 'utilitarios.dart';
import 'package:sqflite/sqflite.dart';

class TelaContas extends StatefulWidget {
  @override
  _TelaContas createState() => _TelaContas();
}

class _TelaContas extends State<TelaContas> {
  var nome_conta;
  var valor_conta;
  var data_validade;
  final _formKey = GlobalKey<FormState>();

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
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.orangeAccent[200],
            elevation: 6,
            child: Icon(Icons.add),
            onPressed: (){
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Adicionar conta à lista: "),
                      content: Stack(
                        children: <Widget>[
                          Form(
                            key: _formKey,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: TextFormField(
                                      cursorColor: Colors.orangeAccent[200],
                                      style: TextStyle(color: Colors.black, decorationColor: Colors.white),
                                      decoration: InputDecoration(
                                          //prefixIcon: Icon(Icons.person, color: Colors.orangeAccent[200], size: 22),
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.orangeAccent[200]
                                              )
                                          ),
                                          labelText: 'Conta:',
                                          labelStyle: TextStyle(color: Colors.black, fontSize: 18),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.orangeAccent[200]
                                              )
                                          )
                                      ),
                                      onChanged: (String input){
                                        setState(() {
                                          nome_conta = input;
                                        });
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: TextFormField(
                                      cursorColor: Colors.orangeAccent[200],
                                      style: TextStyle(color: Colors.black, decorationColor: Colors.white),
                                      decoration: InputDecoration(
                                        //prefixIcon: Icon(Icons.person, color: Colors.orangeAccent[200], size: 22),
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.orangeAccent[200]
                                              )
                                          ),
                                          labelText: 'Valor:',
                                          labelStyle: TextStyle(color: Colors.black, fontSize: 18),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.orangeAccent[200]
                                              )
                                          )
                                      ),
                                      onChanged: (String input){
                                        setState(() {
                                          valor_conta = input;
                                        });
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: TextFormField(
                                      cursorColor: Colors.orangeAccent[200],
                                      style: TextStyle(color: Colors.black, decorationColor: Colors.white),
                                      decoration: InputDecoration(
                                        //prefixIcon: Icon(Icons.person, color: Colors.orangeAccent[200], size: 22),
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.orangeAccent[200]
                                              )
                                          ),
                                          labelText: 'Data de Validade:',
                                          labelStyle: TextStyle(color: Colors.black, fontSize: 18),
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.orangeAccent[200]
                                              )
                                          )
                                      ),
                                      onChanged: (String input){
                                        setState(() {
                                          data_validade = input;
                                        });
                                      },
                                    ),
                                  ),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[
                                        TextButton(
                                          onPressed: (){
                                            Navigator.pop(context);
                                          },
                                          child: Text("Cancelar")
                                      ),
                                      TextButton(
                                          onPressed: (){},
                                          child: Text("Salvar")
                                      )
                                    ]
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
              );
            }
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