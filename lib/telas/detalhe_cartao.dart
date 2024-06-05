import 'package:flutter/material.dart';
import '../model/cartao.dart';
import '../servicos/cartao_servico.dart';

class DetalheCartao extends StatefulWidget {
  final Cartao cartao;

  const DetalheCartao({super.key, required this.cartao});

  @override
  _DetalheCartaoState createState() => _DetalheCartaoState();
}

class _DetalheCartaoState extends State<DetalheCartao> {
  final CartaoService _cartaoService = CartaoService();
  final TextEditingController _controllerNome = TextEditingController();
  final TextEditingController _controllerDescricao = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void salvar() async {
    _cartaoService.atualizarCartao(Cartao(
        id: widget.cartao.id,
        nome: _controllerNome.text,
        descricao: _controllerDescricao.text,
        lista: widget.cartao.lista));
  }

  void excluir() async {
    _cartaoService.excluirCartao(Cartao(
        id: widget.cartao.id,
        nome: _controllerNome.text,
        descricao: _controllerDescricao.text,
        lista: widget.cartao.lista));
  }

  Future<bool?> mostrarDialogoDeConfirmacao(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Excluir Cartão?'),
          content: const Text('Não é possível desfazer esta ação.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Não'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Sim'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _controllerNome.text = widget.cartao.nome;
    _controllerDescricao.text = widget.cartao.descricao;
  }

  @override
  void dispose() {
    _controllerNome.dispose();
    _controllerDescricao.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhe do Cartão'),
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
                    labelText: 'Descrição', border: OutlineInputBorder()),
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
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () async {
              bool? confirmacao = await mostrarDialogoDeConfirmacao(context);
              if (confirmacao == true) {
                excluir();
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.delete),
                SizedBox(width: 8),
                Text('Excluir'),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                salvar();
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.save),
                SizedBox(width: 8),
                Text('Salvar'),
              ],
            ),
          )
        ],
      )),
    );
  }
}
