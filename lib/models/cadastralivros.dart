class Livros {
  int? id;
  String? autor;
  String? titulo;
  String? editora;
  String? idioma;
  int? ano;
  String? opcao;
  String? categoria;

  Livros(
      {required this.autor,
      required this.titulo,
      required this.editora,
      required this.idioma,
      required this.ano,
      required this.opcao,
      required this.categoria});

  Map<String, dynamic> toMap() {
    var mapa = <String, dynamic>{
      'id': id,
      'autor': autor,
      'titulo': titulo,
      'editora': editora,
      'idioma': idioma,
      'ano': ano,
      'opcao': opcao,
      'categoria': categoria
    };
    return mapa;
  }

  Livros.fromMap(Map<String, dynamic> mapa) {
    id = mapa['id'];
    autor = mapa['autor'];
    titulo = mapa['titulo'];
    editora = mapa['editora'];
    idioma = mapa['idioma'];
    ano = mapa['ano'];
    opcao = mapa['opcao'];
    categoria = mapa['categoria'];
  }
}
