import 'package:flutter/material.dart';
import 'package:flutter_application/servicos/quadro_servico.dart';
import '../model/Quadro.dart';
import '../telas/cartoes.dart';
import 'cadastro_quadros.dart';

class Quadros extends StatefulWidget {
  const Quadros({super.key});

  @override
  _QuadrosState createState() => _QuadrosState();
}

class _QuadrosState extends State<Quadros> {
  final QuadroServico _quadroServico = QuadroServico();
  List<Quadro>? listaQuadros = [];

  Future<List<Quadro>> buscarBoards() {
    return _quadroServico.buscarQuadros();
  }

  void deletar(String idQuadro) async {
    await _quadroServico.deletarQuadro(idQuadro);
    final quadrosAtualizados = await buscarBoards();
    setState(() {
      listaQuadros = quadrosAtualizados;
    });
  }

  @override
  void initState() {
    super.initState();
    buscarBoards().then((quadros) {
      setState(() {
        listaQuadros = quadros;
      });
    });
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
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Excluir Quadro'),
                              content: const Text('Tem certeza que deseja excluir este quadro?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    deletar(quadro!.id);
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Excluir'),
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
                  final quadrosAtualizados = await buscarBoards();
                  setState(() {
                    listaQuadros = quadrosAtualizados;
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
