import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
final String tbContato = "tb_contato";
final String idContato = "id_contato";
final String nomeContato = "nome_contato";
final String emailContato = "email_contato";
final String telefoneContato = "telefone_contato";
final String imagemContato = "imagem_contato";
class ContatoHelper {
  static final ContatoHelper _instance = ContatoHelper.internal();
  factory ContatoHelper() => _instance;
  ContatoHelper.internal();
  Database _db;
  //1 passo
  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }
  //2 passo
  Future<Database> initDb() async {
    final dataBasePath = await getDatabasesPath();
    final path = join(dataBasePath, "contatos.db");
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
          await db.execute(
              "CREATE TABLE $tbContato($idContato INTEGER PRIMARY KEY, $nomeContato TEXT, $emailContato TEXT,"
                  "$telefoneContato TEXT, $imagemContato TEXT)");
        });
  }
  //3 passo
  Future<Contato> salvarContato(Contato contato) async {
    Database dbContato = await db;
    //print(contato.toMap().toString());
    contato.id = await dbContato.insert(tbContato, contato.toMap());
    return contato;
  }
  //passo 4
  Future<Contato> getContato(int id) async {
    Database dbContato = await db;
    List<Map> maps = await dbContato.query(tbContato,
        columns: [
          idContato,
          nomeContato,
          emailContato,
          telefoneContato,
          imagemContato
        ],
        where: "$idContato = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return Contato.from(maps.first);
    } else {
      return null;
    }
  }
  //5 passo
  Future<int> deleteContato(int id) async {
    Database dbContato = await db;
    return await dbContato
        .delete(tbContato, where: "$idContato = ? ", whereArgs: [id]);
  }
  // 6 passo
  Future<int> updateContato(Contato contato) async {
    Database dbContato = await db;
    return await dbContato.update(tbContato, contato.toMap(),
        where: "$idContato = ?", whereArgs: [contato.id]);
  }
  //7 passo
  Future<List> getContatos() async {
    Database dbContato = await db;
    List contatoMap = await dbContato.rawQuery("SELECT * FROM $tbContato");
    List<Contato> listaContato = List();
    for (Map m in contatoMap) {
      listaContato.add(Contato.from(m));
    }
    return listaContato;
  }
  Future<int> getNumber() async {
    Database dbContato = await db;
    return Sqflite.firstIntValue(
        await dbContato.rawQuery("SELECT COUNT(*) FROM $tbContato"));
  }
  //8 passo
  Future<Database> close() async {
    Database dbContato = await db;
    dbContato.close();
  }
}
class Contato {
  int id;
  String nome;
  String email;
  String telefone;
  String imagem;
  Contato();
  Contato.from(Map map) {
    id = map[idContato];
    nome = map[nomeContato];
    email = map[emailContato];
    telefone = map[telefoneContato];
    imagem = map[imagemContato];
  }
  Map toMap() {
    Map<String, dynamic> map = {
      nomeContato: nome,
      emailContato: email,
      telefoneContato: telefone,
      imagemContato: imagem,
    };
    if (id != null) {
      map[idContato] = id;
    }
    return map;
  }
  @override
  String toString() {
    return "Contato(id: $id, nome: $nome, email: $email, imagem: $imagem";
  }
}