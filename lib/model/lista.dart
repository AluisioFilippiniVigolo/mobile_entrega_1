class Lista {
  String? id;
  String? nome;
  
  Lista({
     this.id,
     this.nome
  });
  
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'nome': nome,
    };
  }

  @override
  String toString() {
    return 'Lista { id: $id, nome: $nome}';
  }

  factory Lista.fromJson(Map<String, dynamic> json) {
    return Lista(
      id: json['id'],
      nome: json['name'],
    );
  }
}