import 'package:flutter/material.dart';
import 'package:flutter_application/model/cartao.dart';
import 'package:flutter_application/model/lista.dart';
import 'package:flutter_application/servicos/trello_servico.dart';

import '../model/Quadro.dart';

class CadastroQuadro extends StatefulWidget {

  const CadastroQuadro({super.key});

  @override
  _CadastroQuadroState createState() => _CadastroQuadroState();
}

class _CadastroQuadroState extends State<CadastroQuadro> {
  final TrelloService _trelloService = TrelloService();
  final TextEditingController _controllerNome = TextEditingController();
  final TextEditingController _controllerDescricao = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void salvar() async {
    _trelloService.cadastrarQuadro(_controllerNome.text);
  }

  @override
  void initState() {
    super.initState();
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
        title: const Text('Cadastro de Quadro'),
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
                    labelText: 'Nome do quadro',
                    border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'É obrigatório informar um nome.';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
            ],
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
          )),
    );
  }
}
