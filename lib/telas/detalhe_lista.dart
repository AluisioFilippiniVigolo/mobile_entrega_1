import 'package:flutter/material.dart';
import '../model/lista.dart';
import '../servicos/trello_servico.dart';
import '../telas/cadastro_cartao.dart';

class DetalheLista extends StatefulWidget {
  final Lista lista;
  final String idQuadro;

  const DetalheLista({super.key, required this.lista, required this.idQuadro});

  @override
  _DetalheListaState createState() => _DetalheListaState();
}

class _DetalheListaState extends State<DetalheLista> {
  final TrelloService _trelloService = TrelloService();
  final TextEditingController _controllerNome = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void salvar() async {
    _trelloService.atualizarLista(Lista(
        id: widget.lista.id,
        nome: _controllerNome.text,
        arquivado: widget.lista.arquivado));
  }

  void arquivarLista() async {
    _trelloService.arquivarLista(Lista(
        id: widget.lista.id,
        nome: _controllerNome.text,
        arquivado: widget.lista.arquivado));
  }

  Future<bool?> mostrarDialogoDeConfirmacao(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Arquivar lista?'),
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
    _controllerNome.text = widget.lista.nome;
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
        title: const Text('Editar Lista'),
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
                    labelText: 'Nome da lista', border: OutlineInputBorder()),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'É obrigatório informar um nome.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CadastroCartao(
                              idQuadro: widget.idQuadro,
                              idLista: widget.lista.id ?? 'id_lista'),
                        ),
                      ).then((_) async {
                        setState(() {});
                      });
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add),
                        SizedBox(width: 8),
                        Text('Adicionar um cartão'),
                      ],
                    ),
                  )
                ],
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
                arquivarLista();
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
                Icon(Icons.archive),
                SizedBox(width: 8),
                Text('Arquivar'),
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
