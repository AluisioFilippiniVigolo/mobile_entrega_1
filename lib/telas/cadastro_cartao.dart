import 'package:flutter/material.dart';
import 'package:flutter_application/model/cartao.dart';
import 'package:flutter_application/model/lista.dart';
import 'package:flutter_application/servicos/lista_servico.dart';
import 'package:flutter_application/servicos/cartao_servico.dart';

class CadastroCartao extends StatefulWidget {
  final String idQuadro;
  final String idLista;

  const CadastroCartao({super.key, required this.idQuadro, this.idLista = ""});

  @override
  _CadastroCartaoState createState() => _CadastroCartaoState();
}

class _CadastroCartaoState extends State<CadastroCartao> {
  final CartaoService _cartaoService = CartaoService();
  final TextEditingController _controllerNome = TextEditingController();
  final TextEditingController _controllerDescricao = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ListaServico _listaServico = ListaServico();

  void salvar() async {
    Lista lista = Lista(nome: 'nome_lista', arquivado: false);
    lista.id = widget.idLista;

    _cartaoService.cadastrarCartao(Cartao(
        nome: _controllerNome.text,
        descricao: _controllerDescricao.text,
        lista: lista));
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
    return _listaServico.buscarListas(widget.idQuadro);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Cartão'),
      ),
      body: SingleChildScrollView(
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
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _controllerDescricao,
                decoration: const InputDecoration(
                    labelText: 'Descrição',
                    border: OutlineInputBorder()),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'É obrigatório informar uma descrição.';
                  }
                  return null;
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
