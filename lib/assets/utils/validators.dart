//Classe contendo funcoes de validacao para inputs

abstract class Validators {
  static String validateEmail(String value) {
    if (value.isEmpty) return 'Digite seu email.';
    final RegExp emailExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (!emailExp.hasMatch(value)) return 'Endereço de email invalido.';
    return null;
  }

  static String validatePassword(String value) {
    if (value.isEmpty) return 'Digite sua senha';
    if (value.length < 8) return 'Sua senha deve ter pelo menos 8 caracteres';
    return null;
  }
}
