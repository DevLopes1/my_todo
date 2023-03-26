import 'package:my_todo/Database/BancoDados.dart';

class TarefasModel{
  int? id;
  String? titulo;
  String? texto;
}

class TarefasRepositorio{

  static addTarefa(TarefasModel tarefa)async{
   BancoDados.salvarTarefas(tarefa);
  }

  static Future<List<Map<dynamic, dynamic>>> listarTarefas() async{
    List<Map<dynamic, dynamic>> tarefas;
    tarefas = await BancoDados.listarTodasTarefas();
    return tarefas;
  }
}