class Categoria {
  int? id;
  String? categoria;
  
  Categoria({
     this.id,
     this.categoria,
  });
  
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'categoria': categoria,
    };
  }

  @override
  String toString() {
    return 'Categoria { categoria: $categoria}';
  }

  static Categoria fromMap(Map<String, Object?> categoriaMap) {
    return Categoria(
      id: categoriaMap['id'] as int,
      categoria: categoriaMap['categoria'] as String,
    );
  }
}