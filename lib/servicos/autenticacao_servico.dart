import 'package:flutter_application/bd/banco_helper.dart';
import 'package:flutter_application/model/usuario.dart';

class AutenticacaoServico {
  final db = BancoHelper();

  Future<bool> autenticar(Usuario usuario) async {
    return await db.autenticarUsuario(usuario);
  }
}
