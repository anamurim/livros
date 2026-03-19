import 'package:flutter/material.dart';
import 'package:livros/presenters/bd_livros.dart';
import 'package:livros/models/cadastralivros.dart';
import 'meulivro.dart';

class ListaLivros extends StatefulWidget {
  const ListaLivros({super.key});

  @override
  State<ListaLivros> createState() => _ListaLivrosState();
}

class _ListaLivrosState extends State<ListaLivros> {
  bool _cancelarExclusao = false;
  var db = BDLivro();
  List<Livros> livros = [];

  // Variável para controlar o critério de ordenação atual
  String _criterioOrdenacao = 'titulo';

  @override
  void initState() {
    super.initState();
    _atualizarLista();
  }

  void _atualizarLista() async {
    List<Livros> temp = await db.getLivros();

    // Aplicar a ordenação na lista carregada
    _ordenarLista(temp);

    setState(() {
      livros = temp;
    });
  }

  void _ordenarLista(List<Livros> lista) {
    if (_criterioOrdenacao == 'titulo') {
      lista.sort((a, b) => (a.titulo ?? "")
          .toLowerCase()
          .compareTo((b.titulo ?? "").toLowerCase()));
    } else if (_criterioOrdenacao == 'autor') {
      lista.sort((a, b) => (a.autor ?? "")
          .toLowerCase()
          .compareTo((b.autor ?? "").toLowerCase()));
    }
  }

  void _confirmarExclusao(int? id, String titulo, int index) {
    if (id == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Excluir Livro"),
        content: Text("Tem certeza que deseja excluir o livro '$titulo'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CANCELAR"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Fecha o diálogo
              _executarExclusaoComDesfazer(id, titulo, index);
            },
            child: const Text("EXCLUIR", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _executarExclusaoComDesfazer(int id, String titulo, int index) {
    final livroRemovido = livros[index];
    _cancelarExclusao = false;

    setState(() {
      livros.removeAt(index); // Remove da tela imediatamente
    });

    ScaffoldMessenger.of(context).clearSnackBars(); // Limpa avisos anteriores
    ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            content: Text("Livro '$titulo' excluído"),
            duration: const Duration(seconds: 5), // Janela de 5 segundos
            action: SnackBarAction(
              label: "DESFAZER",
              textColor: Colors.pinkAccent,
              onPressed: () {
                _cancelarExclusao = true;
                setState(() {
                  livros.insert(
                      index, livroRemovido); // Devolve para a lista na tela
                });
              },
            ),
          ),
        )
        .closed
        .then((reason) {
      // Se a barra sumiu e o usuário NÃO clicou em desfazer, apaga do banco de vez
      if (!_cancelarExclusao) {
        db.delete(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meus Livros", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // BOTÃO DE ORDENAÇÃO
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort_by_alpha, color: Colors.white),
            onSelected: (String result) {
              setState(() {
                _criterioOrdenacao = result;
                _ordenarLista(livros); // Reordena a lista atual
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'titulo',
                child: Text('Ordenar por Título'),
              ),
              const PopupMenuItem<String>(
                value: 'autor',
                child: Text('Ordenar por Autor'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: livros.isEmpty
                ? const Center(child: Text("Nenhum livro cadastrado."))
                : ListView.builder(
                    itemCount: livros.length,
                    itemBuilder: (context, index) {
                      final item = livros[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.purpleAccent,
                            child: Icon(Icons.book, color: Colors.white),
                          ),
                          title: Text(item.titulo ?? "Sem título",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(item.autor ?? "Autor não informado"),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.redAccent),
                            onPressed: () => _confirmarExclusao(
                                item.id,
                                item.titulo ?? "",
                                index), // Adicionado o index aqui
                          ),
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MeuLivro(item)),
                            );
                            _atualizarLista();
                          },
                        ),
                      );
                    },
                  ),
          ),
          // Botão Voltar (mantido conforme seu código original)
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.home),
                label: const Text("VOLTAR AO MENU INICIAL"),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purpleAccent,
                    foregroundColor: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
