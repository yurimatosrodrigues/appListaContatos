import 'dart:io';

import 'package:contatos/helps/contato_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  final _telefoneController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

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
      _telefoneController.text = contatoEditar.telefone;

    }
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        backgroundColor: Colors.white,

        appBar: AppBar(
          title: Text(contatoEditar.nome ?? 'Novo Contato'),
          backgroundColor: Colors.red,
          centerTitle: true,
        ),


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


        body: SingleChildScrollView(
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                GestureDetector(
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: contatoEditar.imagem != null
                              ? FileImage(File(contatoEditar.imagem))
                              : AssetImage('images/person.png')
                      )
                  ),
                ),
                  onTap: (){
                    _picker.getImage(source: ImageSource.camera).then((file) {
                      if(file==null) return;
                      setState(() {
                        contatoEditar.imagem = file.path;
                      });
                    });
                  }
                ),

                TextField(
                  controller: _nomeController,
                  focusNode: _nomeFocus,
                  decoration: InputDecoration(
                      labelText: "Nome",
                      labelStyle: TextStyle(color: Colors.red),
                      border: OutlineInputBorder()
                  ),
                  style: TextStyle(color: Colors.black),
                  onChanged: (text){
                    _userEdit = true;
                    setState((){
                      contatoEditar.nome = text;
                    });
                  },
                ),


                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      labelText: "E-mail",
                      labelStyle: TextStyle(color: Colors.red),
                      border: OutlineInputBorder()
                  ),
                  style: TextStyle(color: Colors.black),
                  onChanged: (text){
                    _userEdit = true;
                    contatoEditar.email = text;
                  },
                  keyboardType: TextInputType.emailAddress,
                ),


                TextField(
                  controller: _telefoneController,
                  decoration: InputDecoration(
                      labelText: "Telefone",
                      labelStyle: TextStyle(color: Colors.red),
                      border: OutlineInputBorder()
                  ),
                  style: TextStyle(color: Colors.black),
                  onChanged: (text){
                    _userEdit = true;
                    contatoEditar.telefone = text;
                  },
                  keyboardType: TextInputType.phone,
                )

              ],
            )
        )
    )
    );
  }

  Future<bool> _requestPop(){
    if(_userEdit){
      showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              title: Text('Descartar as alterações?'),
              content: Text('Se sair as alterações serão perdidas.'),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancelar'),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text('Sim'),
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }),
              ]
            );
      });
      return Future.value(false);
    }else{
      return Future.value(true);
    }
  }

}
