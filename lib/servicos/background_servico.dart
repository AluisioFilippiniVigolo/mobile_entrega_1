import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:logger/logger.dart';

import 'notificacao_service.dart';


@pragma('vm:entry-point')
void funcaoDeExecucaoDoAlarme() async {
  Logger().i('${DateTime.now()}} | Enviando notificação');

  await NotificationService().showNotification(
    'Tarefa próxima do prazo!',
    'A tarefa "${['name']}" está próxima do prazo.',
  );
}


class BackgroundService {

  void VamosVerSeVai() async {
    await AndroidAlarmManager.periodic(const Duration(minutes: 1)
        , 0,
        funcaoDeExecucaoDoAlarme);
  }
}
/*const checkTrelloTasks = "checkTrelloTasks";

@pragma('vm:entry-point')
void backgroundCallback() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case checkTrelloTasks:
        //final backgroundService = BackgroundService();
        //await backgroundService._checkTrelloTasks();

        await NotificationService().showNotification(
          'Tarefa próxima do prazo!',
          'A tarefa "${['name']}" está próxima do prazo.',
        );
        break;
      default:
        print('Task $task not found.');
        break;
    }
    return Future.value(true);
  });
}


class BackgroundService {

  void registerPeriodicTask() {
    Workmanager().registerOneOffTask(
      checkTrelloTasks,
      checkTrelloTasks,
      //initialDelay: const Duration(minutes: 1),
      //frequency: const Duration(minutes: 15),
    );
  }

  Future<void> _checkTrelloTasks() async {
    final QuadroServico quadroServico = QuadroServico();
    //final teste = await quadroServico.buscarQuadros();

    if (true) {
      /*final List tasks = jsonDecode(response.body);
      final now = DateTime.now();

      for (var task in tasks) {
        final dueDate = DateTime.parse(task['due']);
        final difference = dueDate.difference(now).inDays;

        if (difference < 2) {
          await NotificationService().showNotification(
            'Tarefa próxima do prazo!',
            'A tarefa "${task['name']}" está próxima do prazo.',
          );
        }
      }*/
    }
  }
}*/
