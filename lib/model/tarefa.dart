import 'package:flutter_application/model/categoria.dart';

class Tarefa {
  int? id;
  String? titulo;
  DateTime? data;
  bool? finalizada;
  Categoria? categoria;
  
  Tarefa({
     this.id,
     this.titulo,
     this.data,
     this.finalizada,
     this.categoria
  });
  
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'data': data,
      'finalizada': finalizada,
      'categoria': categoria,
    };
  }

  @override
  String toString() {
    return 'Tarefa { titulo: $titulo, data: $data, finalizada: $finalizada, categoria: $categoria.id}';
  }
}