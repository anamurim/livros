import 'package:flutter/material.dart';
import 'package:livros/presenters/bd_livros.dart';
import 'package:livros/models/cadastralivros.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CadastrarLivros extends StatefulWidget {
  final Livros? livroParaEditar;
  const CadastrarLivros({super.key, this.livroParaEditar});

  @override
  State<CadastrarLivros> createState() => _CadastrarLivrosState();
}

class _CadastrarLivrosState extends State<CadastrarLivros> {
  final _chaveForm = GlobalKey<FormState>();
  final bdLivro = BDLivro();

  late TextEditingController _controllerAutor;
  late TextEditingController _controllerTitulo;
  late TextEditingController _controllerEditora;
  late TextEditingController _controllerIdioma;
  late TextEditingController _controllerAno;
  late TextEditingController _controllerSinopse;
  late TextEditingController _controllerEmprestimo;

  String _status = "Comprar";
  String _categoria = "Livro Didático";
  double _avaliacao = 0;
  File? _imagemSelecionada;

  @override
  void initState() {
    super.initState();
    _controllerAutor =
        TextEditingController(text: widget.livroParaEditar?.autor ?? "");
    _controllerTitulo =
        TextEditingController(text: widget.livroParaEditar?.titulo ?? "");
    _controllerEditora =
        TextEditingController(text: widget.livroParaEditar?.editora ?? "");
    _controllerIdioma =
        TextEditingController(text: widget.livroParaEditar?.idioma ?? "");
    _controllerAno = TextEditingController(
        text: widget.livroParaEditar?.ano?.toString() ?? "");
    _controllerSinopse =
        TextEditingController(text: widget.livroParaEditar?.sinopse ?? "");
    _controllerEmprestimo = TextEditingController(
        text: widget.livroParaEditar?.emprestadoPara ?? "");
    // Certifique-se que o status inicial está correto
    _status = widget.livroParaEditar?.status ?? "Comprar";

    if (widget.livroParaEditar != null) {
      _avaliacao = widget.livroParaEditar!.avaliacao ?? 0;
      _status = widget.livroParaEditar!.status ?? "Comprar";
      _categoria = widget.livroParaEditar!.categoria ?? "Livro Didático";
      if (widget.livroParaEditar!.capa != null) {
        _imagemSelecionada = File(widget.livroParaEditar!.capa!);
      }
    }
  }

  Future<void> _selecionarFoto() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800, // Importante para reduzir o uso de memória
      imageQuality: 85,
    );
    if (image != null) {
      setState(() => _imagemSelecionada = File(image.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF4A148C); // Roxo da Home
    const accentColor = Color(0xFFC2185B); // Rosa da Home

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
            widget.livroParaEditar == null ? "Novo Livro" : "Editar Livro",
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                height: 20, color: primaryColor), // Detalhe estético no topo
            Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _chaveForm,
                child: Column(
                  children: [
                    _buildImagePicker(accentColor),
                    const SizedBox(height: 20),
                    _buildSectionCard(
                      title: "Informações Básicas",
                      icon: Icons.info_outline,
                      color: primaryColor,
                      children: [
                        _buildTextField(
                            "Título", _controllerTitulo, Icons.book),
                        _buildTextField(
                            "Autor", _controllerAutor, Icons.person),
                        _buildTextField(
                            "Editora", _controllerEditora, Icons.business),
                      ],
                    ),
                    _buildSectionCard(
                      title: "Detalhes Técnicos",
                      icon: Icons.settings,
                      color: accentColor,
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: _buildTextField(
                                    "Ano", _controllerAno, Icons.calendar_today,
                                    isNum: true)),
                            const SizedBox(width: 10),
                            Expanded(
                                child: _buildTextField("Idioma",
                                    _controllerIdioma, Icons.language)),
                          ],
                        ),
                        const SizedBox(height: 15),
                        const Text("Categoria",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey)),
                        DropdownButtonFormField<String>(
                          initialValue: _categoria,
                          items: [
                            "Livro Didático",
                            "Literatura",
                            "HQ/Mangá",
                            "Autoajuda",
                            "Outro"
                          ]
                              .map((c) =>
                                  DropdownMenuItem(value: c, child: Text(c)))
                              .toList(),
                          onChanged: (v) => setState(() => _categoria = v!),
                          decoration: const InputDecoration(
                              border: UnderlineInputBorder()),
                        ),
                      ],
                    ),
                    _buildSectionCard(
                      title: "Status e Avaliação",
                      icon: Icons.star_outline,
                      color: Colors.deepPurpleAccent,
                      children: [
                        const Text("Status do Livro",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey)),
                        DropdownButtonFormField<String>(
                          initialValue: _status,
                          items: [
                            "Comprar",
                            "Lido",
                            "Lendo",
                            "Na prateleira",
                            "Emprestado"
                          ]
                              .map((c) =>
                                  DropdownMenuItem(value: c, child: Text(c)))
                              .toList(),
                          onChanged: (v) => setState(() => _status = v!),
                          decoration: const InputDecoration(
                              border: UnderlineInputBorder()),
                        ),
                        if (_status == "Emprestado")
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: _buildTextField(
                                "Emprestado para quem?",
                                _controllerEmprestimo,
                                Icons.person_pin_rounded),
                          ),
                        const SizedBox(height: 10),
                        // const Divider(),
                        const SizedBox(height: 15),
                        if (_status == "Lido" || _status == "Emprestado")
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Divider(),
                              const Text("Sua Avaliação",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                    5,
                                    (index) => IconButton(
                                          icon: Icon(
                                              index < _avaliacao
                                                  ? Icons.star
                                                  : Icons.star_border,
                                              color: Colors.amber),
                                          onPressed: () => setState(
                                              () => _avaliacao = index + 1.0),
                                        )),
                              ),
                            ],
                          ),

                        _buildTextField(
                            "Sinopse", _controllerSinopse, Icons.description,
                            maxLines: 5),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton.icon(
                        onPressed: _enviarFormulario,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xFF2E7D32), // Verde Escuro da Logo
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                        ),
                        icon: const Icon(Icons.save, color: Colors.white),
                        label: const Text("SALVAR NA BIBLIOTECA",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePicker(Color color) {
    return GestureDetector(
      onTap: _selecionarFoto,
      child: CircleAvatar(
        radius: 70,
        backgroundColor: Colors.grey[300],
        backgroundImage:
            _imagemSelecionada != null ? FileImage(_imagemSelecionada!) : null,
        child: _imagemSelecionada == null
            ? const Icon(Icons.camera_alt, size: 40)
            : null,
      ),
    );
  }

  Widget _buildSectionCard(
      {required String title,
      required IconData icon,
      required Color color,
      required List<Widget> children}) {
    return Card(
      //elevation: 2,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(title,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: color)),
              ],
            ),
            const Divider(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController ctrl, IconData icon,
      {int maxLines = 1, bool isNum = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextFormField(
        controller: ctrl,
        maxLines: maxLines,
        keyboardType: isNum ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          alignLabelWithHint: true,
          prefixIcon: Padding(
            padding: EdgeInsets.only(bottom: maxLines > 1 ? 70 : 0),
            child: Icon(icon, color: const Color(0xFF4A148C)),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey[50],
        ),
        validator: (v) => v!.isEmpty ? "Obrigatório" : null,
      ),
    );
  }

  void _enviarFormulario() async {
    if (_chaveForm.currentState!.validate()) {
      final livro = Livros(
        id: widget.livroParaEditar?.id,
        autor: _controllerAutor.text,
        titulo: _controllerTitulo.text,
        editora: _controllerEditora.text,
        idioma: _controllerIdioma.text,
        ano: int.tryParse(_controllerAno.text) ?? 0,
        sinopse: _controllerSinopse.text,
        avaliacao:
            (_status == "Lido" || _status == "Emprestado") ? _avaliacao : 0.0,
        capa: _imagemSelecionada?.path,
        status: _status,
        categoria: _categoria,
        emprestadoPara:
            _status == "Emprestado" ? _controllerEmprestimo.text : null,
      );

      widget.livroParaEditar != null
          ? await bdLivro.update(livro)
          : await bdLivro.salvar(livro);
      if (!mounted) return;
      Navigator.pop(context);
    }
  }
}
