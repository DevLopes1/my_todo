import 'package:flutter/material.dart';
import 'package:my_todo/Database/BancoDados.dart';
import 'package:my_todo/Models/TarefasModel.dart';
import 'package:my_todo/Tarefas.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  BancoDados.abrirBanco();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _texto = TextEditingController();
  TextEditingController _titulo = TextEditingController();
  int _indexPages = 0;
  int idret = 0;
  List<Map<dynamic, dynamic>>? taf;

  addTodoDialog() {
    //limpando campos!
    setState(() {
      _texto.text = "";
      _titulo.text = "";
    });

    AlertDialog alertErroCampos = AlertDialog(
      actions: [
        ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Ok")),
      ],
      content: Text("Erro! Preencha todos os campos!"),
    );

    TextButton botaoSalvar = TextButton(
      onPressed: () async {
        if (_texto.text != "" || _titulo.text != "") {
          TarefasModel tarefa = TarefasModel();
          tarefa.texto = _texto.text;
          tarefa.titulo = _titulo.text;

          await TarefasRepositorio.addTarefa(tarefa);
          Navigator.pop(context);
          //possivel setstate aq
        } else {
          showDialog(context: context, builder: (context) => alertErroCampos);
        }
      },
      child: const Text(
        "Salvar",
        style: TextStyle(color: Colors.white),
      ),
      style: ButtonStyle(
          backgroundColor:
              MaterialStateColor.resolveWith((states) => Colors.blue)),
    );

    AlertDialog addTodoAlert = AlertDialog(
      actions: [
        SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: _titulo,
                decoration: InputDecoration(labelText: "Título"),
              ),
              TextFormField(
                controller: _texto,
                decoration: InputDecoration(labelText: "Texto"),
              ),
              botaoSalvar,
            ],
          ),
        ),
      ],
      content: Text("Adicionar Tarefa!"),
    );

    showDialog(context: context, builder: (context) => addTodoAlert);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("My To do"),
          backgroundColor: Colors.blue[800],
        ),
        backgroundColor: Colors.white,
        body: IndexedStack(
          index: _indexPages,
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        taf = await TarefasRepositorio.listarTarefas();
                        setState(() {});
                      },
                      child: Text("CONSULTA SQL!")),
                  Text(
                    "texto: id: ${idret.toString()} ${taf.toString()}",
                    style: TextStyle(fontSize: 23),
                  ),
                ],
              ),
            ),
            Tarefas(),
            Column(
              children: const [
                Text(
                  "Apenas um  Texto 3",
                  style: TextStyle(fontSize: 23),
                ),
              ],
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: addTodoDialog,
            backgroundColor: Colors.blue[800],
            child: Icon(Icons.add)),
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.white70,
            unselectedItemColor: Colors.blue[800],
            selectedItemColor: Colors.blue,
            currentIndex: _indexPages,
            onTap: (index) {
              setState(() {
                _indexPages = index;
              });
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(icon: Icon(Icons.task), label: "Tarefas"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), label: "Configurações"),
            ]),
      ),
    );
  }
}
