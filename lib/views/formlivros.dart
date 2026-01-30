import 'package:flutter/material.dart';
import 'package:livros/presenters/bd_livros.dart';
import 'package:livros/models/cadastralivros.dart';

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

  int? _radioValue = 0;
  String _opcao = "Comprar";
  bool _livroDidatico = true, _livroLiteratura = false, _hqManga = false;
  String _categoria = "Livro Didático";

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

    if (widget.livroParaEditar != null) {
      _opcao = widget.livroParaEditar!.opcao ?? "Comprar";
      _radioValue = ["Comprar", "Lido", "Na prateleira"].indexOf(_opcao);
      if (_radioValue == -1) _radioValue = 0;
      _categoria = widget.livroParaEditar!.categoria ?? "Livro Didático";
      _livroDidatico = _categoria == "Livro Didático";
      _livroLiteratura = _categoria == "Literatura";
      _hqManga = _categoria == "HQ/Mangá";
    }
  }

  @override
  void dispose() {
    _controllerAutor.dispose();
    _controllerTitulo.dispose();
    _controllerEditora.dispose();
    _controllerIdioma.dispose();
    _controllerAno.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.livroParaEditar == null
            ? "Cadastrar Livro"
            : "Editar Livro"),
        backgroundColor: Colors.cyan,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _chaveForm,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField("Autor", _controllerAutor),
              _buildTextField("Título", _controllerTitulo),
              _buildTextField("Editora", _controllerEditora),
              _buildTextField("Idioma", _controllerIdioma),
              _buildTextField("Ano", _controllerAno, isNumber: true),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text("Status de Leitura",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),

              // SOLUÇÃO PARA O AVISO DE DEPRECATED
              // RadioListTile é o substituto moderno que evita os warnings de groupValue/onChanged
              RadioListTile<int>(
                title: const Text("Comprar"),
                value: 0,
                groupValue: _radioValue,
                activeColor: Colors.cyan,
                onChanged: (int? value) => _atualizarRadio(value!),
              ),
              RadioListTile<int>(
                title: const Text("Lido"),
                value: 1,
                groupValue: _radioValue,
                activeColor: Colors.cyan,
                onChanged: (int? value) => _atualizarRadio(value!),
              ),
              RadioListTile<int>(
                title: const Text("Na prateleira"),
                value: 2,
                groupValue: _radioValue,
                activeColor: Colors.cyan,
                onChanged: (int? value) => _atualizarRadio(value!),
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
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan,
                      minimumSize: const Size(200, 50)),
                  onPressed: _enviarFormulario,
                  child: Text(
                      widget.livroParaEditar == null
                          ? "SALVAR LIVRO"
                          : "CONFIRMAR EDIÇÃO",
                      style: const TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
            labelText: label, border: const OutlineInputBorder()),
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        validator: (value) =>
            (value == null || value.isEmpty) ? 'Obrigatório' : null,
      ),
    );
  }

  void _atualizarRadio(int value) {
    setState(() {
      _radioValue = value;
      _opcao = ["Comprar", "Lido", "Na prateleira"][value];
    });
  }

  void _enviarFormulario() async {
    if (_chaveForm.currentState!.validate()) {
      Livros livro = Livros(
        autor: _controllerAutor.text,
        titulo: _controllerTitulo.text,
        editora: _controllerEditora.text,
        idioma: _controllerIdioma.text,
        ano: int.tryParse(_controllerAno.text) ?? 0,
        opcao: _opcao,
        categoria: _categoria,
      );

      if (widget.livroParaEditar != null) {
        livro.id = widget.livroParaEditar!.id;
        await bdLivro.update(livro);
      } else {
        await bdLivro.salvar(livro);
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Operação realizada com sucesso!")),
      );
      Navigator.pop(context);
    }
  }

  void _criaCheckBox(int info, bool value) {
    setState(() {
      if (info == 1) {
        _livroDidatico = value;
        if (value) {
          _livroLiteratura = false;
          _hqManga = false;
          _categoria = "Livro Didático";
        }
      } else if (info == 2) {
        _livroLiteratura = value;
        if (value) {
          _livroDidatico = false;
          _hqManga = false;
          _categoria = "Literatura";
        }
      } else {
        _hqManga = value;
        if (value) {
          _livroDidatico = false;
          _livroLiteratura = false;
          _categoria = "HQ/Mangá";
        }
      }
    });
  }
}
