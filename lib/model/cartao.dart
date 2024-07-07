import 'dart:convert';

import 'package:flutter_application/model/lista.dart';

class Cartao {
  String? id;
  final String nome;
  final String descricao;
  Lista lista;
  DateTime? ultimaModificacao;
  DateTime? dataVencimento;
  bool? completo;
  
  Cartao({
     this.id,
     required this.nome,
     required this.descricao,
     required this.lista,
     this.ultimaModificacao,
     this.dataVencimento,
     this.completo
  });
  
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'lista': lista,
      'ultimaModificacao': ultimaModificacao,
      'dataVencimento': dataVencimento,
      'completo': completo
    };
  }

  String toJson() {
    return jsonEncode({
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'lista': lista.toJson(),
      'ultimaModificacao': ultimaModificacao?.toIso8601String(),
      'dataVencimento': dataVencimento?.toIso8601String(),
      'completo': completo,
    });
  }

  factory Cartao.fromJson(Map<String, dynamic> json) {
    return Cartao(
      id: json['id'] as String?,
      nome: json['nome'] as String,
      descricao: json['descricao'] as String,
      lista: Lista.fromJson2(json['lista'] as Map<String, dynamic>),
      ultimaModificacao: json['ultimaModificacao'] != null
          ? DateTime.parse(json['ultimaModificacao'] as String)
          : null,
      dataVencimento: json['dataVencimento'] != null
          ? DateTime.parse(json['dataVencimento'] as String)
          : null,
      completo: json['completo'] as bool?,
    );
  }

  @override
  String toString() {
    return 'Tarefa { id: $id, nome: $nome, descricao: $descricao, lista: $lista.id, ultimaModificacao: $ultimaModificacao}';
  }

}