import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:logger/logger.dart';
import 'package:flutter_application/main.dart';

class GerenciadorPush {
  final _firebaseMsg = FirebaseMessaging.instance;

  Future<void> iniciar() async {
    NotificationSettings msgCfg = await _firebaseMsg.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    final log = Logger();

    log.i('PERMISSÃO USUÁRIO: ${msgCfg.authorizationStatus}');

    final tokenUsuario = await obterTokenDoUsuario();

    log.i('TOKEN: $tokenUsuario');
    
    configurarIteracaoComNotificacao();
  }

  Future<String?> obterTokenDoUsuario() async {
    return await _firebaseMsg.getToken();
  }

  Future<void> configurarIteracaoComNotificacao() async { 
    //await _firebaseMsg.getInitialMessage().then(processarNotificacao);

    FirebaseMessaging.onMessage.listen(processarNotificacao);

    FirebaseMessaging.onMessageOpenedApp.listen(processarNotificacao);
  }

  void processarNotificacao(RemoteMessage? msg) async {
    if (msg?.data['idCartao'] != '') {
      chaveDeNavegacao.currentState?.pushNamed('/quadros', arguments: msg);  
    } 
  }
}