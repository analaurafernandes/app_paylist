import 'package:paylist/login.dart';
import 'package:flutter/material.dart';
import 'utilitarios.dart';
import 'login.dart';
import 'cadastro.dart';
import 'contas.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget{
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: "/",
        routes: {
          "/login":     (context) => TelaLogin(),
          "/cadastrar": (context) => TelaCadastro(),
          "/contas" :   (context) => TelaContas()
        },
        //theme: ThemeData(primaryColor: Colors.deepPurple[200]),
        home: HomePage()
    );
  }
}

class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
          title: Text(
              "Divisor de Contas", style: TextStyle(color: Colors.white)),
          centerTitle: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
        ),*/
        body: new Stack(
            children: <Widget>[
              new Container(
                  decoration: new BoxDecoration(
                      image: new DecorationImage(
                          image: AssetImage('assets/images/background_inicial.png'),
                          fit: BoxFit.cover))
              ),
              new Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(0,10,0,10),
                          child: botaoGenerico("Entrar", context, "/login"),
                        ),
                        botaoGenerico("Cadastrar", context, "/cadastrar")
                      ]
                  )
              )
            ]
        ),
        extendBody: true,
        extendBodyBehindAppBar: true
    );
  }
}