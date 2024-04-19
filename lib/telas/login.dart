import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application/model/usuario.dart';
import 'package:flutter_application/servicos/autenticacao_servico.dart';
import 'package:flutter_application/telas/tarefas.dart';

class Login extends StatefulWidget {
  const Login({Key? key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final autenticacaoServico = AutenticacaoServico();
  String mensagemErro = '';
  bool _loginClicado = false;

  @override
  void dispose() {
    _usuarioController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              autovalidateMode: _loginClicado
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.account_circle,
                    size: 100.0,
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    controller: _usuarioController,
                    decoration: const InputDecoration(
                      labelText: 'Usuário',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 2.0),
                      ),
                    ),
                    validator: (value) {
                      if (_loginClicado && (value == null || value.isEmpty)) {
                        return 'É obrigatório informar um usuário.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    controller: _senhaController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Senha',
                      prefixIcon: Icon(
                        Icons.lock,
                      ),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 0, 0, 0),
                          width: 2.0,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (_loginClicado && (value == null || value.isEmpty)) {
                        return 'É obrigatório informar uma senha.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _loginClicado = true;
                        mensagemErro = '';
                      });
                      if (_formKey.currentState!.validate()) {
                        var usuario = Usuario(
                          nome: _usuarioController.text,
                          senha: _senhaController.text,
                        );

                        bool autenticado =
                            await autenticacaoServico.autenticar(usuario);

                        if (autenticado) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Tarefas(),
                            ),
                          );
                        } else {
                          setState(() {
                            mensagemErro = 'usuário/senha incorretos';
                          });

                          Future.delayed(const Duration(seconds: 5), () {
                            setState(() {
                              mensagemErro = '';
                            });
                          });
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                          fontSize: 18, color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    mensagemErro,
                    style: TextStyle(color: Colors.red),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
