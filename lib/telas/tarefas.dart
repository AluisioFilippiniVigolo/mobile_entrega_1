
import 'package:flutter/material.dart';
import 'package:flutter_application/Formulario.dart';
import 'dart:math';
import 'package:flutter_application/bd/banco_helper.dart';
import 'package:flutter_application/model/pessoa.dart';
import 'package:flutter_application/pessoa_detalhe.dart';

class Tarefas extends StatefulWidget {
  const Tarefas({super.key});

  @override
  State<Tarefas> createState() => _TarefasState();
}

class _TarefasState extends State<Tarefas> {
  var bdHelper = BancoHelper();
  final List<Pessoa> _dados = [];

  void carregarPessoasSalvas() async {
    var r = await bdHelper.buscarPessoas();

    setState(() {
      _dados.clear();
      _dados.addAll(r);
    });
  }

  Future<void> inserirRegistro() async {
    var rnd = Random();

    final nomePessoa = 'Pessoa ${rnd.nextInt(999999)}';
    final idadePessoa = rnd.nextInt(99);

    Map<String, dynamic> row = {
      BancoHelper.colunaNome: nomePessoa,
      BancoHelper.colunaIdade: idadePessoa
    };

    final id = await bdHelper.inserir(row);

    print(
        'Pessoa inserida com ID $id para $nomePessoa com idade de $idadePessoa');

    carregarPessoasSalvas();
  }

  void removerTudo() async {
    await bdHelper.deletarTodos();
    carregarPessoasSalvas();
  }

  void editar() async {
    if (_dados.isNotEmpty) {
      var rnd = Random();

      var indexEdicao = rnd.nextInt(_dados.length);

      _dados[indexEdicao].nome = 'Novo nome em ${DateTime.now()}';
      _dados[indexEdicao].idade = 19;

      await bdHelper.editar(_dados[indexEdicao]);
      carregarPessoasSalvas();
    }
  }

  @override
  void initState() {
    super.initState();
    carregarPessoasSalvas();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Pessoas'),
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _dados.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_dados[index].nome ?? 'Nome não informado'),
                        //Função do click/Toque
                        onTap: () {
                          var param = _dados[index];

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PessoaDetalhe(informacaoPessoa: param)));
                        },
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          removerTudo();
                        },
                        child: const Text('Deletar Tudo')),
                    ElevatedButton(
                        onPressed: () {
                          editar();
                        },
                        child: const Text('Editar Registro')),
                  ],
                ),
              ],
            ),
          ),
        ),
        /*Utilizado o Builder para facilitar depois a navegação entre telas */
        floatingActionButton: Builder(
          builder: (BuildContext context) {
            return FloatingActionButton(
              child: const Icon(Icons.person_add),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Formulario(),
                  ),
                );
                carregarPessoasSalvas();
              },
            );
          },
        ),
      ),
    );
  }
}