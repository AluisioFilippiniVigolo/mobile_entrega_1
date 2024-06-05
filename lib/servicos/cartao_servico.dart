import 'dart:convert';
import 'dart:async';
import 'package:flutter_application/model/lista.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application/model/cartao.dart';

import '../model/trello_acessor.dart';

class CartaoService {

  Future<void> cadastrarCartao(Cartao cartao) async {
    final url = Uri.parse('${TrelloAcessor.baseUrl}/cards');
    Map<String, dynamic> params = {
      'key': TrelloAcessor.apiKey,
      'token': TrelloAcessor.token,
      'name': cartao.nome,
      'desc': cartao.descricao,
      'idList': cartao.lista.id,
      'idOrganization': TrelloAcessor.idOrganization
    };
    http.post(Uri.https(url.authority, url.path, params)).then((value) {
      if (value.statusCode != 200) {
        throw Exception('Erro ao cadastrar o cartão.');
      }
    });
  }

  Future<void> excluirCartao(Cartao cartao) async {
    final String? idCartao = cartao.id;
    final url = Uri.parse('${TrelloAcessor.baseUrl}/cards/$idCartao');
    Map<String, dynamic> params = {
      'key': TrelloAcessor.apiKey,
      'token': TrelloAcessor.token,
      'name': cartao.nome,
      'desc': cartao.descricao,
      'idOrganization': TrelloAcessor.idOrganization
    };
    http.delete(Uri.https(url.authority, url.path, params)).then((value) {
      if (value.statusCode != 200) {
        throw Exception('Erro ao excluir o cartão.');
      }
    });
  }

  Future<List<Cartao>> buscarCartoes(String idQuadro, List<Lista> listas) async {
    final url = Uri.parse('${TrelloAcessor.baseUrl}/boards/$idQuadro/cards');
    Map<String, dynamic> params = {
      'key': TrelloAcessor.apiKey,
      'token': TrelloAcessor.token,
      'idOrganization': TrelloAcessor.idOrganization
    };
    final response = await http.get(Uri.http(url.authority, url.path, params));
    if (response.statusCode == 200) {
      final cartoes = jsonDecode(response.body) as List;
      final mapaListas = {for (var lista in listas) lista.id: lista};
      return cartoes.map((regCartao) {
        Lista lista = mapaListas[regCartao['idList']]!;
        return Cartao(
          id: regCartao['id'],
          nome: regCartao['name'],
          descricao: regCartao['desc'],
          lista: lista,
        );
      }).toList();
    } else {
      throw Exception('Erro ao buscar os cartões.');
    }
  }

  Future<void> atualizarCartao(Cartao cartao) async {
    final String? idCartao = cartao.id;
    final url = Uri.parse('${TrelloAcessor.baseUrl}/cards/$idCartao');
    Map<String, dynamic> params = {
      'key': TrelloAcessor.apiKey,
      'token': TrelloAcessor.token,
      'name': cartao.nome,
      'desc': cartao.descricao,
      'idOrganization': TrelloAcessor.idOrganization
    };
    http.put(Uri.https(url.authority, url.path, params)).then((value) {
      if (value.statusCode != 200) {
        throw Exception('Erro ao atualizar o cartão.');
      }
    });
  }
}
