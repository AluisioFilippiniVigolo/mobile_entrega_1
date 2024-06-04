import 'package:flutter/material.dart';
import 'package:flutter_application/model/lista.dart';
import 'package:flutter_application/servicos/trello_servico.dart';

class CadastroLista extends StatefulWidget {
  final String idQuadro;

  const CadastroLista({super.key, required this.idQuadro});

  @override
  _CadastroListaState createState() => _CadastroListaState();
}

class _CadastroListaState extends State<CadastroLista> {
  final TrelloService _trelloService = TrelloService();
  final TextEditingController _controllerNome = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void salvar() async {
    _trelloService.cadastrarLista(Lista(nome: _controllerNome.text, arquivado: false), widget.idQuadro);
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

  Future<List<Lista>> buscarListas() {
    return _trelloService.buscarListas(widget.idQuadro);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Lista'),
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
                    labelText: 'Nome da lista',
                    border: OutlineInputBorder()),
                maxLines: 2,
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
