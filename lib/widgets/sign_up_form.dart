import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/exceptions/auth_exeception.dart';
import 'package:shop/models/auth.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final Map<String, String> _signUpData = {
    'email': '',
    'password': '',
  };

  bool _isObscure = true;
  bool _isLoading = false;

  void _toggleObscure() {
    setState(() => _isObscure = !_isObscure);
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog.adaptive(
        title: const Text('Ocorreu um erro!'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    _formKey.currentState?.save();

    Auth auth = Provider.of(context, listen: false);

    setState(() => _isLoading = true);

    try {
      await auth.signUp(
        email: _signUpData['email']!,
        password: _signUpData['password']!,
      );
    } on AuthExeception catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog('Ocorreu um erro inesperado!');
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.email),
                border: InputBorder.none,
                filled: true,
                contentPadding: EdgeInsets.all(16),
                hintText: "Digite seu e-mail",
                errorStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                labelStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
              onSaved: (value) => _signUpData['email'] = value ?? '',
              validator: (value) {
                final email = value ?? '';

                if (email.trim().isEmpty || !email.contains('@')) {
                  return 'E-mail inválido';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: TextFormField(
              obscureText: _isObscure,
              controller: _passwordController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock),
                border: InputBorder.none,
                filled: true,
                contentPadding: const EdgeInsets.all(16),
                hintText: "Digite sua senha",
                errorStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                suffixIcon: IconButton(
                  onPressed: _toggleObscure,
                  icon: Icon(
                    _isObscure ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
                labelStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
              onSaved: (value) => _signUpData['password'] = value ?? '',
              validator: (value) {
                final password = value ?? '';

                if (password.isEmpty || password.length < 6) {
                  return 'Senha inválida!';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: TextFormField(
              obscureText: _isObscure,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock),
                border: InputBorder.none,
                filled: true,
                errorStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                contentPadding: const EdgeInsets.all(16),
                hintText: "Confirme sua senha",
                suffixIcon: IconButton(
                  onPressed: _toggleObscure,
                  icon: Icon(
                    _isObscure ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
                labelStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
              validator: (value) {
                final confirmPassword = value ?? '';

                if (_passwordController.text.isEmpty ||
                    _passwordController.text.length < 6) {
                  return 'Senha inválida!';
                }

                if (confirmPassword != _passwordController.text) {
                  return 'Senhas não conferem';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                foregroundColor: Colors.deepPurpleAccent,
                backgroundColor: Colors.deepPurple.shade800,
                elevation: 0,
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 24.0,
                      height: 24.0,
                      child: CircularProgressIndicator.adaptive(
                        backgroundColor: Colors.white,
                      ),
                    )
                  : const Text(
                      "CADASTRAR",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
