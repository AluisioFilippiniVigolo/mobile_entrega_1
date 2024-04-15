import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application/model/usuario.dart';
import 'package:flutter_application/servicos/autenticacao_servico.dart';
import 'package:flutter_application/telas/tarefas.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final autenticacaoServico = AutenticacaoServico();
  String mensagemErro = '';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 148, 147, 147),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.account_circle,
                  size: 100.0,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                    controller: _usuarioController,
                    cursorColor: const Color.fromARGB(255, 253, 254, 255),
                    decoration: const InputDecoration(
                        labelText: 'Usuário',
                        labelStyle: TextStyle(color: Colors.white),
                        prefixIcon: Icon(Icons.person,
                            color: Color.fromARGB(255, 253, 254, 255)),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 253, 254, 255),
                              width: 2.0),
                        )),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'É obrigatório informar um usuário.';
                      }
                      return null;
                    }),
                const SizedBox(height: 20.0),
                TextFormField(
                    controller: _senhaController,
                    obscureText: true,
                    cursorColor: const Color.fromARGB(255, 253, 254, 255),
                    decoration: const InputDecoration(
                      labelText: 'Senha',
                      labelStyle: TextStyle(color: Colors.white),
                      prefixIcon: Icon(Icons.lock,
                          color: Color.fromARGB(255, 253, 254, 255)),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 253, 254, 255),
                            width: 2.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'É obrigatório informar uma senha.';
                      }
                      return null;
                    }),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () async {

                    if (_formKey.currentState!.validate()) {
                      var usuario = Usuario(
                          nome: _usuarioController.text,
                          senha: _senhaController.text);

                      bool autenticado = await autenticacaoServico.autenticar(
                        usuario,
                      );

                      if (autenticado) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Tarefas(),
                          ),
                        );
                      }else{
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                        fontSize: 18, color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                ),
                const SizedBox(height: 10.0),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Criar conta',
                    style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                ),
              Text(
                mensagemErro,
                style: TextStyle(color: Colors.red),
                )
              ],
            ),
          ),
        ),
      );
  }
}
