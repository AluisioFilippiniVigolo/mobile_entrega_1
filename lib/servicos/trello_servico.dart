import 'dart:convert';
import 'dart:async';
import 'package:flutter_application/model/lista.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application/model/cartao.dart';

import '../model/Quadro.dart';

class TrelloService {


  Future<void> cadastrarQuadro(String nomeQuadro) async {
    final url = Uri.parse('$_baseUrl/boards');
    Map<String, dynamic> params = {
      'key': _apiKey,
      'token': _token,
      'name': nomeQuadro,
      'idOrganization': _idOrganization
    };

    final response = await http.post(Uri.https(url.authority, url.path, params));
    if (response.statusCode != 200) {
      throw Exception('Erro ao cadastrar o quadro.');
    }
  }

  Future<void> deletarQuadro(String idQuadro) async {
    final url = Uri.parse('$_baseUrl/boards/$idQuadro');
    Map<String, dynamic> params = {
      'key': _apiKey,
      'token': _token,
      'idOrganization': _idOrganization
    };

    final response = await http.delete(Uri.https(url.authority, url.path, params));
    if (response.statusCode != 200) {
      throw Exception('Erro ao deletar o quadro.');
    }
  }


  Future<List<Cartao>> buscarCartoes(
      String idQuadro, List<Lista> listas) async {
    final url = Uri.parse('$_baseUrl/boards/$idQuadro/cards');
    Map<String, dynamic> params = {
      'key': _apiKey,
      'token': _token,
      'idOrganization': _idOrganization
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

  Future<List<Lista>> buscarListas(String idQuadro) {
    final url = Uri.parse('$_baseUrl/boards/$idQuadro/lists');
    Map<String, dynamic> params = {
      'key': _apiKey,
      'token': _token,
      'idOrganization': _idOrganization
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

  Future<void> cadastrarCartao(Cartao cartao) async {
    final url = Uri.parse('$_baseUrl/cards');
    Map<String, dynamic> params = {
      'key': _apiKey,
      'token': _token,
      'name': cartao.nome,
      'desc': cartao.descricao,
      'idList': cartao.lista.id,
      'idOrganization': _idOrganization
    };
    http.post(Uri.https(url.authority, url.path, params)).then((value) {
      if (value.statusCode != 200) {
        throw Exception('Erro ao cadastrar o cartão.');
      }
    });
  }

  Future<void> cadastrarLista(Lista lista, String idQuadro) async {
    final url = Uri.parse('$_baseUrl/lists');
    Map<String, dynamic> params = {
      'key': _apiKey,
      'token': _token,
      'name': lista.nome,
      'idBoard': idQuadro,
      'idOrganization': _idOrganization
    };
    http.post(Uri.https(url.authority, url.path, params)).then((value) {
      if (value.statusCode != 200) {
        throw Exception('Erro ao cadastrar a lista.');
      }
    });
  }

  Future<List<Quadro>> buscarQuadros() async {
    final url = Uri.parse('$_baseUrl/members/me');
    Map<String, dynamic> params = {
      'boards': 'open',
      'key': _apiKey,
      'token': _token,
      'idOrganization': _idOrganization
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

  Future<void> atualizarCartao(Cartao cartao) async {
    final String? idCartao = cartao.id;
    final url = Uri.parse('$_baseUrl/cards/$idCartao');
    Map<String, dynamic> params = {
      'key': _apiKey,
      'token': _token,
      'name': cartao.nome,
      'desc': cartao.descricao,
      'idOrganization': _idOrganization
    };
    http.put(Uri.https(url.authority, url.path, params)).then((value) {
      if (value.statusCode != 200) {
        throw Exception('Erro ao atualizar o cartão.');
      }
    });
  }

  Future<void> excluirCartao(Cartao cartao) async {
    final String? idCartao = cartao.id;
    final url = Uri.parse('$_baseUrl/cards/$idCartao');
    Map<String, dynamic> params = {
      'key': _apiKey,
      'token': _token,
      'name': cartao.nome,
      'desc': cartao.descricao,
      'idOrganization': _idOrganization
    };
    http.delete(Uri.https(url.authority, url.path, params)).then((value) {
      if (value.statusCode != 200) {
        throw Exception('Erro ao excluir o cartão.');
      }
    });
  }
}
