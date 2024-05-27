import 'package:flutter_application/model/lista.dart';

class Cartao {
  String? id;
  final String nome;
  final String descricao;
  Lista lista;
  
  Cartao({
     this.id,
     required this.nome,
     required this.descricao,
     required this.lista
  });
  
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'lista': lista
    };
  }

  @override
  String toString() {
    return 'Tarefa { id: $id, nome: $nome, descricao: $descricao, lista: $lista.id}';
  }

}