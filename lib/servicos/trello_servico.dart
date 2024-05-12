import 'dart:convert';
import 'dart:async';
import 'package:flutter_application/model/lista.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application/model/cartao.dart';

class TrelloService {


  Future<List<Cartao>> buscarCartoes() {
    final url = Uri.parse('$_baseUrl/boards/$_idQuadro/cards');
    Map<String, dynamic> params = {
      'key': _apiKey,
      'token': _token,
    };
    return http.get(Uri.http(url.authority, url.path, params)).then((value) {
      if (value.statusCode == 200) {
        final todosCartoes = jsonDecode(value.body) as List;
        return todosCartoes.map((regPost) {
          return Cartao.fromJson(regPost);
        }).toList();
      } else {
        throw Exception('Erro ao buscar os cartões.');
      }
    });
  }

  Future<List<Lista>> buscarListas() {
    final url = Uri.parse('$_baseUrl/boards/$_idQuadro/lists');
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
      'idList': cartao.lista?.id
    };
    http.post(Uri.http(url.authority, url.path, params)).then((value) {
      if (value.statusCode == 200) {
        throw Exception('Erro ao cadastrar o cartão.');
      }
    });
  }

  Future<void> cadastrarLista(Lista lista) async {
    final url = Uri.parse('$_baseUrl/lists');
    Map<String, dynamic> params = {
      'key': _apiKey,
      'token': _token,
      'name': lista.nome,
      'idBoard': _idQuadro
    };
    http.post(Uri.http(url.authority, url.path, params)).then((value) {
      if (value.statusCode == 200) {
        throw Exception('Erro ao cadastrar a lista.');
      }
    });
  }
}
