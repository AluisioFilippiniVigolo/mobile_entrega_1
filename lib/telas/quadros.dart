import 'package:flutter/material.dart';
import '../model/cartao.dart';
import '../model/lista.dart';
import '../servicos/tarefas_servico.dart';
import '../telas/cadastro_cartao.dart';
import '../model/Quadro.dart';
import '../model/tarefa.dart';
import '../servicos/trello_servico.dart';
import '../telas/cartoes.dart';

class Quadros extends StatefulWidget {
  const Quadros({super.key});

  @override
  _QuadrosState createState() => _QuadrosState();
}

class _QuadrosState extends State<Quadros> {
  final TextEditingController _pesquisaController = TextEditingController();
  final TrelloService _trelloService = TrelloService();

  List<Tarefa> tarefas = [];
  List<Tarefa> tarefasFinalizadas = [];
  List<DropdownMenuItem<String>> categorias = [];

  String? filtroCategoria;
  DateTime filtroData = DateTime.now();
  bool filtroFinalizado = false;

  TarefasServico tarefasServico = TarefasServico();

  //Future<List<Lista>> buscarListas() {
  //  return _trelloService.buscarListas('Teste');
  //}

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
        title: const Text('Quadros'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder<List<Quadro>>(
          future: buscarBoards(),
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
              final listaQuadros = snapshot.data;

              return ListView.builder(
                itemCount: listaQuadros?.length ?? 0,
                itemBuilder: (context, index) {
                  final quadro = listaQuadros?[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                        title: Text(quadro?.nome ?? ''),
                        subtitle: Text(quadro?.id ?? ''),
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Cartoes(idQuadro: quadro!.id),
                            ),
                          );
                        }),
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
                    builder: (context) => const CadastroCartao(idQuadro: '', idLista: "123"),
                  ),
                );
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add),
                  SizedBox(width: 8),
                  Text('Quadro'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
