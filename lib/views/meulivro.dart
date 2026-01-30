import 'package:flutter/material.dart';
import 'package:livros/models/cadastralivros.dart';
import 'formlivros.dart';

class MeuLivro extends StatefulWidget {
  final Livros livro;
  const MeuLivro(this.livro, {super.key});

  @override
  State<MeuLivro> createState() => _MeuLivroState();
}

class _MeuLivroState extends State<MeuLivro> {
  // Criamos uma variável local para conseguir atualizar a tela após a edição
  late Livros livroAtual;

  @override
  void initState() {
    super.initState();
    livroAtual = widget.livro;
  }

  // Função para navegar e atualizar os dados ao voltar
  void _editarLivro() async {
    // O await espera você fechar a tela de formulário
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormLivros(livroParaEditar: livroAtual),
      ),
    );

    // Quando volta, você pode recarregar os dados se necessário.
    // Como os dados são salvos no BD, o ideal é que a lista anterior
    // recarregue, mas para esta tela atualizar agora:
    setState(() {
      // Aqui você poderia buscar do BD novamente ou apenas
      // confiar que os dados foram alterados se passar o objeto de volta
    });
  }

  @override
  Widget build(BuildContext context) {
    final larguraTela = MediaQuery.of(context).size.width;
    final paddingHorizontal = larguraTela > 600 ? larguraTela * 0.2 : 20.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Detalhes do Livro",
          style: TextStyle(
              fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.cyan,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: _editarLivro,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            padding: EdgeInsets.symmetric(
                horizontal: paddingHorizontal, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildInfoSection("Autor:", livroAtual.autor ?? ""),
                _buildInfoSection("Título:", livroAtual.titulo ?? ""),
                _buildInfoSection("Editora:", livroAtual.editora ?? ""),
                _buildInfoSection("Idioma:", livroAtual.idioma ?? ""),
                _buildInfoSection("Ano:", livroAtual.ano?.toString() ?? ""),
                _buildInfoSection(
                    "Informação Adicional:", livroAtual.opcao ?? ""),
                _buildInfoSection("Categoria:", livroAtual.categoria ?? ""),

                const SizedBox(height: 30),

                // --- NOVOS BOTÕES ---
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.edit_note, color: Colors.white),
                        label: const Text("EDITAR DADOS",
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.orange, // Cor diferente para destacar
                        ),
                        onPressed: _editarLivro,
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.arrow_back),
                        label: const Text("VOLTAR",
                            style: TextStyle(fontSize: 16)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyan)),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.black87)),
          const Divider(),
        ],
      ),
    );
  }
}
