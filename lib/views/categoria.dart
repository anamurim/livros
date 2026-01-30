import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';
import 'formlivros.dart';
import 'paginainicial.dart';
import 'sobre.dart';

class Categoria extends StatefulWidget {
  const Categoria({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CategoriaState();
  }
}

class _CategoriaState extends State<Categoria> {
  int _selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    //Cria o formulário com a  chave global _chaveForm
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CATEGORIA',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 22.0,
              color: Colors.white,
              //fontWeight: FontWeight.bold,
              fontFamily: "Raleway"),
        ),
      ),

      //cria um fomulário
      body: Center(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Image.asset(
                    'img/estudos.png',
                    width: 150,
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(10),
                ),
              ],
            ),
            Row(children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Image.asset(
                  'img/literatura.png',
                  width: 150,
                  height: 150,
                  fit: BoxFit.contain,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10),
              ),
            ]),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedPage,
        onTap: (int index) {
          setState(() {
            _selectedPage = index;

            if (_selectedPage == 0) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PaginaInicial()));
            }
            if (_selectedPage == 1) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const FormLivros()));
            }
            if (_selectedPage == 2) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Sobre()));
            }
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Meus Livros',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.exit_to_app),
            label: 'Sair',
          ),
        ],
      ),
    );
  }

  /*void _showSnackBar(){
    final snackBar = SnackBar(
      content: Text("Selecione uma categria para o livro"),
      action: SnackBarAction(
        label: 'Info',
        onPressed: (){
          print("nads");
      }
      
      ),
      //duration: new Durantion(seconds:3),
      backgroundColor: Colors.amber,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('snackBar')),
    );
  }*/
}
