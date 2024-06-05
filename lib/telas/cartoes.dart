import 'package:flutter/material.dart';
import '../model/cartao.dart';
import '../model/lista.dart';
import '../servicos/lista_servico.dart';
import '../telas/detalhe_cartao.dart';
import '../telas/detalhe_lista.dart';
import '../telas/cadastro_lista.dart';
import '../servicos/cartao_servico.dart';

class Cartoes extends StatefulWidget {
  final String idQuadro;

  const Cartoes({super.key, required this.idQuadro});

  @override
  _CartoesState createState() => _CartoesState();
}

class _CartoesState extends State<Cartoes> {
  final CartaoService _cartaoService = CartaoService();
  final ListaServico _listaServico = ListaServico();

  Future<List<Lista>> buscarListas() {
    return _listaServico.buscarListas(widget.idQuadro);
  }

  Future<List<Cartao>> buscarCartao(List<Lista> listas) {
    return _cartaoService.buscarCartoes(widget.idQuadro, listas);
  }

  Future<Map<Lista, List<Cartao>>> buscarListasComCartoes() async {
    List<Lista> listas = await buscarListas();
    Map<Lista, List<Cartao>> cartoesAgrupadosPorLista = {};
    for (var lista in listas) {
      cartoesAgrupadosPorLista[lista] = [];
    }
    List<Cartao> cartoes = await buscarCartao(listas);
    for (var cartao in cartoes) {
      Lista? lista = cartao.lista;
      if (cartoesAgrupadosPorLista.containsKey(lista)) {
        cartoesAgrupadosPorLista[lista]!.add(cartao);
      } else {
        cartoesAgrupadosPorLista[lista] = [cartao];
      }
    }
    return cartoesAgrupadosPorLista;
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
          title: const Text('Cartões'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: FutureBuilder<Map<Lista, List<Cartao>>>(
            future: buscarListasComCartoes(),
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
                final cartoesAgrupadosPorLista = snapshot.data;

                return ListView.builder(
                  itemCount: cartoesAgrupadosPorLista?.length,
                  itemBuilder: (context, index) {
                    Lista lista =
                        cartoesAgrupadosPorLista!.keys.elementAt(index);
                    List<Cartao> cartoesDaLista =
                        cartoesAgrupadosPorLista[lista]!;

                    return ExpansionTile(
                      title: Row(
                        children: [
                          Flexible(
                            fit: FlexFit.tight,
                            child: Text(
                              lista.nome,
                              softWrap: true,
                              maxLines: null,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetalheLista(lista: lista, idQuadro: widget.idQuadro),
                                ),
                              );
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                      children: cartoesDaLista.map((cartao) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          color: const Color.fromRGBO(70, 52, 235, 1),
                          child: ListTile(
                            title: Text(cartao.nome,
                                style: const TextStyle(color: Colors.white)),
                            subtitle: Text(cartao.descricao,
                                style: const TextStyle(color: Colors.white70)),
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetalheCartao(cartao: cartao),
                                ),
                              );
                              setState(() {});
                            },
                          ),
                        );
                      }).toList(),
                    );
                  },
                );
              }
            },
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CadastroLista(idQuadro: widget.idQuadro),
                  ),
                );
                setState(() {});
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add),
                  SizedBox(width: 8),
                  Text('Lista'),
                ],
              ),
            )
          ]),
        ));
  }
}
