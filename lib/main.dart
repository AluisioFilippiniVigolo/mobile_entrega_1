
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/firebase_options.dart';
import 'package:flutter_application/servicos/notificacoes.dart';
import 'package:flutter_application/telas/autenticacao.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application/telas/quadros.dart';

final chaveDeNavegacao = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AndroidAlarmManager.initialize();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await GerenciadorPush().iniciar();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Autenticacao(),
      navigatorKey: chaveDeNavegacao,
      routes: {
        '/quadros': (context) => const Quadros(),
      }
    );
  }
}