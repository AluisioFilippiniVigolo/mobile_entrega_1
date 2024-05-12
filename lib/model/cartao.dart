import 'package:flutter_application/model/lista.dart';

class Cartao {
  String? id;
  String? nome;
  String? descricao;
  Lista? lista;
  
  Cartao({
     this.id,
     this.nome,
     this.descricao,
     this.lista
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

  factory Cartao.fromJson(Map<String, dynamic> json) {
    return Cartao(
      id: json['id'],
      nome: json['name'],
      descricao: json['desc'],
      //lista: json['idList'],
    );
  }

}