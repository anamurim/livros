import 'package:flutter/material.dart';
import 'package:livros/views/cadastro_livro_pagina.dart';
import 'package:livros/views/listalivro.dart';
import 'package:livros/views/sobre.dart';
import 'package:livros/views/lista_literatura.dart';
import 'package:livros/views/lista_didaticos.dart';
import 'package:livros/views/lista_hqs_mangas.dart';
import 'package:livros/views/lista_auto_ajuda.dart';
import 'package:livros/views/lista_outros.dart';

class PaginaInicial extends StatefulWidget {
  const PaginaInicial({super.key});

  @override
  State<PaginaInicial> createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Fundo com degradê suave seguindo sua paleta
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFCE4EC), Colors.white], // Rosa claro para branco
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 70),
              // Logo Circular com Sombra
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withValues(alpha: 0.2),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'img/image.png',
                      width: 180,
                      height: 180,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Adquira cultura",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A148C), // Roxo Escuro
                  letterSpacing: 1.5,
                ),
              ),
              const Text(
                "Sua biblioteca pessoal inteligente",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 25),
              // Menu de Opções
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.count(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    children: [
                      _buildMenuButton(
                        context,
                        "Meus Livros",
                        Icons.library_books,
                        const Color(0xFF2E7D32), // Verde Escuro
                        const ListaLivros(),
                      ),
                      _buildMenuButton(
                        context,
                        "Cadastrar",
                        Icons.add_circle_outline,
                        const Color(0xFFC2185B), // Rosa
                        const CadastrarLivros(),
                      ),
                      _buildMenuButton(
                        context,
                        "Literatura",
                        Icons.auto_stories,
                        const Color.fromARGB(255, 255, 51, 177), // Pink
                        const ListaLiteratura(),
                      ),
                      _buildMenuButton(
                        context,
                        "Didáticos",
                        Icons.school,
                        const Color.fromARGB(174, 241, 60, 145), // Rosa claro
                        //null,
                        const ListaDidaticos(),
                      ),
                      _buildMenuButton(
                        context,
                        "HQs/Mangás",
                        Icons.menu_book,
                        const Color.fromARGB(255, 62, 3, 87), // Roxo
                        const ListaHqsMangas(),
                      ),
                      _buildMenuButton(
                        context,
                        "Auto Ajuda",
                        Icons.self_improvement,
                        const Color.fromARGB(255, 185, 0, 231), // Roxo
                        const ListaAutoAjuda(),
                      ),
                      _buildMenuButton(
                        context,
                        "Outros livros",
                        Icons.self_improvement,
                        const Color.fromARGB(255, 156, 3, 92), // Roxo
                        const ListaOutros(),
                      ),
                      _buildMenuButton(
                        context,
                        "Sobre",
                        Icons.info_outline,
                        const Color.fromARGB(255, 2, 63, 10), // Verde
                        const Sobre(),
                      ),
                      /*_buildMenuButton(
                        context,
                        "Sair",
                        Icons.exit_to_app,
                        Colors.blueGrey,
                        null, // Ação de sair
                      ),*/
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget auxiliar para criar os botões bonitos
  Widget _buildMenuButton(BuildContext context, String label, IconData icon,
      Color color, Widget? destination) {
    return GestureDetector(
      onTap: () {
        if (destination != null) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => destination));
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: color),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color.withAlpha(200),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
