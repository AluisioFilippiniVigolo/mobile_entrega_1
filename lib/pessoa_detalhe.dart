import 'package:flutter/material.dart';
import 'package:flutter_application/model/pessoa.dart';

class PessoaDetalhe extends StatelessWidget {
  const PessoaDetalhe({super.key, required this.informacaoPessoa});

  final Pessoa informacaoPessoa;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.blue,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.purple,
              ),
              child: Text('Id: ${informacaoPessoa.id}',
                  style: const TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: 20,
                      color: Colors.amber)),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.purple,
              ),
              child: Text('Nome: ${informacaoPessoa.nome}',
                  style: const TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: 20,
                      color: Colors.amber)),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.purple,
              ),
              child: Text('Idade: ${informacaoPessoa.idade}',
                  style: const TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: 20,
                      color: Colors.amber)),
            ),
          ],
        ),
      ),
    );
  }
}
