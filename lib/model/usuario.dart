class Usuario {
  String? nome;
  String? senha;

  Usuario({
    this.nome,
    this.senha,
  });

  Map<String, Object?> toMap() {
    return {
      'nome': nome,
      'senha': senha,
    };
  }
}
