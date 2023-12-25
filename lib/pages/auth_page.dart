import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shop/widgets/sign_in_form.dart';
import 'package:shop/widgets/sign_up_form.dart';

enum AuthMode { signUp, signIn }

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  AuthMode _authMode = AuthMode.signIn;

  void _switchAuthMode() {
    setState(() {
      _authMode =
          _authMode == AuthMode.signIn ? AuthMode.signUp : AuthMode.signIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.deepPurple.shade900,
              Colors.deepPurple.shade300,
              Colors.deepPurpleAccent,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          image: DecorationImage(
            alignment: _authMode == AuthMode.signIn
                ? Alignment.topRight
                : Alignment.topLeft,
            image: const AssetImage('assets/images/bg-auth-asset.jpeg'),
            fit: BoxFit.cover,
            opacity: 0.1,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "My Shop",
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    _authMode == AuthMode.signIn
                        ? "Faça login para continuar"
                        : "Cadastre-se para usar o app",
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 36),
                  Visibility(
                    visible: _authMode == AuthMode.signIn,
                    replacement: const SignUpForm(),
                    child: const SignInForm(),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: TextButton(
                      onPressed: _switchAuthMode,
                      child: Text(
                        _authMode == AuthMode.signIn
                            ? "Não tem conta? Cadastre-se"
                            : "Já tem conta? Faça login",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
