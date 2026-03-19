import 'package:flutter/material.dart';
import 'package:livros/presenters/bd_livros.dart';
import 'package:livros/models/cadastralivros.dart';
import 'meulivro.dart';

class ListaHqsMangas extends StatefulWidget {
  const ListaHqsMangas({super.key});

  @override
  State<ListaHqsMangas> createState() => _ListaHqsMangasState();
}

class _ListaHqsMangasState extends State<ListaHqsMangas> {
  final db = BDLivro();
  List<Livros> listaFiltrada = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarLivros();
  }

  // Busca todos os livros e filtra pela categoria específica
  void _carregarLivros() async {
    List<Livros> todos = await db.getLivros();
    setState(() {
      // Filtra pela categoria "HQs/Mangás"
      listaFiltrada = todos.where((l) => l.categoria == "HQs/Mangás").toList();
      carregando = false;
    });
  }

  // Função para navegar até a tela de detalhes (meulivro.dart)
  void _irParaDetalhes(Livros livro) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MeuLivro(livro),
      ),
    );
    // Recarrega a lista caso o livro tenha sido editado ou excluído na outra tela
    _carregarLivros();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF4A148C); // Roxo
    const accentColor = Color(0xFFC2185B); // Rosa

    return Scaffold(
      appBar: AppBar(
        title: const Text("HQs e Mangás",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: carregando
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : listaFiltrada.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: listaFiltrada.length,
                  itemBuilder: (context, index) {
                    final item = listaFiltrada[index];
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(10),
                        leading: CircleAvatar(
                          backgroundColor: accentColor.withValues(alpha: 0.1),
                          child: const Icon(Icons.library_books,
                              color: accentColor),
                        ),
                        title: Text(
                          item.titulo ?? "Título não informado",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: Text("Autor: ${item.autor}"),
                        trailing: const Icon(Icons.arrow_forward_ios,
                            size: 18, color: primaryColor),
                        onTap: () => _irParaDetalhes(item), // Ação de clique
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
          Icon(Icons.collections_bookmark_outlined,
              size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text(
            "Nenhuma HQ ou Mangá encontrado.",
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
