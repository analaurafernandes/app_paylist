import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TelaContas extends StatefulWidget {
  @override
  _TelaContas createState() => _TelaContas();
}

class _TelaContas extends State<TelaContas> {
  var nome_conta;
  var valor_conta;
  var data_validade;
  final _formKey = GlobalKey<FormState>();

  List<DataRow> _rowList = [
    DataRow(cells: <DataCell>[
      DataCell(Text('AAAAAA')),
      DataCell(Text('1')),
      DataCell(Text('Yes'))
    ]),
  ];

  void _criarLinha(String conta, String valor, String data){
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below.
      _rowList.add(DataRow(cells: <DataCell>[
        DataCell(Text(conta)),
        DataCell(Text(valor)),
        DataCell(Text(data)),
      ]));
    });
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
          _salvarDadosConta(dadosConta['nome'], dadosConta['valor'], dadosConta['data_validade']);
          _criarLinha(dadosConta['nome'], dadosConta['valor'], dadosConta['data_validade']);
        }
    );
  }

  /*--------------------------------------------------------------*/
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
                                          style: TextButton.styleFrom(
                                            primary: Colors.orangeAccent[200],
                                          ),
                                          child: Text("Cancelar",
                                            style: TextStyle(fontSize: 16))
                                      ),
                                      TextButton(
                                          onPressed: (){},
                                          style: TextButton.styleFrom(
                                            primary: Colors.orangeAccent[200],
                                          ),
                                          child: Text("Salvar",
                                            style: TextStyle(fontSize: 16))
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
                        fit: BoxFit.cover)),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 64, 20, 20),
                child: DataTable(
                    columns: [
                      DataColumn(label: Text('Conta')),
                      DataColumn(label: Text('Valor')),
                      DataColumn(label: Text('Vencimento'))
                    ],
                    rows: _rowList
                ),
            ),
          ),
        ],
      ),
    );
  }
}