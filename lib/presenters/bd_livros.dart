import 'dart:async';
import 'dart:io';
import 'dart:convert' as convert;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:livros/models/cadastralivros.dart';
import 'package:http/http.dart' as http;

class BDLivro {
  static Database?
      _bd; //(?) Indica que a variável é nula, pois o banco é nulo por demorar a carregar (é assíncrono)
  static const String table = 'livro';
  static const String dbName = 'livro.db';
  static const String id = 'id';
  static const String autor = 'autor';
  static const String titulo = 'titulo';
  static const String editora = 'editora';
  static const String idioma = 'idioma';
  static const String ano = 'ano';
  static const String opcao = 'opcao';
  static const String categoria = 'categoria';

  Future<Database> get bd async {
    if (_bd != null) {
      return _bd!; //Diz que: Eu garanto que agora essa variável não é nula
    }
    _bd = await initBd();
    return _bd!;
  }

  initBd() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, dbName);
    var bd = await openDatabase(path, version: 1, onCreate: _onCreate);
    return bd;
  }

  // Código SQL para criar o banco de dados e a tabela
  Future _onCreate(Database bd, int version) async {
    await bd.execute('''
            CREATE TABLE $table (
              $id INTEGER PRIMARY KEY AUTOINCREMENT,
              $autor TEXT NOT NULL,
              $titulo TEXT NOT NULL,
              $editora TEXT NOT NULL,
              $idioma TEXT NOT NULL,
              $ano INTEGER NOT NULL,
              $opcao TEXT NOT NULL,
              $categoria TEXT NOT NULL
          ) 
    ''');
  }

  Future<Livros> salvar(Livros livro) async {
    var bdLivro = await bd;
    livro.id = await bdLivro.insert(table, livro.toMap());
    return livro;
  }

  void obtemLivrosdaWeb() async {
    var url = "http://www.mocky.io/v2/5d69a55a330000cfc7b68ae2";
    http.Response resposta = await http.get(Uri.parse(url));
    if (resposta.statusCode == HttpStatus.ok) {
      var listalivrojson = convert.jsonDecode(resposta.body);

      for (var livrojson in listalivrojson) {
        Livros livro = Livros.fromMap(livrojson);

        Livros l = Livros(
          autor: livro.autor,
          titulo: livro.titulo,
          editora: livro.editora,
          idioma: livro.idioma,
          ano: livro.ano,
          opcao: livro.opcao,
          categoria: livro.categoria,
        );
        salvar(l);
      }
    }
  }

  Future<List<Livros>> getLivros() async {
    final bdLivro = await bd; // Sua instância do banco
    final List<Map<String, dynamic>> maps = await bdLivro.query(table);

    return List.generate(maps.length, (i) {
      return Livros.fromMap(maps[i]); // Simplificado usando seu método fromMap
    });
    /*return List.generate(maps.length, (i) {
      return Livros(
        autor: maps[i]['autor'],
        titulo: maps[i]['titulo'],
        editora: maps[i]['editora'],
        idioma: maps[i]['idioma'],
        ano: maps[i]['ano'],
        opcao: maps[i]['opcao'],
        categoria: maps[i]['categoria'],
      );
    });*/
  }

  Future<int> delete(int idLivro) async {
    var bdLivro = await bd;
    return await bdLivro.delete(table, where: '$id = ?', whereArgs: [idLivro]);
  }

  Future<int> update(Livros livro) async {
    var bdLivro = await bd;
    return await bdLivro
        .update(table, livro.toMap(), where: '$id = ?', whereArgs: [livro.id]);
  }

  Future close() async {
    var bdLivro = await bd;
    bdLivro.close();
  }

  Future getlivro(int id) async {
    var bdLivro = await bd;
    var result = await bdLivro.rawQuery("SELECT * FROM $table WHERE $id = $id");

    return result.toList();
  }
}
