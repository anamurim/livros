import 'package:flutter/material.dart';
import 'package:livros/presenters/bd_livros.dart';
import 'package:livros/models/cadastralivros.dart';
import 'meulivro.dart';

class ListaLiteratura extends StatefulWidget {
  const ListaLiteratura({super.key});

  @override
  State<ListaLiteratura> createState() => _ListaLiteraturaState();
}

class _ListaLiteraturaState extends State<ListaLiteratura> {
  final db = BDLivro();
  List<Livros> livrosLiteratura = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarLiteratura();
  }

  void _carregarLiteratura() async {
    // Busca todos os livros do banco
    List<Livros> todos = await db.getLivros();

    setState(() {
      // Filtra apenas os que pertencem à categoria 'Literatura'
      // O use de .toLowerCase() evita erros caso esteja escrito 'literatura' ou 'Literatura'
      livrosLiteratura = todos
          .where((l) => (l.categoria ?? "").toLowerCase() == "literatura")
          .toList();
      carregando = false;
    });
  }

  // Função para navegar para a tela de detalhes (meulivro.dart)
  void _verDetalhes(Livros livro) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MeuLivro(livro)),
    );
    // Atualiza a lista ao voltar, caso o usuário tenha editado algo
    _carregarLiteratura();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF4A148C); // Roxo Profundo

    return Scaffold(
      appBar: AppBar(
        title: const Text("Livros de Literatura",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: carregando
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : livrosLiteratura.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: livrosLiteratura.length,
                  itemBuilder: (context, index) {
                    final item = livrosLiteratura[index];
                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 8),
                        leading: CircleAvatar(
                          backgroundColor: Colors.pink[100],
                          child: const Icon(Icons.auto_stories,
                              color: Colors.pink),
                        ),
                        title: Text(
                          item.titulo ?? "Título Indisponível",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle:
                            Text("Autor: ${item.autor ?? 'Desconhecido'}"),
                        trailing: const Icon(Icons.arrow_forward_ios,
                            size: 18, color: primaryColor),
                        onTap: () =>
                            _verDetalhes(item), // Chamada da função de clique
                      ),
                    );
                  },
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.library_books_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            "Nenhum livro de literatura encontrado.",
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
        ],
      ),
    );
  }
}
