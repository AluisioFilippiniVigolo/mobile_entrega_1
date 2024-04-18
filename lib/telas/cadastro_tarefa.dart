import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../bd/banco_helper.dart';
import '../model/categoria.dart';
import '../model/tarefa.dart';
import '../servicos/cadastro_tarefa_servico.dart';

class CadastroTarefa extends StatefulWidget {
  const CadastroTarefa({super.key});

  @override
  _CadastroTarefaState createState() => _CadastroTarefaState();
}

class _CadastroTarefaState extends State<CadastroTarefa> {
  final TextEditingController _controllerTitulo = TextEditingController();
  final TextEditingController _controllerData = TextEditingController();
  final TextEditingController _controllerFinalizada = TextEditingController();
  final TextEditingController _controllerCategoria = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final Tarefa dadosTarefa = Tarefa();
  final Categoria dadosCategoria = Categoria();
  var dbHelper = BancoHelper();
  bool checkboxValue = false;

  CadastroTarefasServico cadastroTarefasServico = CadastroTarefasServico();
  List<DropdownMenuItem<int>> categorias = [];

  @override
  void initState() {
    super.initState();
    carregarCategorias();
  }

  Future<void> carregarCategorias() async {
    List<DropdownMenuItem<int>> items =
        await cadastroTarefasServico.listarCategorias();

    setState(() {
      categorias = items;
    });
  }

  void salvar() async {
    Map<String, dynamic> row = {
      BancoHelper.colunaTitulo: dadosTarefa.titulo,
      BancoHelper.colunaData: dadosTarefa.data?.toString(),
      BancoHelper.colunaFinalizada: 0,
      BancoHelper.colunaIdCategoria: dadosTarefa.categoria?.id
    };
    dbHelper.inserirTarefa(row);
  }

  @override
  void dispose() {
    _controllerTitulo.dispose();
    _controllerData.dispose();
    _controllerFinalizada.dispose();
    _controllerCategoria.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2101));

    if (picked != null) {
      setState(() {
        _controllerData.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void categoriaSelecionada(int? category) async {
    Categoria categoria = await dbHelper.buscarCategoriaPeloId(category ?? 1);
    setState(() {
      dadosTarefa.categoria = categoria;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de tarefa'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _controllerTitulo,
                  decoration: const InputDecoration(
                      labelText: 'Título', border: OutlineInputBorder()),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'É obrigatório informar um título.';
                    }
                    dadosTarefa.titulo = value;
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _controllerData,
                  decoration: InputDecoration(
                      labelText: 'Selecione uma Data',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context),
                      )),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'É obrigatório informar uma data.';
                    }
                    dadosTarefa.data = DateTime.parse(value);
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 20,
                ),
                DropdownButtonFormField<int>(
                  value: dadosTarefa.categoria?.id,
                  onChanged: categoriaSelecionada,
                  items: categorias,
                  hint: const Text('Selecione uma categoria'),
                  validator: (value) {
                    if (value == null) {
                      return 'Por favor, selecione uma categoria';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              salvar();
              Navigator.pop(context);
            }
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.save),
              SizedBox(width: 8),
              Text('Salvar'),
            ],
          ),
        ),
      ),
    );
  }
}
