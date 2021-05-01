import 'package:contatos/helps/contato_helper.dart';
import 'package:flutter/material.dart';

class ContatoPage extends StatefulWidget {
  final Contato contato;

  ContatoPage({this.contato});

  @override
  _ContatoPageState createState() => _ContatoPageState();
}

class _ContatoPageState extends State<ContatoPage> {
  Contato contatoEditar;
  bool _userEdit = true;

  final _nomeFocus = FocusNode();

  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneControler = TextEditingController();

  @override
  void initState() {
    super.initState();

    if(widget.contato == null){
      contatoEditar = Contato();
    }
    else{
      contatoEditar = Contato.from(widget.contato.toMap());
      _nomeController.text = contatoEditar.nome;
      _emailController.text = contatoEditar.email;
      _telefoneControler.text = contatoEditar.telefone;

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(contatoEditar.nome ?? 'Novo Contato'),
          backgroundColor: Colors.red,
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if(contatoEditar.nome != null && contatoEditar.nome.isNotEmpty){
              Navigator.pop(context, contatoEditar);
            }
            else{
              FocusScope.of(context).requestFocus(_nomeFocus);
            }
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.red,
        ),
      body: SingleChildScrollView()
    );
  }
}
