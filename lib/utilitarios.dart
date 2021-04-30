import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

botaoGenerico(texto, BuildContext context, rota){
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0),
          ),
          minimumSize: Size(150, 5),
          primary: Colors.orangeAccent[200],
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          textStyle: TextStyle(
            fontSize: 18,
            color: Colors.black54
          )),
      child: Text(texto),
      onPressed: (){
        Navigator.pushNamed(context, rota);
      }
  );
}

botaoSalvarBancoUsuario(texto, BuildContext context, Map dadosUsuario){
  print("entrei botao");
  print(dadosUsuario);
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0),
          ),
          minimumSize: Size(150, 5),
          primary: Colors.orangeAccent[200],
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          textStyle: TextStyle(
              fontSize: 20,
              color: Colors.black54
          )),
      child: Text(texto),
      onPressed: () {
        _salvarDadosUsuario(dadosUsuario['email'], dadosUsuario['login'], dadosUsuario['senha']);
        _listarUsuarios();
        Navigator.pushNamed(context, '/login');
      }
  );
}

botaoSalvarBancoContas(texto, BuildContext context, Map dadosConta){
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0),
          ),
          minimumSize: Size(150, 5),
          primary: Colors.orangeAccent[200],
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          textStyle: TextStyle(
              fontSize: 18,
              color: Colors.black
          )),
      child: Text(texto),
      onPressed: () {
         _salvarDadosUsuario(dadosConta['nome'], dadosConta['valor'], dadosConta['data_validade']);
      }
  );
}

botaoVerificaPermissao(texto, BuildContext context, Map dadosUsuario){
  return ElevatedButton(
      style: ElevatedButton.styleFrom(
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0),
          ),
          minimumSize: Size(150, 5),
          primary: Colors.orangeAccent[200],
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          textStyle: TextStyle(
              fontSize: 18,
              color: Colors.black54
          )),
      child: Text(texto),
      onPressed: () async {
        if(!await _validarUsuario(dadosUsuario['login'], dadosUsuario['senha'])){
          showDialog(
            context:  context,
            builder:  (BuildContext context) {
              return AlertDialog(
                  title: new Text("Não foi possível realizar o login."),
                  content: new Text("Login ou senha inválida!"),
                  actions: <Widget>[
                  // define os botões na base do dialogo
                  new TextButton(
                  child: new Text("Ok"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
        else
          Navigator.pushNamed(context, '/contas');
      }
  );
}

/*FUNÇÕES PARA MANIPULAÇÃO DO BANCO DE DADOS - CRUD*/

/*--------------------------------MANIPULAÇÃO DE USUÁRIOS---------------------------------------------*/
_recuperarBancoDadosUsuario() async{
  print("entrei na _recuperarBancoDadosUsuario");
  final caminhoBD = await getDatabasesPath();
  final localBD   = join(caminhoBD, "banco.bd");
  var bd = await openDatabase(
    localBD,
    version: 1,
    onCreate: (db, dbVersaoRecente){
      String sql = "CREATE TABLE usuarios(id integer primary key autoincrement, email varchar, login varchar, senha varchar)";
      db.execute(sql);
    }
  );
  return bd;
}

_salvarDadosUsuario(String email, String login, String senha) async{
  Database bd = await _recuperarBancoDadosUsuario();
  Map<String, dynamic> dadosUsuario = {
    "email" : email,
    "login": login,
    "senha": senha
  };
  int id = await bd.insert("usuarios", dadosUsuario);
  print("Id salvo: $id");
}

_listarUsuarios() async{
  Database bd = await _recuperarBancoDadosUsuario();
  String sql = "select * from usuarios";
  List usuarios = await bd.rawQuery(sql);
  for(var usuario in usuarios){
    print("\t id: " + usuario['id'].toString() +
          "\n email: " + usuario['email'] +
          "\n login: " + usuario['login'] +
          "\n senha: " + usuario['senha']);
  }
  return usuarios;
}

_validarUsuario(String login, String senha) async{
  List usuarios = await _listarUsuarios();
  bool acesso_permitido = false;
  for(var usuario in usuarios){
    if(usuario['login'] == login && usuario['senha'] == senha)
      acesso_permitido = true;
  }
  return acesso_permitido;
}

_exluirUsuario(int id) async{
  Database bd = await _recuperarBancoDadosUsuario();
  int retorno = await bd.delete(
    "usuarios",
    where: "id = ?",
    whereArgs: [id]
  );
  print("Usuarios excluidos:" + retorno.toString());
}

_atualizarUsuario(int id, Map dadosUsuario) async{
  Database bd = await _recuperarBancoDadosUsuario();
  int retorno = await bd.update(
    "usuarios", dadosUsuario,
    where: "id = ?",
    whereArgs: [id]
  );
  print("Usuario atualizado: " + retorno.toString());
}
/*-----------------------------------MANIPULACAO DE CONTAS--------------------------------------*/
_recuperarBancoDadosContas() async{
  final caminhoBD = await getDatabasesPath();
  final localBD   = join(caminhoBD, "banco.bd");
  var bd = await openDatabase(
      localBD,
      version: 1,
      onCreate: (db, dbVersaoRecente){
        String sql = "create table contas(id integer primary key autoincrement, nome varchar, valor real, data_validade varchar)";
        db.execute(sql);
      }
  );
  return bd;
}

_salvarDadosConta(String nome, double valor, String data_validade) async{
  Database bd = await _recuperarBancoDadosContas();
  Map<String, dynamic> dadosConta = {
    "nome" : nome,
    "valor": valor,
    "data_validade": data_validade
  };
  int id = await bd.insert("contas", dadosConta);
  print("Id salvo: $id");
}

_listarContas() async{
  Database bd = await _recuperarBancoDadosContas();
  String sql = "select * from contas";
  List contas = await bd.rawQuery(sql);
  for(var conta in contas){
    print("\t id: " + conta['id'].toString() +
        "\n nome: " + conta['nome'] +
        "\n valor: " + conta['valor'] +
        "\n data_validade: " + conta['data_validade']);
  }
}

_exluirConta(int id) async{
  Database bd = await _recuperarBancoDadosContas();
  int retorno = await bd.delete(
      "contas",
      where: "id = ?",
      whereArgs: [id]
  );
  print("Contas excluidas:" + retorno.toString());
}

_atualizarContas(int id, Map dadosConta) async{
  Database bd = await _recuperarBancoDadosContas();
  int retorno = await bd.update(
      "contas", dadosConta,
      where: "id = ?",
      whereArgs: [id]
  );
  print("Conta atualizada: " + retorno.toString());
}

/*----------------------------TABELA DE CONTAS--------------------------*/
criaTabelaContas() {
  return Table(
    defaultColumnWidth: FixedColumnWidth(150.0),
    border: TableBorder(
      horizontalInside: BorderSide(
        color: Colors.black,
        style: BorderStyle.solid,
        width: 1.0,
      ),
      verticalInside: BorderSide(
        color: Colors.black,
        style: BorderStyle.solid,
        width: 1.0,
      ),
    ),
    children: [
      _criarLinhaTable("Pontos, Time, Gols"),
      _criarLinhaTable("25, Palmeiras,16 "),
      _criarLinhaTable("20, Santos, 5"),
      _criarLinhaTable("17, Flamento, 6"),
    ],
  );
}
_criarLinhaTable(String listaNomes) {
  return TableRow(
    children: listaNomes.split(',').map((name) {
      return Container(
        alignment: Alignment.center,
        child: Text(
          name,
          style: TextStyle(fontSize: 20.0),
        ),
        padding: EdgeInsets.all(8.0),
      );
    }).toList(),
  );
}
