import 'dart:ffi';

import 'package:flutter/material.dart';
import '../model/cartao.dart';
import '../model/lista.dart';
import '../servicos/tarefas_servico.dart';
import '../telas/cadastro_cartao.dart';
import '../telas/detalhe_cartao.dart';
import '../telas/cadastro_lista.dart';
import '../model/Quadro.dart';
import '../model/tarefa.dart';
import '../servicos/trello_servico.dart';

class Cartoes extends StatefulWidget {
  final String idQuadro;

  const Cartoes({super.key, required this.idQuadro});

  @override
  _CartoesState createState() => _CartoesState();
}

class _CartoesState extends State<Cartoes> {
  final TextEditingController _pesquisaController = TextEditingController();
  final TrelloService _trelloService = TrelloService();

  List<Tarefa> tarefas = [];
  List<Tarefa> tarefasFinalizadas = [];
  List<DropdownMenuItem<String>> categorias = [];

  String? filtroCategoria;
  DateTime filtroData = DateTime.now();
  bool filtroFinalizado = false;

  TarefasServico tarefasServico = TarefasServico();

  Future<List<Lista>> buscarListas() {
    return _trelloService.buscarListas(widget.idQuadro);
  }

  Future<List<Cartao>> buscarCartao(List<Lista> listas) {
    return _trelloService.buscarCartoes(widget.idQuadro, listas);
  }

  Future<Map<Lista, List<Cartao>>> buscarListasComCartoes() async {
    List<Lista> listas = await buscarListas();
    Map<Lista, List<Cartao>> cartoesAgrupadosPorLista = {};
    for (var lista in listas) {
      cartoesAgrupadosPorLista[lista] = [];
    }
    List<Cartao> cartoes = await buscarCartao(listas);
    for (var cartao in cartoes) {
      Lista? lista = cartao.lista;
      if (cartoesAgrupadosPorLista.containsKey(lista)) {
        cartoesAgrupadosPorLista[lista]!.add(cartao);
      } else {
        cartoesAgrupadosPorLista[lista] = [cartao];
      }
    }
    return cartoesAgrupadosPorLista;
  }

  Future<List<Quadro>> buscarBoards() {
    return _trelloService.buscarQuadros();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pesquisaController.dispose();
    super.dispose();
  }

  Future<void> dataSelecionada() async {
    final DateTime? calendario = await showDatePicker(
      context: context,
      initialDate: filtroData,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (calendario != null && calendario != filtroData) {
      setState(() {
        filtroData = calendario;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cartões'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder<Map<Lista, List<Cartao>>>(
          future: buscarListasComCartoes(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Houve um erro: ${snapshot.error}'),
              );
            } else {
              final cartoesAgrupadosPorLista = snapshot.data;

              return ListView.builder(
                itemCount: cartoesAgrupadosPorLista?.length,
                itemBuilder: (context, index) {
                  Lista lista = cartoesAgrupadosPorLista!.keys.elementAt(index);
                  List<Cartao> cartoesDaLista = cartoesAgrupadosPorLista[lista]!;

                  return ExpansionTile(
                    title: Row(
                      children: [
                        Flexible(
                          fit: FlexFit.tight,
                          child: Text(
                            lista.nome, 
                            softWrap: true,
                            maxLines: null,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CadastroCartao(
                                    idQuadro: widget.idQuadro,
                                    idLista: lista.id ?? 'id_lista'),
                              ),
                            );
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                    children: cartoesDaLista.map((cartao) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        color: const Color.fromRGBO(70, 52, 235, 1),
                        child: ListTile(
                          title: Text(cartao.nome, style: const TextStyle(color: Colors.white)),
                          subtitle: Text(cartao.descricao, style: const TextStyle(color: Colors.white70)),
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetalheCartao(cartao: cartao),
                              ),
                            );
                            setState(() {});
                          },
                        ),
                      );
                    }).toList(),
                  );
                },
              );
            }
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CadastroLista(idQuadro: widget.idQuadro),
                  ),
                );
                setState(() {});
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add),
                  SizedBox(width: 8),
                  Text('Lista'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
