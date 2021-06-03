import 'dart:io';

import 'package:contatos/helps/contato_helper.dart';
import 'package:contatos/ui/contato_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContatoHelper helper = ContatoHelper();

  List<Contato> contatos = [];

  @override
  void initState(){
    super.initState();
    _getTodosContatos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Contatos'),
          backgroundColor: Colors.red,
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showContatoPage();
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.red,
        ),
        body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: contatos.length,
          itemBuilder: (context, index) {
            return _contatoCard(context,index);
          },
        ));
  }

  Widget _contatoCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: [
                Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: contatos[index].imagem != null
                                ? FileImage(File(contatos[index].imagem))
                                : AssetImage("images/person.png")
                        )
                    )
                ),
                Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          contatos[index].nome != null ?
                            contatos[index].nome : "",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.lightBlue
                          ),
                        ),

                        Text(
                          contatos[index].email != null ?
                            contatos[index].email : "",
                          style: TextStyle(
                              fontSize: 17,

                          ),
                        ),

                        Text(
                          contatos[index].telefone != null ?
                            contatos[index].telefone : "",
                          style: TextStyle(
                              fontSize: 17,

                          ),
                        )
                      ],
                    )
                ),
              ],
            )),
      ),
      onTap: (){
        //_showContatoPage(contato: contatos[index]);
        _showOptions(context, index);
      },
    );
  }

  void _showContatoPage({Contato contato}) async{
    final _recContato = await Navigator.push(context,
       MaterialPageRoute(builder: (context) => ContatoPage(contato: contato,)));
    if (_recContato != null){
      if(contato != null){
        helper.updateContato(_recContato);
      }
      else{
        helper.salvarContato(_recContato);
      }
      _getTodosContatos();
    }
  }

  void _showOptions(BuildContext context, int index){
    showModalBottomSheet(
        context: context,
        builder: (context){
          return BottomSheet(
            onClosing: (){

            },
              builder: (context){
                return Container(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: TextButton(
                          child: Text('Editar',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 20
                            ),
                          ),
                          onPressed: (){
                            Navigator.pop(context);
                            _showContatoPage(contato: contatos[index]);
                          },
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: TextButton(
                          child: Text('Ligar',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 20
                            ),
                          ),
                          onPressed: (){
                            launch("tel: ${contatos[index].telefone}");
                          },
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: TextButton(
                          child: Text('Excluir',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 20
                            ),
                          ),
                          onPressed: (){
                            helper.deleteContato(contatos[index].id);
                            setState(() {
                              contatos.removeAt(index);
                              Navigator.pop(context);
                            });
                          },
                        ),
                      )
                    ],
                  ),
                );
              }
          );
        }
    );
  }

  void _getTodosContatos(){
    helper.getContatos().then((value) {
      setState(() {
        contatos = value;
      });
    });
  }
}
