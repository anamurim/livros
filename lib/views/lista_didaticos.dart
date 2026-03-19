import 'package:flutter/material.dart';
import 'package:livros/presenters/bd_livros.dart';
import 'package:livros/models/cadastralivros.dart';
import 'meulivro.dart';

class ListaDidaticos extends StatefulWidget {
  const ListaDidaticos({super.key});

  @override
  State<ListaDidaticos> createState() => _ListaDidaticosState();
}

class _ListaDidaticosState extends State<ListaDidaticos> {
  final db = BDLivro();
  List<Livros> livrosDidaticos = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarDidaticos();
  }

  // Função que busca e filtra os livros
  void _carregarDidaticos() async {
    List<Livros> todos = await db.getLivros();
    setState(() {
      // Filtra apenas pela categoria "Livro Didático"
      livrosDidaticos =
          todos.where((l) => l.categoria == "Livro Didático").toList();
      carregando = false;
    });
  }

  // Função de navegação solicitada
  void _abrirDetalhes(Livros livro) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MeuLivro(livro),
      ),
    );
    // Atualiza a lista ao voltar, caso algo tenha sido editado
    _carregarDidaticos();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF4A148C); // Roxo das telas anteriores
    const accentColor = Color(0xFFC2185B); // Rosa/Vinho

    return Scaffold(
      appBar: AppBar(
        title: const Text("Livros Didáticos",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: carregando
          ? const Center(child: CircularProgressIndicator())
          : livrosDidaticos.isEmpty
              ? const Center(
                  child: Text("Nenhum livro didático encontrado.",
                      style: TextStyle(fontSize: 16, color: Colors.grey)))
              : ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: livrosDidaticos.length,
                  itemBuilder: (context, index) {
                    final item = livrosDidaticos[index];
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(10),
                        leading: CircleAvatar(
                          backgroundColor: accentColor.withValues(alpha: 0.1),
                          child: const Icon(Icons.book, color: accentColor),
                        ),
                        title: Text(
                          item.titulo ?? "Sem título",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        subtitle: Text("Autor: ${item.autor}"),
                        trailing: const Icon(Icons.arrow_forward_ios,
                            size: 18, color: primaryColor),
                        onTap: () => _abrirDetalhes(item), // Chamada da função
                      ),
                    );
                  },
                ),
    );
  }
}
