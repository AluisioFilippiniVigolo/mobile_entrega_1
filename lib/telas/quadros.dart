import 'package:flutter/material.dart';
import '../model/Quadro.dart';
import '../servicos/trello_servico.dart';
import '../telas/cartoes.dart';
import 'cadastro_quadros.dart';

class Quadros extends StatefulWidget {
  const Quadros({super.key});

  @override
  _QuadrosState createState() => _QuadrosState();
}

class _QuadrosState extends State<Quadros> {

  final TrelloService _trelloService = TrelloService();

  List<Quadro>? listaQuadros = [];

  Future<List<Quadro>> buscarBoards() {
    return _trelloService.buscarQuadros();
  }

  void deletar(String idQuadro) async {
    await _trelloService.deletarQuadro(idQuadro);
    setState(() {
      buscarBoards();
    });

  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quadros'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: FutureBuilder<List<Quadro>>(
          future: buscarBoards(),
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
              listaQuadros = snapshot.data;

              return ListView.builder(
                itemCount: listaQuadros?.length ?? 0,
                itemBuilder: (context, index) {
                  final quadro = listaQuadros?[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(quadro?.nome ?? ''),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red, // Define a cor do ícone como vermelho
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Excluir Quadro'),
                              content: Text('Tem certeza que deseja excluir este quadro?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    deletar(quadro!.id);
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Excluir'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Cartoes(idQuadro: quadro!.id),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CadastroQuadro(),
                  ),
              ).then((_) async {
                listaQuadros = await buscarBoards();
                setState(() {
                  });
                });
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add),
                  SizedBox(width: 8),
                  Text('Quadro'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
