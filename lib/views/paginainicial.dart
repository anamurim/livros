import 'package:flutter/material.dart';
import 'package:livros/views/formlivros.dart';
import 'package:livros/views/listalivro.dart';
import 'package:livros/views/sobre.dart';

class PaginaInicial extends StatefulWidget {
  // Adicionado parâmetro key para seguir as boas práticas
  const PaginaInicial({super.key});

  @override
  State<PaginaInicial> createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  int _selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    // Obtém as dimensões da tela para cálculos proporcionais
    final double larguraTela = MediaQuery.of(context).size.width;
    final double alturaTela = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        /*actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.info),
            color: Colors.black,
            onPressed: _showSnackBar, // Referência corrigida
          ),
        ],*/
        title: const Text(
          'APP Meus livros',
          textAlign: TextAlign.start,
          style: TextStyle(fontSize: 14.0, color: Colors.teal),
        ),
      ),
      // SingleChildScrollView evita erros de overflow em telas pequenas ou modo paisagem
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 20),
              // Imagem dimensionada de forma responsiva (40% da altura da tela)
              Image.asset(
                'img/image.png',
                width: larguraTela * 0.6,
                height: alturaTela * 0.3,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 30),
              Text(
                'MEUS LIVROS',
                style: TextStyle(
                  fontSize: larguraTela * 0.07, // Fonte proporcional à largura
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Raleway",
                ),
              ),
              const SizedBox(height: 40),
              // Alinhamento do botão usando Padding proporcional em vez de valores fixos altos
              /*Padding(
                padding: EdgeInsets.symmetric(horizontal: larguraTela * 0.1),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FormLivros()),
                      );
                    },
                    //child: const Icon(Icons.add, color: Colors.teal),
                  ),
                ),
              ),*/
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPage,
        onTap: (int index) {
          setState(() {
            _selectedPage = index;
            if (_selectedPage == 0) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ListaLivros()));
            } else if (_selectedPage == 1) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const FormLivros()));
            } else if (_selectedPage == 2) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Sobre()));
            }
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Meus Livros',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Cadastrar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apps),
            label: 'Sobre',
          ),
        ],
      ),
    );
  }

  /*void _showSnackBar() {
    final snackBar = SnackBar(
      content: const Text('Livro excluído com sucesso!'),
      action: SnackBarAction(
        label: 'Info',
        onPressed: () {
          debugPrint(
              "Bem-Vindo"); // debugPrint é preferível ao print em produção
        },
      ),
      backgroundColor: Colors.amber,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }*/
}
