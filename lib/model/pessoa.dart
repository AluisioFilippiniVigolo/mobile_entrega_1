
class Pessoa {
  int? id;
  String? nome;
  int? idade;
  
  Pessoa({
     this.id,
     this.nome,
     this.idade,
  });
  
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'nome': nome,
      'idade': idade,
    };
  }

  @override
  String toString() {
    return 'Pessoa { nome: $nome, idade: $idade}';
  }
}