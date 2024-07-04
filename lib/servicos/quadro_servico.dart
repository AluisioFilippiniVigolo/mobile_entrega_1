import 'dart:convert';

import '../model/Quadro.dart';
import '../model/trello_acessor.dart';
import 'package:http/http.dart' as http;

class QuadroServico {

  Future<void> cadastrarQuadro(String nomeQuadro) async {
    final url = Uri.parse('${TrelloAcessor.baseUrl}/boards');
    Map<String, dynamic> params = {
      'key': TrelloAcessor.apiKey,
      'token': TrelloAcessor.token,
      'name': nomeQuadro,
      'idOrganization': TrelloAcessor.idOrganization
    };

    final response = await http.post(url, body: params);
    if (response.statusCode != 200) {
      throw Exception('Erro ao cadastrar o quadro.');
    }
  }

  Future<void> deletarQuadro(String idQuadro) async {
    final url = Uri.parse('${TrelloAcessor.baseUrl}/boards/$idQuadro');
    Map<String, dynamic> params = {
      'key': TrelloAcessor.apiKey,
      'token': TrelloAcessor.token,
      'idOrganization': TrelloAcessor.idOrganization
    };

    final response = await http.delete(Uri.https(url.authority, url.path, params));
    if (response.statusCode != 200) {
      throw Exception('Erro ao deletar o quadro.');
    }
  }

  Future<List<Quadro>> buscarQuadros() async {
    final url = Uri.parse('${TrelloAcessor.baseUrl}/members/me');
    Map<String, dynamic> params = {
      'boards': 'open',
      'key': TrelloAcessor.apiKey,
      'token': TrelloAcessor.token,
      'idOrganization': TrelloAcessor.idOrganization
    };

    return http.get(Uri.http(url.authority, url.path, params)).then((value) {
      if (value.statusCode == 200) {
        final data = jsonDecode(value.body);
        final quadros = data['boards'] as List;
        return quadros.map((json) => Quadro.fromJson(json)).toList();
      } else {
        throw Exception('Erro ao buscar as listas.');
      }
    });
  }
}