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

class _AuthPageState extends State<AuthPage> with TickerProviderStateMixin {
  late AnimationController _animationSignInController;
  late Animation<double> _opacitySignInAnimation;

  late AnimationController _animationSignUpController;
  late Animation<double> _opacitySignUpAnimation;

  late AnimationController _animationBgController;
  late Animation<AlignmentGeometry> _opacityBgAnimation;

  AuthMode _authMode = AuthMode.signIn;

  @override
  void initState() {
    super.initState();

    _animationSignInController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _opacitySignInAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationSignInController,
        curve: Curves.linear,
      ),
    );

    _animationSignUpController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _opacitySignUpAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationSignUpController,
        curve: Curves.linear,
      ),
    );

    _animationBgController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _opacityBgAnimation = AlignmentTween(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).animate(
      CurvedAnimation(
        parent: _animationBgController,
        curve: Curves.fastOutSlowIn,
      ),
    );

    _animationSignInController.forward();

    _opacitySignInAnimation.addListener(() {
      setState(() {});
    });
  }

  void _switchAuthMode() {
    setState(() {
      _authMode =
          _authMode == AuthMode.signIn ? AuthMode.signUp : AuthMode.signIn;
    });

    if (_authMode == AuthMode.signIn) {
      _animationSignUpController.reverse();
      _animationSignInController.forward();
      _animationBgController.reverse();
    } else {
      _animationSignInController.reverse();
      _animationSignUpController.forward();
      _animationBgController.forward();
    }
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
            alignment: _opacityBgAnimation.value,
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
                    replacement: Opacity(
                      opacity: _opacitySignUpAnimation.value,
                      child: const SignUpForm(),
                    ),
                    child: Opacity(
                      opacity: _opacitySignInAnimation.value,
                      child: const SignInForm(),
                    ),
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
