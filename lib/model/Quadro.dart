class Quadro {
  final String id;
  final String nome;

  Quadro({required this.id, required this.nome});

  factory Quadro.fromJson(Map<String, dynamic> json) {
    return Quadro(
      id: json['id'],
      nome: json['name'],
    );
  }
}
