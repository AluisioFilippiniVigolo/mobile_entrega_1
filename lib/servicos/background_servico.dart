import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_application/model/cartao.dart';
import 'package:flutter_application/servicos/cartao_servico.dart';
import 'package:flutter_application/servicos/lista_servico.dart';
import 'package:flutter_application/servicos/quadro_servico.dart';
import 'package:logger/logger.dart';

import '../model/Quadro.dart';
import 'notificacao_service.dart';


@pragma('vm:entry-point')
void funcaoDeExecucaoDoAlarme() async {
  Logger().i('${DateTime.now()}} | Buscando os quadros');

  final QuadroServico quadroServico = QuadroServico();
  final CartaoService cartaoServico = CartaoService();
  final ListaServico listaServico = ListaServico();
  final quadros = await quadroServico.buscarQuadros();

  final List<Cartao> listaCartao = [];

  for (Quadro quadro in quadros){
    Logger().i('${DateTime.now()}} | Buscando cartoes para o quadro ${quadro.nome}');
    final lista = await listaServico.buscarListas(quadro.id);
    final cartao = await cartaoServico.buscarCartoes(quadro.id, lista);
    listaCartao.addAll(cartao);
  }

  Logger().i('${DateTime.now()} | Buscando se há cartão com data de vencimento');
  for (Cartao cartao in listaCartao){
    final dataAtual = DateTime.now();

    if (cartao.dataVencimento != null){
      Logger().i('${DateTime.now()} | Achei um cartão com data de vencimento ${cartao.dataVencimento}');
      Duration? tempo = cartao.dataVencimento?.difference(dataAtual);

      Logger().i('${DateTime.now()} | Tempo para vencimento do cartão em dias ${tempo?.inDays}');
      if (tempo?.inDays == 0){
        await NotificationService().showNotificationVencimento(
          'Tarefa próxima do prazo!',
          'A tarefa "${cartao.nome}" está próxima do prazo.',
          cartao.toJson()
        );
      }
    }
  }
}

class BackgroundService {

  void VamosVerSeVai() async {
    await AndroidAlarmManager.periodic(const Duration(minutes: 1)
        , 0,
        funcaoDeExecucaoDoAlarme);
  }
}