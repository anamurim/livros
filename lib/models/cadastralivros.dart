class Livros {
  int? id;
  String? autor;
  String? titulo;
  String? editora;
  String? idioma;
  int? ano;
  String? sinopse;
  double? avaliacao;
  String? opcao;
  String? categoria;
  String? capa;

  Livros({
    this.id,
    required this.autor,
    required this.titulo,
    required this.editora,
    required this.idioma,
    required this.ano,
    required this.sinopse,
    required this.avaliacao,
    required this.opcao,
    required this.categoria,
    this.capa,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'autor': autor,
      'titulo': titulo,
      'editora': editora,
      'idioma': idioma,
      'ano': ano,
      'sinopse': sinopse,
      'avaliacao': avaliacao,
      'opcao': opcao,
      'categoria': categoria,
      'capa': capa,
    };
  }

  Livros.fromMap(Map<String, dynamic> mapa) {
    id = mapa['id'];
    autor = mapa['autor'];
    titulo = mapa['titulo'];
    editora = mapa['editora'];
    idioma = mapa['idioma'];
    ano = mapa['ano'];
    sinopse = mapa['sinopse'];
    avaliacao = (mapa['avaliacao'] as num?)?.toDouble();
    opcao = mapa['opcao'];
    categoria = mapa['categoria'];
    capa = mapa['capa'];
  }
}
