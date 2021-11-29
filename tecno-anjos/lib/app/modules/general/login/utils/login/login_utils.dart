class LoginUtils {
  static String convertResponseToString(String response) {
    return response == "Bad credentials"
        ? "Usuário e/ou senha inválidos!"
        : response == "User is disabled"
            ? "Usuário desabilitado!"
            : "Falha interna no servidor: ${response ?? "sem descrição"} ";
  }
}
