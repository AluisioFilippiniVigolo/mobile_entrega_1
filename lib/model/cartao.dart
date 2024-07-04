import 'package:flutter_application/model/lista.dart';

class Cartao {
  String? id;
  final String nome;
  final String descricao;
  Lista lista;
  DateTime? ultimaModificacao;
  
  Cartao({
     this.id,
     required this.nome,
     required this.descricao,
     required this.lista,
     this.ultimaModificacao
  });
  
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'lista': lista,
      'ultimaModificacao': ultimaModificacao
    };
  }

  @override
  String toString() {
    return 'Tarefa { id: $id, nome: $nome, descricao: $descricao, lista: $lista.id, ultimaModificacao: $ultimaModificacao}';
  }

}