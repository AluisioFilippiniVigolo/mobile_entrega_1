import 'package:flutter/material.dart';
import 'package:flutter_application/bd/banco_helper.dart';
import 'package:flutter_application/model/pessoa.dart';

class Formulario extends StatefulWidget {
  const Formulario({super.key});

  @override
  _formularioState createState() => _formularioState();
}

class _formularioState extends State<Formulario>{
  final TextEditingController _controllerNome = TextEditingController();
  final TextEditingController _controllerIdade = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final Pessoa dados = new Pessoa();
  var dbHelper = BancoHelper();

  void Salvar() async {
    Map<String, dynamic> row = {
      BancoHelper.colunaNome: dados.nome,
      BancoHelper.colunaIdade: dados.idade
    };

    dbHelper.inserir(row);
  }

  @override
  void dispose() {
    _controllerNome.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de pessoa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _controllerNome,
                decoration: const InputDecoration(
                    labelText: 'Nome',
                    border: OutlineInputBorder() //Gera a borda toda no campo.
                    ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor preencha um valor para o campo nome.';
                  }
                  dados.nome = value;
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _controllerIdade,
                decoration: const InputDecoration(
                    labelText: 'Idade',
                    border: OutlineInputBorder() //Gera a borda toda no campo.
                    ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'É obrigatório informar a idade.';
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