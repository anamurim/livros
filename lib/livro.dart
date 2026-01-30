import 'package:flutter/material.dart';
import 'views/paginainicial.dart';

class Livro extends StatelessWidget {
  const Livro({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AppMeusLivros',
      theme: ThemeData(primarySwatch: Colors.cyan),
      home: const PaginaInicial(),
    );
  }
}
