import 'package:flutter/material.dart';
import 'package:livros/presenters/bd_livros.dart';
import 'package:livros/models/cadastralivros.dart';
import 'meulivro.dart';

class ListaOutros extends StatefulWidget {
  const ListaOutros({super.key});

  @override
  State<ListaOutros> createState() => _ListaOutrosState();
}

class _ListaOutrosState extends State<ListaOutros> {
  final db = BDLivro();
  List<Livros> listaOutros = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  // Função para carregar e filtrar os livros da categoria "Outros"
  void _carregarDados() async {
    List<Livros> todos = await db.getLivros();
    setState(() {
      // Filtra exatamente pela string "Outros"
      listaOutros = todos.where((l) => l.categoria == "Outros").toList();
      carregando = false;
    });
  }

  // Função de clique para abrir os detalhes do livro
  void _abrirMeulivro(Livros livro) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MeuLivro(livro)),
    );
    // Atualiza a lista caso o livro tenha sido editado ou excluído
    _carregarDados();
  }

  @override
  Widget build(BuildContext context) {
    // Cores padrão do seu projeto
    const primaryColor = Color(0xFF4A148C); // Roxo
    const accentColor = Color(0xFFC2185B); // Rosa

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Outras Categorias",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: carregando
          ? const Center(child: CircularProgressIndicator(color: primaryColor))
          : listaOutros.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: listaOutros.length,
                  itemBuilder: (context, index) {
                    final item = listaOutros[index];
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        leading: CircleAvatar(
                          backgroundColor: accentColor.withValues(alpha: 0.1),
                          child:
                              const Icon(Icons.more_horiz, color: accentColor),
                        ),
                        title: Text(
                          item.titulo ?? "Sem título",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle:
                            Text("Autor: ${item.autor ?? 'Não informado'}"),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                          color: primaryColor,
                        ),
                        onTap: () =>
                            _abrirMeulivro(item), // Ação de clique solicitada
                      ),
                    );
                  },
                ),
    );
  }

  // Widget para quando a lista estiver vazia
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.category_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            "Nenhum livro encontrado em 'Outros'.",
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
        ],
      ),
    );
  }
}
