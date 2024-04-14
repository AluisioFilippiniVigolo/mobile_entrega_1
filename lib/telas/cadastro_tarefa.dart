/*import 'package:flutter/material.dart';
import 'package:flutter_application/bd/banco_helper.dart';
import 'package:flutter_application/model/categoria.dart';
import 'package:flutter_application/model/pessoa.dart';
import 'package:flutter_application/model/tarefa.dart';

class Formulario extends StatefulWidget {
  const Formulario({super.key});

  @override
  _FormularioState createState() => _FormularioState();
}

class _FormularioState extends State<Formulario> {
  final TextEditingController _controllerTitulo = TextEditingController();
  final TextEditingController _controllerData = TextEditingController();
  final TextEditingController _controllerFinalizada = TextEditingController();
  final TextEditingController _controllerCategoria = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final Tarefa dadosTarefa = Tarefa();
  final Categoria dadosCategoria = Categoria();
  var dbHelper = BancoHelper();

  void salvar() async {
    Map<String, dynamic> row = {
      BancoHelper.colunaTitulo: dadosTarefa.titulo,
      BancoHelper.colunaData: dadosTarefa.data,
      BancoHelper.colunaFinalizada: dadosTarefa.finalizada,
      BancoHelper.colunaCategoria: dadosTarefa.categoria
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

        if(picked != null) {
          setState(() {
            _controllerData.text = '${picked.day}/${picked.month}/${picked.year}';
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
                decoration: const InputDecoration(
                    labelText: 'Selecione uma Data',
                    suffixIcon: IconButton(
                      onPressed: () => _selectDate(context),
                      icon: Icon(Icons.calendar_today))  
                    ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'É obrigatório informar uma data.';
                  }
                  dados.idade = int.parse(value);
                  return null;
                },
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Salvar();
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
*/