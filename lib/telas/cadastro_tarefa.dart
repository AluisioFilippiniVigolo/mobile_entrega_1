import 'package:flutter/material.dart';
import 'package:flutter_application/bd/banco_helper.dart';
import 'package:flutter_application/model/categoria.dart';
import 'package:flutter_application/model/tarefa.dart';
import 'package:intl/intl.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CadastroTarefa(), // Use CadastroTarefa as the home widget
    );
  }
}

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
  bool _checkboxValue = false;
  final List<Map<String, dynamic>> _itens = [];

  @override
  void initState() {
    super.initState();
    _loadItens();
  }

  void salvar() async {
    Map<String, dynamic> row = {
      BancoHelper.colunaTitulo: dadosTarefa.titulo,
      BancoHelper.colunaData: dadosTarefa.data?.millisecondsSinceEpoch,
      BancoHelper.colunaFinalizada: (dadosTarefa.finalizada ?? false) ? 1 : 0,
      BancoHelper.colunaCategoria: dadosTarefa.categoria?.id
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

  Future<void> _loadItens() async {
    List<Categoria> categorias = await dbHelper.buscarCategorias();
    _itens.clear();
    for (Categoria categoria in categorias) {
      Map<String, dynamic> categoriaMap = categoria.toMap();
      setState(() {
        _itens.add(categoriaMap);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de tarefa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _controllerTitulo,
                decoration: const InputDecoration(
                    labelText: 'Titulo', border: OutlineInputBorder()),
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
              CheckboxListTile(
                  title: const Text('Finalizada?'),
                  value: _checkboxValue,
                  onChanged: (bool? value) {
                    setState(() {
                      _checkboxValue = value ?? false;
                      dadosTarefa.finalizada = _checkboxValue;
                    });
                  }),
              const SizedBox(
                height: 20,
              ),
              DropdownButton<String>(
                value: dadosCategoria.categoria,
                onChanged: (String? newValue) {
                  setState(() {
                    dadosCategoria.categoria = newValue;
                  });
                },
                items: _itens
                    .map<DropdownMenuItem<String>>((Map<String, dynamic> item) {
                  return DropdownMenuItem<String>(
                    value: item['categoria'],
                    child: Text(item['categoria']),
                  );
                }).toList(),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    salvar();
                    Navigator.pop(context);
                  }
                },
                child: const Text('Salvar'),
              )
            ],
          ),
        ),
      ),
    );
  }
}