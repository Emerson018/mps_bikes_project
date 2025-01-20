class Validator {
  Validator._();

    static String? validateName(String? value) {
      final condition = RegExp(r"((\ *)[\wáéíóúñ]+(\ *)+)+");

      if(value != null && value.isEmpty){
        return "Este campo não pode estar vazio.";
      }
      if(value != null && !condition.hasMatch(value)){
        return "Digite um nome válido";
      }
      return null;
    }

   static String? validateEmail(String? value) {
      final condition = RegExp(
        r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?");

      if(value != null && value.isEmpty){
        return "Este campo não pode estar vazio.";
      }
      if(value != null && !condition.hasMatch(value)){
        return "Digite um email válido";
      }
      return null;
    } 

  static String? validatePassword(String? value) {
  // Verifica se o campo está vazio
  if (value == null || value.isEmpty) {
    return "Este campo não pode estar vazio.";
  }

  // Lista para armazenar as mensagens de erro
  List<String> errors = [];

  // Critérios para a senha
  if (!RegExp(r".{8,}").hasMatch(value)) {
    errors.add("A senha deve ter no mínimo 8 caracteres.");
  }
  if (!RegExp(r"(?=.*[A-Z])").hasMatch(value)) {
    errors.add("A senha deve conter pelo menos 1 letra maiúscula.");
  }
  if (!RegExp(r"(?=.*[a-z])").hasMatch(value)) {
    errors.add("A senha deve conter pelo menos 1 letra minúscula.");
  }
  if (!RegExp(r"(?=.*\d)").hasMatch(value)) {
    errors.add("A senha deve conter pelo menos 1 número.");
  }
  if (!RegExp(r"(?=.*[@$!%*?&])").hasMatch(value)) {
    errors.add("A senha deve conter pelo menos 1 caractere especial (@, \$, !, %, *, ?, &).");
  }

  // Retorna as mensagens de erro concatenadas ou null se estiver tudo certo
  return errors.isNotEmpty ? errors.join("\n") : null;
}

    static String? validateConfirmPassword(String? first, String? second) {
      if(first != second){
        return "As senhas não coincidem.";
      }
      return null;
    } 
}