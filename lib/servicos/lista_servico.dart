import 'dart:convert';

import '../model/lista.dart';
import 'package:http/http.dart' as http;

import '../model/trello_acessor.dart';

class ListaServico{

  Future<void> cadastrarLista(Lista lista, String idQuadro) async {
    final url = Uri.parse('${TrelloAcessor.baseUrl}/lists');
    Map<String, dynamic> params = {
      'key': TrelloAcessor.apiKey,
      'token': TrelloAcessor.token,
      'name': lista.nome,
      'idBoard': idQuadro,
      'idOrganization': TrelloAcessor.idOrganization
    };
    http.post(Uri.https(url.authority, url.path, params)).then((value) {
      if (value.statusCode != 200) {
        throw Exception('Erro ao cadastrar a lista.');
      }
    });
  }

  Future<void> arquivarLista(Lista lista) async {
    final String? idLista = lista.id;
    final url = Uri.parse('${TrelloAcessor.baseUrl}/lists/$idLista/closed');
    Map<String, dynamic> params = {
      'key': TrelloAcessor.apiKey,
      'token': TrelloAcessor.token,
      'value': 'true',
      'idOrganization': TrelloAcessor.idOrganization
    };
    http.put(Uri.https(url.authority, url.path, params)).then((value) {
      if (value.statusCode != 200) {
        throw Exception('Erro ao arquivar a lista.');
      }
    });
  }

  Future<List<Lista>> buscarListas(String idQuadro) {
    final url = Uri.parse('${TrelloAcessor.baseUrl}/boards/$idQuadro/lists');
    Map<String, dynamic> params = {
      'key': TrelloAcessor.apiKey,
      'token': TrelloAcessor.token,
      'idOrganization': TrelloAcessor.idOrganization
    };
    return http.get(Uri.http(url.authority, url.path, params)).then((value) {
      if (value.statusCode == 200) {
        final todasListas = jsonDecode(value.body) as List;
        return todasListas.map((regPost) {
          return Lista.fromJson(regPost);
        }).toList();
      } else {
        throw Exception('Erro ao buscar as listas.');
      }
    });
  }

  Future<void> atualizarLista(Lista lista) async {
    final String? idLista = lista.id;
    final url = Uri.parse('${TrelloAcessor.baseUrl}/lists/$idLista/name');
    Map<String, dynamic> params = {
      'key': TrelloAcessor.apiKey,
      'token': TrelloAcessor.token,
      'value': lista.nome,
      'idOrganization': TrelloAcessor.idOrganization
    };
    http.put(Uri.https(url.authority, url.path, params)).then((value) {
      if (value.statusCode != 200) {
        throw Exception('Erro ao atualizar a lista.');
      }
    });
  }
}