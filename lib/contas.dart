import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Conta {
  String nome;
  String validade;
  double valor;
  int id;

  Conta(String nome, String validade, double valor, int id){
    this.nome = nome;
    this.validade = validade;
    this.valor = valor;
    this.id = id;
  }
}

class TelaContas extends StatefulWidget {
  @override
  _TelaContas createState() => _TelaContas();
}

class _TelaContas extends State<TelaContas> {
  var nome_conta;
  var valor_conta;
  var data_validade;
  final _formKey = GlobalKey<FormState>();
  var selecionada = false;

  List<Conta> _listSelected = [];
  List<Conta> _listaContas = [new Conta('Cemig', '10/05/2021', 400.00, -1)];
  //_listaContas.add(inicial);
  void _criarLinha (String conta, double valor, String data) async{
    var id = await _salvarDadosConta(conta, valor, data);
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below.
      Conta nova = new Conta(conta, data, valor, id);
      _listaContas.add(nova);

    });
  }

  void onSelect(bool selected, Conta conta){
    setState(() {
      if(selected)
        _listSelected.add(conta);
      else
        _listSelected.remove(conta);
    });
    print(_listSelected);
  }

  void _deletarLinha() async{
    setState(() {
      if (_listSelected.isNotEmpty) {
        List<Conta> temp = [];
        temp.addAll(_listSelected);
         for (Conta conta in temp) {
          _listaContas.remove(conta);
          _listSelected.remove(conta);
          _excluirConta(conta.id);
        }
      }
    });
  }

  void _alterarLinha(Map dados) async{
    setState(() {
      if (_listSelected.isNotEmpty) {
        List<Conta> temp = [];
        Map<String, dynamic> dadosConta = {
          "nome" : dados['nome'],
          "valor": dados['valor'].toString(),
          "data_validade": dados['data_validade']
        };
        temp.addAll(_listSelected);
        for (Conta conta in temp) {
          _listaContas.remove(conta);
          _listSelected.remove(conta);
          _atualizarContas(conta.id, dadosConta);
        }
      }
    });
  }

  /*-----------------------------------MANIPULACAO DE CONTAS--------------------------------------*/
  _recuperarBancoDadosContas() async{
    final caminhoBD = await getDatabasesPath();
    final localBD   = join(caminhoBD, "banco3.bd");
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
    print("ABRI O BANCO DE DADOS CONTA");
    Map<String, dynamic> dadosConta = {
      "nome" : nome,
      "valor": valor,
      "data_validade": data_validade
    };
    print(dadosConta);
    int id = await bd.insert("contas", dadosConta);
    await _listarContas();
    print("Id salvo: $id");
    return id;
  }

  _listarContas() async{
    Database bd = await _recuperarBancoDadosContas();
    String sql = "select * from contas";
    List contas = await bd.rawQuery(sql);
    List<Conta> lista_contas = [];
    setState(() {
      for (var conta in contas) {
        lista_contas.add(new Conta(conta['nome'], conta['data_validade'], conta['valor'], conta['id']));
        print("\t id: " + conta['id'].toString() +
            "\n nome: " + conta['nome'] +
            "\n valor: " + conta['valor'].toString() +
            "\n data_validade: " + conta['data_validade']);
      }
    });
    return lista_contas;
  }

  _excluirConta(int id) async{
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
    _listaContas.add(new Conta(dadosConta['nome'], dadosConta['data_validade'], double.parse(dadosConta['valor']), id));
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
                                          valor_conta = double.parse(input);
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
                                          onPressed: () async{
                                              await _criarLinha(nome_conta, valor_conta, data_validade);
                                              Navigator.pop(context);
                                          },
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
                padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
                child:Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: DataTable(
                            columnSpacing: 30.0,
                            showCheckboxColumn: true,
                            columns: [
                              DataColumn(label: Text('Conta')),
                              DataColumn(label: Text('Valor')),
                              DataColumn(label: Text('Vencimento'))
                            ],
                            rows: _listaContas.map(
                                (conta) => DataRow(
                                  selected: _listSelected.contains(conta),
                                  onSelectChanged: (b){
                                    print("Selecionado! id:" + conta.id.toString());
                                    onSelect(b, conta);
                                  },
                                  cells: [
                                    DataCell(Text(conta.nome)),
                                    DataCell(Text(conta.valor.toString())),
                                    DataCell(Text(conta.validade))
                                  ]
                                )).toList()

                            )
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Expanded(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        TextButton(
                            onPressed: (){
                               _deletarLinha();
                            },
                            style: TextButton.styleFrom(
                              primary: Colors.orangeAccent[200],
                            ),
                            child: Text("Deletar",
                                style: TextStyle(fontSize: 16))
                        ),
                        TextButton(
                            onPressed: () async{
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
                                                          valor_conta = double.parse(input);
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
                                                            onPressed: () async{
                                                              _alterarLinha({'nome':nome_conta, 'valor': valor_conta, 'data_validade':data_validade});
                                                              Navigator.pop(context);
                                                            },
                                                            style: TextButton.styleFrom(
                                                              primary: Colors.orangeAccent[200],
                                                            ),
                                                            child: Text("Atualizar",
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
                            },
                            style: TextButton.styleFrom(
                              primary: Colors.orangeAccent[200],
                            ),
                            child: Text("Alterar",
                                style: TextStyle(fontSize: 16))
                        )
                      ]
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}