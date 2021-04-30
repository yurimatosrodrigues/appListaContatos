import 'dart:io';

import 'package:contatos/helps/contato_helper.dart';
import 'package:contatos/ui/contato_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContatoHelper helper = ContatoHelper();

  List<Contato> contatos = [];

  @override
  void initState() {
    super.initState();

   /*Contato c = new Contato();
    c.nome = "Vida";
    c.email = 'lorenmatos34@gmail.com';
    c.telefone = '958603139';
    helper.salvarContato(c);*/


    helper.getContatos().then((value) {
      setState(() {
        contatos = value;
      });
    });
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
                        Text(contatos[index].nome,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.lightBlue
                          ),
                        ),

                        Text(contatos[index].email,
                          style: TextStyle(
                              fontSize: 17,

                          ),
                        ),

                        Text(contatos[index].telefone,
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
        _showContatoPage(contato: contatos[index]);
      },
    );
  }

  void _showContatoPage({Contato contato}){
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ContatoPage(contato: contato,)));
  }
}
