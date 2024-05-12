import 'package:flutter/material.dart';
import 'package:flutter_application/model/cartao.dart';
import 'package:flutter_application/model/lista.dart';
import 'package:flutter_application/servicos/tarefas_servico.dart';
import 'package:flutter_application/telas/cadastro_cartao.dart';
import 'package:flutter_application/telas/cadastro_categoria.dart';
import '../model/tarefa.dart';
import '../servicos/trello_servico.dart';

class Cartoes extends StatefulWidget {
  const Cartoes({super.key});

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
    return _trelloService.buscarListas();
  }

  Future<List<Cartao>> buscarCartoes() {
    return _trelloService.buscarCartoes();
  }

  void carregarListas() {
    Future<List<Lista>> _dadosLista = buscarListas();
  }

  @override
  void initState() {
    super.initState();
    carregarListas();
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
        title: const Text('Cartão'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder<List<Cartao>>(
          future: buscarCartoes(),
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
              final listaCartoes = snapshot.data;

              return ListView.builder(
                itemCount: listaCartoes?.length,
                itemBuilder: (context, index) {
                  final cartao = listaCartoes?[index];

                  return ListTile(
                    title: Text(cartao!.nome ?? ''),
                    subtitle: Text(cartao.descricao ?? ''),
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
                    builder: (context) => const CadastroCategoria(),
                  ),
                );
                //carregarCategorias();
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add),
                  SizedBox(width: 8),
                  Text('Categoria'),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CadastroCartao(),
                  ),
                );
                //carregarTarefas();
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add),
                  SizedBox(width: 8),
                  Text('Tarefa'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
