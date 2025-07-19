import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:convert';//conversões utilizando o json

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List _listaTarefas = [];
  //TextEditingController _controllerTarefa = TextEditingController();

  //Retorna um arquivo
  Future<File> _getFile() async { 

    final diretorio = await getApplicationDocumentsDirectory(); //Salva os arquivos
    return File("${diretorio.path}/_listaTarefas"); //Retorna os arquivos salvos
  
  }

  _salvarArquivo() async {

    var arquivo = await _getFile();


    //Criar dados
    Map<String, dynamic> tarefa = Map();
    tarefa["titulo"] = "Ir ao mercado";
    tarefa["realizada"] = false;
    _listaTarefas.add(tarefa);

    //Salva a lista de tarefas
    String dados = json.encode(_listaTarefas);
    arquivo.writeAsString(dados);
  }

  _lerArquivo() async {
    try{

      final arquivo = await _getFile();//Para ler o arquivo, é preciso recuperar o arquivo que foi salvo
      return arquivo.readAsString();
    }catch(e){
      return null;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //faz a leitura do arquivo e, então, captura os dados
    _lerArquivo().then((dados){
      setState(() {
        _listaTarefas = json.decode(dados);
      });
    });
      
  }

  @override
  Widget build(BuildContext context) {

    print("itens: " + _listaTarefas.toString());


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text("Lista de tarefas",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white
        ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _listaTarefas.length,
                itemBuilder: (context, index){
                  return ListTile(
                    title: Text(_listaTarefas[index]["titulo"]),
                  );
                }
                )
              )
            
          ],
        ),
      ),
      
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        elevation: 6,
        //mini: true,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: (){
          showDialog(
            context: context, 
            builder: (context){
              return AlertDialog(
                title: Text("Adicionar Tarefa"),
                content: TextField(
                  //controller: _controllerTarefa, 
                  decoration: InputDecoration(
                    labelText: ("Digite sua tarefa")
                  ),
                  onChanged: (text){

                  },
                ),
                actions: [
                  TextButton(
                    onPressed: ()=> Navigator.pop(context), 
                    child: Text("Cancelar")
                    ),
                  TextButton(
                    onPressed: (){
                      //salvar
                      Navigator.pop(context);
                    }, 
                    child: Text("Salvar")
                    ),
                ],
              );
            }
            );
        },
        shape: CircleBorder(),
        )
        /*bottomNavigationBar: BottomAppBar(
          shape: CircularNotchedRectangle(),
          child: Row(
            children: [
              IconButton(
                onPressed: (){}, 
                icon: Icon(Icons.home, color: Colors.deepOrange)
                ),
            ],
          ),
        ),*/
    );
  }
}