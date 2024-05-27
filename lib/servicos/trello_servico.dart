import 'dart:convert';
import 'dart:async';
import 'package:flutter_application/model/lista.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application/model/cartao.dart';

import '../model/Quadro.dart';

class TrelloService {
  //dados da API

  Future<List<Cartao>> buscarCartoes(
      String idQuadro, List<Lista> listas) async {
    final url = Uri.parse('$_baseUrl/boards/$idQuadro/cards');
    Map<String, dynamic> params = {
      'key': _apiKey,
      'token': _token,
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
      'idList': cartao.lista.id
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
      'idBoard': idQuadro
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
