import 'package:flutter/material.dart';

import '../bd/banco_helper.dart';
import '../model/categoria.dart';
import '../model/tarefa.dart';

class TarefasServico {
  final db = BancoHelper();

  Future<List<DropdownMenuItem<String>>>  listarCategorias() async {
    List<Categoria> listaCategorias = await db.buscarCategorias();
    List<DropdownMenuItem<String>> listaDropDown = [];

    listaDropDown.add(
        const DropdownMenuItem(
          value: null,
          child: Text('Mostrar Todos'),
        )
    );

    for (Categoria categoria in listaCategorias) {
      listaDropDown.add(
        DropdownMenuItem(
            value: categoria.categoria,
            child: Text(categoria.categoria ?? '')
        ),
      );
    }
    return listaDropDown;
  }

  Future<List<Tarefa>> listarTarefas(bool finalizadas) async {
    return await db.buscarTarefas(finalizadas);
  }

  Future<void> finalizarTarefa(bool? value, Tarefa tarefa) async {
    await db.finalizarTarefa(value, tarefa);
  }

}