import 'dart:async';
import 'package:flutter_application/model/categoria.dart';
import 'package:flutter_application/model/tarefa.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class BancoHelper {
  static const arquivoDoBancoDeDados = 'database.db';
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
      ''');

    await db.execute('''
        INSERT INTO $tabelaCategoria($colunaCategoria)
        VALUES('GERAL')
      ''');

    await db.execute('''
        CREATE TABLE $tabelaTarefa (
          $colunaId INTEGER PRIMARY KEY AUTOINCREMENT,
          $colunaTitulo TEXT NOT NULL,
          $colunaData NUMERIC NOT NULL,
          $colunaFinalizada NUMERIC NOT NULL DEFAULT 0,
          $colunaIdCategoria INTEGER NOT NULL,
          FOREIGN KEY ($colunaIdCategoria) REFERENCES $tabelaCategoria($colunaId)
        )
      ''');

    await db.execute('''
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

  Future<void> deletarTarefa(Tarefa tarefa) async {
    await iniciarBD();

    await _bancoDeDados
        .delete(tabelaTarefa, where: '$colunaId = ?', whereArgs: [tarefa.id]);
  }

  Future<void> editarTarefa(Tarefa tarefa) async {
    await iniciarBD();

    await _bancoDeDados.update(tabelaTarefa, tarefa.toMap(),
        where: '$colunaId = ?', whereArgs: [tarefa.id]);
  }

  Future<Categoria> buscarCategoriaPeloId(int categoriaId) async {
    final List<Map<String, Object?>> resultado = await _bancoDeDados.query(
      tabelaCategoria,
      where: '$colunaId = ?',
      whereArgs: [categoriaId],
    );

    final categoriaMap = resultado.first;
    return Categoria.fromMap(categoriaMap);
  }

  Future<List<Tarefa>> buscarTarefas() async {
    await iniciarBD();

    final List<Map<String, Object?>> tarefasNoBanco =
        await _bancoDeDados.query(tabelaTarefa);

    List<Tarefa> tarefas = [];

    for (final {
          colunaId: pId as int,
          colunaTitulo: pTitulo as String,
          colunaData: pData as DateTime,
          colunaFinalizada: pFinalizada as bool,
          colunaCategoria: pCategoria as int,
        } in tarefasNoBanco) {
      Categoria categoria = await buscarCategoriaPeloId(pCategoria);
      Tarefa tarefa = Tarefa(
        id: pId,
        titulo: pTitulo,
        data: pData,
        finalizada: pFinalizada,
        categoria: categoria,
      );

      tarefas.add(tarefa);
    }
    return tarefas;
  }

  Future<List<Categoria>> buscarCategorias() async {
    await iniciarBD();

    final List<Map<String, Object?>> categoriasNoBanco =
        await _bancoDeDados.query(tabelaCategoria);

    return [
      for (final {
            colunaId: pId as int,
            colunaCategoria: pCategoria as String,
          } in categoriasNoBanco)
        Categoria(id: pId, categoria: pCategoria),
    ];
  }
}
