import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:my_todo/Models/TarefasModel.dart';

class Tarefas extends StatefulWidget {
  const Tarefas({super.key});

  @override
  State<Tarefas> createState() => _TarefasState();
}

class _TarefasState extends State<Tarefas> {
  ScrollController listscroll = ScrollController();
  List<Map<dynamic, dynamic>>? taf;
  bool checkado = false;
  listarPadrao() async {
    return taf = await TarefasRepositorio.listarTarefas();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: listarPadrao(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return Text("Error ao carregar a lista!!!");
              } else {
                return SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        controller: listscroll,
                        itemCount: taf!.length,
                        itemBuilder: (context, index) => Card(
                          margin: EdgeInsets.all(8),
                          child: Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  onTap: () async {
                                    // await detalharclientes(context, listacliente[index]['id']);
                                    //setState(() {});
                                  },
                                  leading: Text(index.toString()),
                                  title: Text(taf![index]["titulo"].toString()),
                                  subtitle:
                                      Text(taf![index]["texto"].toString()),
                                ),
                              ),
                              Checkbox(
                                  value: checkado,
                                  onChanged: (value) {
                                    setState(() {
                                      checkado = value!;
                                    });
                                  }),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
          }
        });
  }
}
