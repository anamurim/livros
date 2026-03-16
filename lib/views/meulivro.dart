import 'package:flutter/material.dart';
import 'package:livros/models/cadastralivros.dart';
import 'formlivros.dart';
import 'dart:io';

class MeuLivro extends StatefulWidget {
  final Livros livro;
  const MeuLivro(this.livro, {super.key});

  @override
  State<MeuLivro> createState() => _MeuLivroState();
}

class _MeuLivroState extends State<MeuLivro> {
  late Livros livroAtual;

  @override
  void initState() {
    super.initState();
    livroAtual = widget.livro;
  }

  void _editarLivro() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormLivros(livroParaEditar: livroAtual),
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          livroAtual.titulo ?? "Detalhes",
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: _editarLivro),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exibição da Capa
            if (livroAtual.capa != null && livroAtual.capa!.isNotEmpty)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(File(livroAtual.capa!),
                      height: 150, fit: BoxFit.cover),
                ),
              ),
            const SizedBox(height: 20),

            _buildInfoSection("Autor:", livroAtual.autor ?? ""),
            _buildInfoSection("Editora:", livroAtual.editora ?? ""),
            _buildInfoSection("Ano:", livroAtual.ano?.toString() ?? ""),
            _buildInfoSection("Sinopse:", livroAtual.sinopse ?? "Sem sinopse."),

            const SizedBox(height: 14),
            Row(
              children: [
                const Text("Avaliação: ",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.pinkAccent)),
                ...List.generate(
                    5,
                    (index) => Icon(
                          index < (livroAtual.avaliacao ?? 0)
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                        )),
              ],
            ),
            const Divider(),

            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("VOLTAR"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.pinkAccent)),
          Text(value, style: const TextStyle(fontSize: 16)),
          const Divider(),
        ],
      ),
    );
  }
}
