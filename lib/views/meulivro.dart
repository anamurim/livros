import 'package:flutter/material.dart';
import 'package:livros/models/cadastralivros.dart';
import 'cadastro_livro_pagina.dart';
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
        builder: (context) => CadastrarLivros(livroParaEditar: livroAtual),
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Cores baseadas na sua PaginaInicial
    const primaryColor = Color(0xFF4A148C); // Roxo
    const accentColor = Color(0xFFC2185B); // Rosa
    const detailColor = Color(0xFF2E7D32); // Verde

    return Scaffold(
      backgroundColor: const Color(
          0xFFF8F9FA), // Fundo levemente cinza para destacar os cards
      appBar: AppBar(
        title: Text(
          livroAtual.titulo ?? "Detalhes do Livro",
          style: const TextStyle(
            color: Colors.white,
            //fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        centerTitle: false,
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note_rounded, size: 28),
            onPressed: _editarLivro,
            tooltip: "Editar Livro",
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header com a imagem e informações rápidas
            Stack(
              children: [
                Container(height: 50, color: primaryColor),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Center(
                    child: _buildCapaSection(livroAtual.capa),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  _buildRatingStars(livroAtual.avaliacao ?? 0),
                  const SizedBox(height: 25),

                  // Card de Informações Técnicas
                  _buildDetailCard(
                    title: "Especificações",
                    icon: Icons.menu_book_rounded,
                    color: accentColor,
                    children: [
                      _buildInfoRow(Icons.person, "Autor",
                          livroAtual.autor ?? "Não informado"),
                      _buildInfoRow(Icons.business, "Editora",
                          livroAtual.editora ?? "Não informada"),
                      _buildInfoRow(Icons.calendar_month, "Ano de Lançamento",
                          livroAtual.ano?.toString() ?? "-"),
                      _buildInfoRow(Icons.language, "Idioma",
                          livroAtual.idioma ?? "Não informado"),
                      _buildInfoRow(Icons.category, "Categoria",
                          livroAtual.categoria ?? "Geral"),
                    ],
                  ),

                  // Card de Sinopse
                  _buildDetailCard(
                    title: "Sinopse",
                    icon: Icons.description_rounded,
                    color: detailColor,
                    children: [
                      Text(
                        livroAtual.sinopse ??
                            "Nenhuma sinopse disponível para este livro.",
                        style: TextStyle(
                            fontSize: 15, color: Colors.grey[800], height: 1.5),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Botão Voltar Estilizado
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text("VOLTAR PARA LISTA",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: primaryColor,
                        side: const BorderSide(color: primaryColor, width: 2),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCapaSection(String? capaPath) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 15, offset: Offset(0, 8))
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: (capaPath != null && capaPath.isNotEmpty)
            ? Image.file(File(capaPath),
                height: 150, width: 130, fit: BoxFit.cover)
            : Container(
                height: 150,
                width: 130,
                color: Colors.grey[300],
                child: const Icon(Icons.image_not_supported,
                    size: 50, color: Colors.grey),
              ),
      ),
    );
  }

  Widget _buildRatingStars(double avaliacao) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return Icon(
          index < avaliacao ? Icons.star_rounded : Icons.star_border_rounded,
          color: Colors.amber,
          size: 30,
        );
      }),
    );
  }

  Widget _buildDetailCard(
      {required String title,
      required IconData icon,
      required Color color,
      required List<Widget> children}) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey.withAlpha(50)),
      ),
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 10),
                Text(title,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: color)),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(),
            ),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500)),
                Text(value,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
