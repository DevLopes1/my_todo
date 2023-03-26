import 'package:my_todo/Models/TarefasModel.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
 import 'package:sqflite/sqflite.dart';

class BancoDados {
  static void criarBanco(Database db, int version) async{
    await db.execute('CREATE TABLE TAREFAS (id INTEGER PRIMARY KEY AUTOINCREMENT, titulo TEXT ,texto TEXT)');
  }

  static Future<Database> abrirBanco()async{
    final caminhoBancoDados = await getDatabasesPath(); //capturaram local onde fica os dbs do celular!
    final path = join(caminhoBancoDados, "apptodo.db");

    return openDatabase(path, onCreate: criarBanco, version: 1);
  }

   static salvarTarefas(TarefasModel tarefa) async{
    Database db = await abrirBanco();
    //String sql = "INSERT INTO (titulo, texto) VALUES('${tarefa.titulo}', '${tarefa.texto}');";
    var valor = {
      'titulo': tarefa.titulo,
      'texto' : tarefa.texto,
    };
   int id = await db.insert("TAREFAS", valor);
   db.close();
  }

  static Future<List<Map<dynamic, dynamic>>> listarTodasTarefas() async{
    Database db = await abrirBanco();
    String sql = "SELECT * FROM TAREFAS";
    List<Map<dynamic, dynamic>> listaTarefas;
    listaTarefas = await db.rawQuery(sql);
    return listaTarefas;
  }
}