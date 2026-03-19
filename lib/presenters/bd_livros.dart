import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:livros/models/cadastralivros.dart';

class BDLivro {
  // Padrão Singleton
  static final BDLivro _instance = BDLivro._internal();
  factory BDLivro() => _instance;
  BDLivro._internal();

  static Database? _bd;
  static const String table = 'livro';

  Future<Database> get bd async {
    if (_bd != null) return _bd!;
    _bd = await initBd();
    return _bd!;
  }

  Future<Database> initBd() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "livro.db");
    return await openDatabase(
      path,
      version: 5,
      onCreate: _onCreate,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute("ALTER TABLE livro ADD COLUMN sinopse TEXT;");
          await db.execute("ALTER TABLE livro ADD COLUMN avaliacao REAL;");
          await db.execute("ALTER TABLE livro ADD COLUMN capa TEXT;");
        }
        if (oldVersion < 5) {
          try {
            // Tentamos adicionar as colunas caso elas não existam
            await db.execute(
                "ALTER TABLE livro ADD COLUMN status TEXT DEFAULT 'Comprar';");
            await db
                .execute("ALTER TABLE livro ADD COLUMN emprestadoPara TEXT;");
            await db.execute("ALTER TABLE $table ADD COLUMN status TEXT;");
            await db
                .execute("ALTER TABLE $table ADD COLUMN emprestadoPara TEXT;");
          } catch (e) {
            print("Colunas já existem ou erro na migração: $e");
          }
        }
      },
    );
  }

  Future _onCreate(Database bd, int version) async {
    await bd.execute('''
          CREATE TABLE $table (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            capa TEXT,
            titulo TEXT NOT NULL,
            autor TEXT NOT NULL,
            editora TEXT NOT NULL,
            ano INTEGER NOT NULL,
            idioma TEXT NOT NULL,
            categoria TEXT NOT NULL,
            status TEXT,           
            avaliacao REAL,
            sinopse TEXT,
            emprestadoPara TEXT
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
    return maps.map((e) => Livros.fromMap(e)).toList();
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
