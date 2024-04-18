import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application/servicos/tarefas_servico.dart';
import 'package:flutter_application/telas/cadastro_categoria.dart';
import 'package:flutter_application/telas/cadastro_tarefa.dart';
import '../model/tarefa.dart';

class Tarefas extends StatefulWidget {
  const Tarefas({super.key});

  @override
  _TarefasState createState() => _TarefasState();
}

class _TarefasState extends State<Tarefas> {
  final TextEditingController _pesquisaController = TextEditingController();

  List<Tarefa> tarefas = [];
  List<Tarefa> tarefasFinalizadas = [];

  String? filtroCategoria;
  DateTime filtroData = DateTime.now();
  bool filtroFinalizado = false;
  bool _isSearching = false;

  TarefasServico tarefasServico = TarefasServico();

  List<DropdownMenuItem<String>> categorias = [];

  @override
  void initState() {
    super.initState();
    carregarCategorias();
    carregarTarefas();
    carregarTarefasFinalizadas();
  }

  @override
  void dispose() {
    _pesquisaController.dispose();
    super.dispose();
  }

  Future<void> carregarCategorias() async {
    List<DropdownMenuItem<String>> items =
        await tarefasServico.listarCategorias();
    setState(() {
      categorias = items;
    });
  }

  Future<void> carregarTarefas() async {
    List<Tarefa> items = await tarefasServico.listarTarefas(false);
    setState(() {
      tarefas = items;
    });
  }

  Future<void> carregarTarefasFinalizadas() async {
    List<Tarefa> items = await tarefasServico.listarTarefas(true);
    setState(() {
      tarefasFinalizadas = items;
    });
  }

  Future<void> filtrarTarefasPelaDescricao() async {
    List<Tarefa> items =
        await tarefasServico.buscarTarefasPeloTitulo(_pesquisaController.text);

    List<Tarefa> itemsFinalizados =
        items.where((tarefa) => tarefa.finalizada == true).toList();
    List<Tarefa> itemsNaoFinalizados =
        items.where((tarefa) => tarefa.finalizada == false).toList();

    setState(() {
      tarefas = itemsNaoFinalizados;
      tarefasFinalizadas = itemsFinalizados;
    });
  }

  void onPesquisaChanged(String textoPesquisa) {
    filtrarTarefasPelaDescricao();
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

  void categoriaSelecionada(String? category) {
    setState(() {
      filtroCategoria = category;
    });
  }

  void tarefaFinalizada(bool? value) async {
    setState(() {
      filtroFinalizado = value ?? false;
    });
  }

  Future<void> finalizarTarefa(bool? value, Tarefa tarefa) async {
    await tarefasServico.finalizarTarefa(value, tarefa);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _pesquisaController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Pesquisar...',
                  border: InputBorder.none,
                ),
                onChanged: onPesquisaChanged,
              )
            : const Text('Lista de Tarefas'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _pesquisaController.clear();
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Text('Categoria'),
                    DropdownButton<String>(
                      value: filtroCategoria,
                      onChanged: categoriaSelecionada,
                      items: categorias,
                      hint: const Text('Filtrar'),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text('Data'),
                    TextButton(
                      onPressed: dataSelecionada,
                      child: Text(
                        '${filtroData.day}/${filtroData.month}/${filtroData.year}',
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text('Finalizada'),
                    Checkbox(
                      value: filtroFinalizado,
                      onChanged: tarefaFinalizada,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount:
                  filtroFinalizado ? tarefasFinalizadas.length : tarefas.length,
              itemBuilder: (context, index) {
                final tarefa = filtroFinalizado
                    ? tarefasFinalizadas[index]
                    : tarefas[index];
                if (filtroCategoria != null &&
                    tarefa.categoria?.categoria != filtroCategoria) {
                  return SizedBox.shrink();
                }
                if (tarefa.data?.year != filtroData.year ||
                    tarefa.data?.month != filtroData.month ||
                    tarefa.data?.day != filtroData.day) {
                  return SizedBox.shrink();
                }
                if (!filtroFinalizado && (tarefa.finalizada ?? false)) {
                  return SizedBox.shrink();
                }
                return ListTile(
                  leading: Checkbox(
                    value: tarefa.finalizada,
                    onChanged: (value) async {
                      setState(() {
                        tarefa.finalizada = value!;
                        if (tarefa.finalizada ?? false) {
                          tarefasFinalizadas.add(tarefa);
                          tarefas.remove(tarefa);
                        } else {
                          tarefas.add(tarefa);
                          tarefasFinalizadas.remove(tarefa);
                        }
                      });
                      await finalizarTarefa(value, tarefa);
                    },
                  ),
                  title: Text(tarefa.titulo ?? ""),
                  subtitle: Text(tarefa.categoria?.categoria ?? ""),
                  trailing: Text(
                    '${tarefa.data?.day}/${tarefa.data?.month}/${tarefa.data?.year}',
                  ),
                );
              },
            ),
          ),
        ],
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
                carregarCategorias();
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
                    builder: (context) => const CadastroTarefa(),
                  ),
                );
                carregarTarefas();
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
