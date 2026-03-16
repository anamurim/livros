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
  var db = BDLivro();
  List<Livros> livros = [];

  @override
  void initState() {
    super.initState();
    _atualizarLista();
  }

  void _atualizarLista() async {
    List<Livros> temp = await db.getLivros();
    setState(() {
      livros = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meus Livros Cadastrados",
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
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

                      return Dismissible(
                        key: Key(item.id.toString() +
                            DateTime.now().millisecondsSinceEpoch.toString()),
                        direction: DismissDirection.endToStart,

                        // Solicita confirmação de exclusão
                        confirmDismiss: (direction) async {
                          return await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Confirmar"),
                                content:
                                    Text("Deseja excluir '${item.titulo}'?"),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text("CANCELAR"),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: const Text("EXCLUIR",
                                        style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              );
                            },
                          );
                        },

                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),

                        onDismissed: (direction) async {
                          // Arquiva as informações necessárias
                          final livroExcluido = item;

                          // CAPTURA O MESSENGER ANTES DO ASYNC GAP
                          final messenger = ScaffoldMessenger.of(context);

                          //Atualiza a interface
                          setState(() {
                            livros.removeAt(index);
                          });

                          //Deleta no banco de dados
                          await db.delete(livroExcluido.id!);

                          //Verificamos se o widget ainda está na árvore antes de interagir
                          if (!mounted) return;

                          //Usa a variável 'messenger' em vez de 'ScaffoldMessenger.of(context)'
                          messenger.clearSnackBars();
                          messenger.showSnackBar(
                            SnackBar(
                              content: Text("${livroExcluido.titulo} removido"),
                              duration: const Duration(seconds: 4),
                              /*action: SnackBarAction(
                                label: "DESFAZER",
                                onPressed: () async {
                                  await db.salvar(livroExcluido);
                                  _atualizarLista();
                                },
                              ),*/
                            ),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: ListTile(
                            leading: const Icon(Icons.book,
                                color: Colors.deepPurple),
                            title: Text(item.titulo ?? "Sem título",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            subtitle: Text(item.autor ?? "Autor não informado"),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.deepPurple,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MeuLivro(item),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
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
