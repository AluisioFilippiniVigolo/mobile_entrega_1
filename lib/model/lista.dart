class Lista {
  String? id;
  String nome;
  bool arquivado = false;
  
  Lista({
     this.id,
     required this.nome,
     required this.arquivado
  });
  
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'nome': nome,
      'closed': arquivado
    };
  }

  @override
  String toString() {
    return 'Lista { id: $id, nome: $nome, closed: $arquivado}';
  }

  factory Lista.fromJson(Map<String, dynamic> json) {
    return Lista(
      id: json['id'],
      nome: json['name'],
      arquivado: json['closed']
    );
  }

  factory Lista.fromJson2(Map<String, dynamic> json) {
    return Lista(
        id: json['id'],
        nome: json['nome'],
        arquivado: json['closed'] ?? false
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
    };
  }
}