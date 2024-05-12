import 'package:flutter/material.dart';
import 'package:flutter_application/model/cartao.dart';
import 'package:flutter_application/model/lista.dart';
import 'package:flutter_application/servicos/trello_servico.dart';

class CadastroCartao extends StatefulWidget {
  const CadastroCartao({super.key});

  @override
  _CadastroCartaoState createState() => _CadastroCartaoState();
}

class _CadastroCartaoState extends State<CadastroCartao> {
  final Cartao _dadosCartao = Cartao();
  final TrelloService _trelloService = TrelloService();
  final TextEditingController _controllerNome = TextEditingController();
  final TextEditingController _controllerDescricao = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List<DropdownMenuItem<int>> listas = [];

  void salvar() async {
    _trelloService.cadastrarCartao(_dadosCartao);
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
    return _trelloService.buscarListas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Cartão'),
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
                    labelText: 'Nome da cartão', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'É obrigatório informar um nome.';
                  }
                  _dadosCartao.nome = value;
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _controllerDescricao,
                decoration: const InputDecoration(
                    labelText: 'Descrição', border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'É obrigatório informar uma descrição.';
                  }
                  _dadosCartao.descricao = value;
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              FutureBuilder<List<Lista>>(
                future: buscarListas(),
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
                    final listaListas = snapshot.data;
                    return DropdownButton<Lista>(
                      value: _dadosCartao.lista,
                      items: List.generate(
                        listaListas!.length,
                        (index) => DropdownMenuItem<Lista>(
                          value: listaListas[index],
                          child: Text(listaListas[index].nome ?? ''),
                        ),
                      ),
                      onChanged: (Lista? value) {
                        _dadosCartao.lista = value;
                      },
                      hint: const Text('Selecione uma lista'),
                    );
                  }
                },
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
