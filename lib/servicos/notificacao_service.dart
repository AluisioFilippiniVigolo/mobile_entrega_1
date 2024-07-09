import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';
import '../main.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  NotificationService._internal();

  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: funcaoRespostaDaNotificacao);
  }

  void funcaoRespostaDaNotificacao(
      NotificationResponse notificationResponse) async {
    final String? payload = notificationResponse.payload;
    if (notificationResponse.payload != null) {
      Logger().i('notification payload: $payload');
    } else {
      Logger().i('funcaoRespostaDaNotificacao');
    } 

    if ((notificationResponse.id! >= 1000) && (notificationResponse.id! < 2000)) {
      chaveDeNavegacao.currentState?.pushNamed('/cartaoVencimento', arguments: payload);
    }
    else if (notificationResponse.id! >= 2000) {
      chaveDeNavegacao.currentState?.pushNamed('/cartaoCriacao', arguments: payload);
    } else {
      chaveDeNavegacao.currentState?.pushNamed('/aviso', arguments: payload);
    }
  }

  Future<void> showNotificationVencimento(int id, String title, String body, String payload) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      '123',
      'Canal Alerta Vencimento',
      importance: Importance.max,
      priority: Priority.high
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  Future<void> showNotificationCartaoAdicionado(int id, String title, String body, String payload) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      '456',
      'Canal Novo Cartão Adicionado',
      importance: Importance.max,
      priority: Priority.high
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }
}
