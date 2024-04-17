import 'dart:async';
import 'package:flutter_application/model/categoria.dart';
import 'package:flutter_application/model/tarefa.dart';
import 'package:flutter_application/model/usuario.dart';
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

  Future<void> iniciarBD() async {
    String caminhoBD = await getDatabasesPath();
    String path = join(caminhoBD, arquivoDoBancoDeDados);

    _bancoDeDados = await openDatabase(path,
        version: arquivoDoBancoDeDadosVersao,
        onCreate: funcaoCriacaoBD,
        onUpgrade: funcaoAtualizarBD,
        onDowngrade: funcaoDowngradeBD);
  }

  Future funcaoCriacaoBD(Database db, int version) async {
    String dateTimeAtual = DateTime.now().toString();

    await db.execute('''
        CREATE TABLE $tabelaCategoria (
          $colunaId INTEGER PRIMARY KEY AUTOINCREMENT,
          $colunaCategoria TEXT NOT NULL
        )
      ''');

    await db.execute('''
        INSERT INTO $tabelaCategoria($colunaCategoria)
        VALUES('Trabalho')
      ''');
    await db.execute('''
        INSERT INTO $tabelaCategoria($colunaCategoria)
        VALUES('Estudos')
      ''');
    await db.execute('''
        INSERT INTO $tabelaCategoria($colunaCategoria)
        VALUES('Casa')
      ''');

    await db.execute('''
        CREATE TABLE $tabelaTarefa (
          $colunaId INTEGER PRIMARY KEY AUTOINCREMENT,
          $colunaTitulo TEXT NOT NULL,
          $colunaData TEXT NOT NULL,
          $colunaFinalizada NUMERIC NOT NULL DEFAULT 0,
          $colunaIdCategoria INTEGER NOT NULL,
          FOREIGN KEY ($colunaIdCategoria) REFERENCES $tabelaCategoria($colunaId)
        )
      ''');

    await db.execute('''
        INSERT INTO $tabelaTarefa($colunaTitulo, $colunaData, $colunaIdCategoria)
        VALUES('TDE linguagens formais', '$dateTimeAtual', 1)
      ''');

    await db.execute('''
        INSERT INTO $tabelaTarefa($colunaTitulo, $colunaData, $colunaIdCategoria)
        VALUES('Estudar Flutter', '$dateTimeAtual', 2)
      ''');

    await db.execute('''
        CREATE TABLE $tabelaLogin (
          $colunaId INTEGER PRIMARY KEY AUTOINCREMENT,
          $colunaUsuario TEXT NOT NULL,
          $colunaSenha TEXT NOT NULL
        )
      ''');

    Map<String, dynamic> row = {
      colunaUsuario: 'Alisson',
      colunaSenha: '123456'
    };
    await db.insert(tabelaLogin, row);
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

  Future<List<Tarefa>> buscarTarefas(bool finalizadas) async {
    await iniciarBD();

    int parametro = finalizadas ? 1 : 0;

    final List<Map<String, Object?>> tarefasNoBanco = await _bancoDeDados
        .query(tabelaTarefa, where: '$colunaFinalizada == $parametro');

    List<Tarefa> tarefas = [];

    for (final tarefaMap in tarefasNoBanco) {
      int pId = tarefaMap[colunaId] as int;
      String pTitulo = tarefaMap[colunaTitulo] as String;
      String pData = tarefaMap[colunaData] as String;
      int pFinalizada = tarefaMap[colunaFinalizada] as int;
      int pCategoria = tarefaMap[colunaIdCategoria] as int;

      Categoria categoria = await buscarCategoriaPeloId(pCategoria);
      Tarefa tarefa = Tarefa(
        id: pId,
        titulo: pTitulo,
        data: DateTime.parse(pData),
        finalizada: pFinalizada == 1,
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

  Future<bool> autenticarUsuario(Usuario usuario) async {
    await iniciarBD();

    var autenticado = await _bancoDeDados.query(tabelaLogin,
        where: '$colunaUsuario = ? AND $colunaSenha = ?',
        whereArgs: [usuario.nome, usuario.senha]);

    return autenticado.isNotEmpty;
  }

  Future<void> finalizarTarefa(bool? value, Tarefa tarefa) async {
    await iniciarBD();

    final finalizado = value == true ? 1 : 0;

    Map<String, int> coluna = {colunaFinalizada: finalizado};

    await _bancoDeDados.update(tabelaTarefa, coluna,
        where: '$colunaId = ?', whereArgs: [tarefa.id]);
  }

  Future<List<Tarefa>> buscarTarefasPeloTitulo(
      String value) async {
    await iniciarBD();
    final List<Map<String, Object?>> tarefasNoBanco = await _bancoDeDados
        .query(tabelaTarefa, where: '$colunaTitulo like "%$value%"');

    List<Tarefa> tarefas = [];

    for (final tarefaMap in tarefasNoBanco) {
      int pId = tarefaMap[colunaId] as int;
      String pTitulo = tarefaMap[colunaTitulo] as String;
      String pData = tarefaMap[colunaData] as String;
      int pFinalizada = tarefaMap[colunaFinalizada] as int;
      int pCategoria = tarefaMap[colunaIdCategoria] as int;

      Categoria categoria = await buscarCategoriaPeloId(pCategoria);
      Tarefa tarefa = Tarefa(
        id: pId,
        titulo: pTitulo,
        data: DateTime.parse(pData),
        finalizada: pFinalizada == 1,
        categoria: categoria,
      );

      tarefas.add(tarefa);
    }

    return tarefas;
  }
}
