import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:livros/models/cadastralivros.dart';

class BDLivro {
  static Database? _bd;
  static const String table = 'livro';

  Future<Database> get bd async {
    if (_bd != null) return _bd!;
    _bd = await initBd();
    return _bd!;
  }

  initBd() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "livro.db");
    return await openDatabase(
      path,
      version: 2, // Aumentou a versão
      onCreate: _onCreate,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute("ALTER TABLE livro ADD COLUMN sinopse TEXT;");
          await db.execute("ALTER TABLE livro ADD COLUMN avaliacao REAL;");
          await db.execute("ALTER TABLE livro ADD COLUMN capa TEXT;");
        }
      },
    );
  }

  Future _onCreate(Database bd, int version) async {
    await bd.execute('''
          CREATE TABLE $table (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            autor TEXT NOT NULL,
            titulo TEXT NOT NULL,
            editora TEXT NOT NULL,
            idioma TEXT NOT NULL,
            ano INTEGER NOT NULL,
            opcao TEXT NOT NULL,
            categoria TEXT NOT NULL,
            sinopse TEXT,
            avaliacao REAL,
            capa TEXT
          )
    ''');
  }

  Future<int> salvar(Livros livro) async {
    var bdLivro = await bd;
    return await bdLivro.insert(table, livro.toMap());
  }

  Future<List<Livros>> getLivros() async {
    var bdLivro = await bd;
    List<Map<String, dynamic>> maps = await bdLivro.query(table);
    return List.generate(maps.length, (i) => Livros.fromMap(maps[i]));
  }

  Future<int> update(Livros livro) async {
    var bdLivro = await bd;
    return await bdLivro
        .update(table, livro.toMap(), where: 'id = ?', whereArgs: [livro.id]);
  }

  Future<int> delete(int id) async {
    var bdLivro = await bd;
    return await bdLivro.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
