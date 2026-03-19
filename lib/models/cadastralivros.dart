class Livros {
  int? id;
  String? capa;
  String? titulo;
  String? autor;
  String? editora;
  int? ano;
  String? idioma;
  String? categoria;
  String? status;
  double? avaliacao;
  String? emprestadoPara;
  String? sinopse;

  Livros({
    this.id,
    this.capa,
    required this.titulo,
    required this.autor,
    required this.editora,
    required this.ano,
    required this.idioma,
    required this.categoria,
    required this.status,
    required this.avaliacao,
    this.emprestadoPara,
    required this.sinopse,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'capa': capa,
      'titulo': titulo,
      'autor': autor,
      'editora': editora,
      'ano': ano,
      'idioma': idioma,
      'categoria': categoria,
      'status': status,
      'avaliacao': avaliacao,
      'emprestadoPara': emprestadoPara,
      'sinopse': sinopse,
    };
  }

  Livros.fromMap(Map<String, dynamic> mapa) {
    id = mapa['id'];
    capa = mapa['capa'];
    titulo = mapa['titulo'];
    autor = mapa['autor'];
    editora = mapa['editora'];
    ano = mapa['ano'];
    idioma = mapa['idioma'];
    categoria = mapa['categoria'];
    status = mapa['status'];
    avaliacao = (mapa['avaliacao'] as num?)?.toDouble();
    emprestadoPara = mapa['emprestadoPara'];
    sinopse = mapa['sinopse'];
  }
}
