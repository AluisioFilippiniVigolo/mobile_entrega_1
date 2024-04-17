import 'dart:ffi';

import 'package:flutter/material.dart';

import '../bd/banco_helper.dart';
import '../model/categoria.dart';
import '../model/tarefa.dart';

class CadastroTarefasServico {
  final db = BancoHelper();

  Future<List<DropdownMenuItem<int>>>  listarCategorias() async {
    List<Categoria> listaCategorias = await db.buscarCategorias();
    List<DropdownMenuItem<int>> listaDropDown = [];

    for (Categoria categoria in listaCategorias) {
      listaDropDown.add(
        DropdownMenuItem(
            value: categoria.id,
            child: Text(categoria.categoria ?? '')
        ),
      );
    }
    return listaDropDown;
  }

}