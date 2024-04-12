import 'dart:async';
import 'dart:ffi';
import 'package:flutter_application/model/pessoa.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class BancoHelper {
  static const arquivoDoBancoDeDados = 'nossoBD.db';
  static const arquivoDoBancoDeDadosVersao = 1;

  static const tabelaTarefa = 'tarefa';
  static const tabelaCategoria = 'categoria';
  static const tabelaLogin = 'login';
  static const colunaId = 'id';
  static const colunaTitulo = 'titulo';
  static const colunaData = 'data';
  static const colunaFinalizada = 'finalizada';
  static const colunaIdCategoria = 'id_categoria';
  static const colunaCategoria = 'categoria';
  static const colunaUsuario = 'usuario';
  static const colunaSenha = 'senha';

  static late Database _bancoDeDados;

  iniciarBD() async {
    String caminhoBD = await getDatabasesPath();
    String path = join(caminhoBD, arquivoDoBancoDeDados);

    _bancoDeDados = await openDatabase(path,
        version: arquivoDoBancoDeDadosVersao, 
        onCreate: funcaoCriacaoBD, 
        onUpgrade: funcaoAtualizarBD, 
        onDowngrade: funcaoDowngradeBD);
  }

  Future funcaoCriacaoBD(Database db, int version) async {
    await db.execute('''
        CREATE TABLE $tabelaCategoria (
          $colunaId INTEGER PRIMARY KEY AUTOINCREMENT,
          $colunaCategoria TEXT NOT NULL
        )

        CREATE TABLE $tabelaTarefa (
          $colunaId INTEGER PRIMARY KEY AUTOINCREMENT,
          $colunaTitulo TEXT NOT NULL,
          $colunaData NUMERIC NOT NULL,
          $colunaFinalizada NUMERIC NOT NULL DEFAULT 0,
          $colunaIdCategoria INTEGER NOT NULL,
          FOREIGN KEY ($colunaIdCategoria) REFERENCES $tabelaCategoria($colunaId)
        )

        CREATE TABLE $tabelaLogin (
          $colunaId INTEGER PRIMARY KEY AUTOINCREMENT,
          $colunaUsuario TEXT NOT NULL,
          $colunaSenha TEXT NOT NULL
        )
      ''');
  }

  Future funcaoAtualizarBD(Database db, int oldVersion, int newVersion) async {
    //controle dos comandos sql para novas versões
    
    if (oldVersion < 2) {
      //Executa comandos  
    }
    
  }

  Future funcaoDowngradeBD(Database db, int oldVersion, int newVersion) async {
    //controle dos comandos sql para voltar versãoes. 
    //Estava-se na 2 e optou-se por regredir para a 1
  }

  Future<int> inserirCategoria(Map<String, dynamic> row) async {
    await iniciarBD();
    return await _bancoDeDados.insert(tabelaCategoria, row);
  }

  Future<int> inserirTarefa(Map<String, dynamic> row) async {
    await iniciarBD();
    return await _bancoDeDados.insert(tabelaTarefa, row);
  }

  Future<int> deletarTarefa(int id) async {
    await iniciarBD();
    return _bancoDeDados.delete(tabelaTarefa);
  }

  Future<List<Pessoa>> buscarPessoas() async {
    await iniciarBD();
    
    final List<Map<String, Object?>> pessoasNoBanco =
        await _bancoDeDados.query(tabela);

    return [
      for (final {
            colunaId: pId as int,
            colunaNome: pNome as String,
            colunaIdade: pIdade as int,
          } in pessoasNoBanco)
        Pessoa(id: pId, nome: pNome, idade: pIdade),
    ];
  }

  Future<void> editar(Pessoa regPessoa) async {
    await iniciarBD();

    await _bancoDeDados.update(
      tabela,
      regPessoa.toMap(),
      where: '$colunaId = ?',
      whereArgs: [regPessoa.id],
    );
  }
}
