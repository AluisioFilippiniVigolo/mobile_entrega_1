import 'package:flutter/material.dart';
import 'package:flutter_application/bd/banco_helper.dart';
import 'package:flutter_application/model/categoria.dart';

class CadastroCategoria extends StatefulWidget {
  const CadastroCategoria({super.key});

  @override
  _CadastroCategoriaState createState() => _CadastroCategoriaState();
}

class _CadastroCategoriaState extends State<CadastroCategoria> {
  final TextEditingController _controllerCategoria = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final Categoria dadosCategoria = Categoria();
  var dbHelper = BancoHelper();

  void salvar() async {
    Map<String, dynamic> row = {
      BancoHelper.colunaCategoria: dadosCategoria.categoria,
    };

    dbHelper.inserirCategoria(row);
  }

  @override
  void dispose() {
    _controllerCategoria.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de categoria'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _controllerCategoria,
                decoration: const InputDecoration(
                    labelText: 'Categoria', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'É obrigatório informar uma categoria.';
                  }
                  dadosCategoria.categoria = value;
                  return null;
                },
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
