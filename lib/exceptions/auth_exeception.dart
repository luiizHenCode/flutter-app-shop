class AuthExeception implements Exception {
  static const Map<String, String> errors = {
    'EMAIL_EXISTS': 'E-mail já cadastrado',
    'OPERATION_NOT_ALLOWED': 'Operação não permitida!',
    'TOO_MANY_ATTEMPTS_TRY_LATER': 'Muitas tentativas, tente mais tarde',
    'EMAIL_NOT_FOUND': 'E-mail não encontrado',
    'INVALID_PASSWORD': 'Senha inválida',
    'USER_DISABLED': 'Usuário desativado',
    'INVALID_LOGIN_CREDENTIALS': 'E-mail e/ou senha inválidos.',
  };
  final String key;

  const AuthExeception(this.key);

  @override
  String toString() {
    return errors[key] ?? 'Ocorreu um erro na autenticação!';
  }
}
