import 'package:flutter/material.dart';
import 'package:livros/presenters/bd_livros.dart';
import 'package:livros/models/cadastralivros.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class FormLivros extends StatefulWidget {
  final Livros? livroParaEditar;
  const FormLivros({super.key, this.livroParaEditar});

  @override
  State<FormLivros> createState() => _FormLivrosState();
}

class _FormLivrosState extends State<FormLivros> {
  final _chaveForm = GlobalKey<FormState>();
  final bdLivro = BDLivro();

  late TextEditingController _controllerAutor;
  late TextEditingController _controllerTitulo;
  late TextEditingController _controllerEditora;
  late TextEditingController _controllerIdioma;
  late TextEditingController _controllerAno;
  late TextEditingController _controllerSinopse;

  String _opcao = "Comprar";
  String _categoria = "Livro Didático";
  bool _livroDidatico = true, _livroLiteratura = false, _hqManga = false;
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

    if (widget.livroParaEditar != null) {
      _avaliacao = widget.livroParaEditar!.avaliacao ?? 0;
      _opcao = widget.livroParaEditar!.opcao ?? "Comprar";
      _categoria = widget.livroParaEditar!.categoria ?? "Livro Didático";
      if (widget.livroParaEditar!.capa != null) {
        _imagemSelecionada = File(widget.livroParaEditar!.capa!);
      }
    }
  }

  Future<void> _selecionarFoto() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imagemSelecionada = File(image.path);
      });
    }
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
        avaliacao: _avaliacao,
        capa: _imagemSelecionada?.path,
        opcao: _opcao,
        categoria: _categoria,
      );

      if (widget.livroParaEditar != null) {
        await bdLivro.update(livro);
      } else {
        await bdLivro.salvar(livro);
      }

      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  void _criaCheckBox(int info, bool value) {
    setState(() {
      _livroDidatico = (info == 1) ? value : false;
      _livroLiteratura = (info == 2) ? value : false;
      _hqManga = (info == 3) ? value : false;
      if (info == 1) _categoria = "Livro Didático";
      if (info == 2) _categoria = "Literatura";
      if (info == 3) _categoria = "HQ/Mangá";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Cadastro de Livro",
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _chaveForm,
          child: Column(
            children: [
              // Foto da Capa
              GestureDetector(
                onTap: _selecionarFoto,
                child: Container(
                  height: 150,
                  width: 100,
                  color: Colors.grey[300],
                  child: _imagemSelecionada == null
                      ? const Icon(Icons.add_a_photo)
                      : Image.file(_imagemSelecionada!, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField("Autor", _controllerAutor),
              _buildTextField("Título", _controllerTitulo),
              _buildTextField("Editora", _controllerEditora),
              _buildTextField("Idioma", _controllerIdioma),
              _buildTextField("Ano", _controllerAno),
              _buildTextField("Sinopse", _controllerSinopse, maxLines: 3),
              const SizedBox(height: 30),

              const Text("Avaliação",
                  style: TextStyle(
                    fontSize: 16,
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                        index < _avaliacao ? Icons.star : Icons.star_border,
                        color: Colors.amber),
                    onPressed: () => setState(() => _avaliacao = index + 1.0),
                  );
                }),
              ),

              const Divider(),
              RadioGroup<String>(
                groupValue: _opcao,
                onChanged: (String? novoValor) {
                  if (novoValor != null) {
                    setState(() {
                      _opcao = novoValor;
                    });
                  }
                },
                child: const Column(
                  children: [
                    RadioListTile<String>(
                      value: 'Comprar',
                      title: Text('Comprar'),
                    ),
                    RadioListTile<String>(value: 'Lido', title: Text('Lido')),
                    RadioListTile<String>(
                      value: 'Na prateleira',
                      title: Text('Na prateleira'),
                    ),
                  ],
                ),
              ),

              const Divider(),
              CheckboxListTile(
                title: const Text("Livro Didático"),
                value: _livroDidatico,
                onChanged: (v) => _criaCheckBox(1, v!),
              ),
              CheckboxListTile(
                title: const Text("Literatura"),
                value: _livroLiteratura,
                onChanged: (v) => _criaCheckBox(2, v!),
              ),
              CheckboxListTile(
                title: const Text("HQ/Mangá"),
                value: _hqManga,
                onChanged: (v) => _criaCheckBox(3, v!),
              ),
              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: _enviarFormulario,
                child: const Text(
                  "SALVAR LIVRO",
                  style: TextStyle(
                      //color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
            labelText: label, border: const OutlineInputBorder()),
      ),
    );
  }
}
