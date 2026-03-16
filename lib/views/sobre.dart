import 'package:flutter/material.dart';

class Sobre extends StatefulWidget {
  const Sobre({super.key});

  @override
  State<Sobre> createState() => _SobreState();
}

class _SobreState extends State<Sobre> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre a Aplicação',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurple,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            // Cabeçalho com Imagem e Título
            const SizedBox(height: 10),
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.deepPurple.withValues(alpha: 0.1),
              child: Image.asset(
                'img/estudos.png',
                width: 80,
                height: 80,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "App Meus Livros",
              style: TextStyle(
                fontSize: 26.0,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Organize sua biblioteca pessoal, cadastre seus livros e acompanhe sua lista de desejos e favoritos em um só lugar.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.0, color: Colors.black54),
              ),
            ),
            const SizedBox(height: 30),

            // Card de Informações dos Desenvolvedores
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.code, color: Colors.deepPurple),
                        SizedBox(width: 10),
                        Text(
                          "Desenvolvedores",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const Divider(),
                    _buildDevRow("Ana Amurim"),
                    const SizedBox(height: 10),
                    const Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.grey, size: 20),
                        SizedBox(width: 10),
                        Text("Versão 1.1.0",
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Imagem de Rodapé Decorativa
            /*Opacity(
              opacity: 0.8,
              child: Image.asset(
                'img/literatura.png',
                width: 120,
                height: 120,
                fit: BoxFit.contain,
              ),
            ),*/
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para listar desenvolvedores
  Widget _buildDevRow(String nome) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.person_outline, size: 20, color: Colors.black45),
          const SizedBox(width: 10),
          Text(nome, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
