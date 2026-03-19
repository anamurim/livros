import 'package:flutter/material.dart';
import 'package:livros/presenters/bd_livros.dart';
import 'package:livros/models/cadastralivros.dart';
import 'meulivro.dart';

class ListaAutoAjuda extends StatefulWidget {
  const ListaAutoAjuda({super.key});

  @override
  State<ListaAutoAjuda> createState() => _ListaAutoAjudaState();
}

class _ListaAutoAjudaState extends State<ListaAutoAjuda> {
  final db = BDLivro();
  List<Livros> listaFiltrada = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarLivros();
  }

  // Função que busca do banco e filtra pela categoria exata
  void _carregarLivros() async {
    List<Livros> todos = await db.getLivros();
    setState(() {
      // Filtra pela categoria "Autoajuda"
      // Certifique-se de que o nome está igual ao que você salva no cadastro
      listaFiltrada = todos.where((l) => l.categoria == "Autoajuda").toList();
      carregando = false;
    });
  }

  // Função que navega para os detalhes do livro
  void _navegarParaDetalhes(Livros livro) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MeuLivro(livro),
      ),
    );
    // Recarrega a lista caso o usuário tenha editado algo na tela de detalhes
    _carregarLivros();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF4A148C); // Roxo Profundo
    const accentColor = Color(0xFFC2185B); // Rosa Vibrante

    return Scaffold(
      appBar: AppBar(
        title: const Text("Livros de Autoajuda",
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
                      elevation: 3,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        leading: CircleAvatar(
                          backgroundColor: accentColor.withValues(alpha: 0.1),
                          child:
                              const Icon(Icons.psychology, color: accentColor),
                        ),
                        title: Text(
                          item.titulo ?? "Sem título",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: Text("Autor: ${item.autor}"),
                        trailing: const Icon(Icons.arrow_forward_ios,
                            size: 18, color: primaryColor),
                        onTap: () =>
                            _navegarParaDetalhes(item), // Função de clique
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
          Icon(Icons.spa_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text(
            "Nenhum livro de autoajuda encontrado.",
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
