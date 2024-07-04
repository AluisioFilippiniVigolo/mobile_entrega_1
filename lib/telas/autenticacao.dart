import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application/telas/quadros.dart';
import 'package:local_auth/local_auth.dart';

enum _SupportState {
  unknown,
  supported,
  unsupported,
}

class Autenticacao extends StatefulWidget {
  const Autenticacao({Key? key}) : super(key: key);

  @override
  _AutenticacaoState createState() => _AutenticacaoState();
}

class _AutenticacaoState extends State<Autenticacao> {
  final LocalAuthentication auth = LocalAuthentication();
  _SupportState _supportState = _SupportState.unknown;
  String _authorized = 'Sem permissão';
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() => _supportState = isSupported
          ? _SupportState.supported
          : _SupportState.unsupported),
    );
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Em processo de autenticação';
      });
      authenticated = await auth.authenticate(
        localizedReason: 'Por favor, autentique-se para continuar',
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),
      );
      setState(() {
        _isAuthenticating = false;
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Ocorreu um erro: ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    setState(() => _authorized = authenticated ? 'Autorizado' : 'Não autorizado');

    if (authenticated) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Quadros()),
      );
    }
  }

  Future<void> _cancelAuthentication() async {
    await auth.stopAuthentication();
    setState(() => _isAuthenticating = false);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey[200],
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Spacer(),
                Icon(
                  Icons.fingerprint,
                  size: 100,
                  color: Colors.blue,
                ),
                const SizedBox(height: 20),
                if (_supportState == _SupportState.unknown)
                  const CircularProgressIndicator()
                else if (_supportState == _SupportState.supported)
                  const Text(
                    'Autentique-se',
                    style: TextStyle(fontSize: 18),
                  )
                else
                  const Text(
                    'Autenticação não suportada',
                    style: TextStyle(fontSize: 18),
                  ),
                const SizedBox(height: 20),
                const Spacer(),
                if (_isAuthenticating)
                  ElevatedButton(
                    onPressed: _cancelAuthentication,
                    child: const Text('Cancelar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                    ),
                  )
                else
                  ElevatedButton(
                    onPressed: _authenticate,
                    child: const Text('Autenticar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                    ),
                  ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


