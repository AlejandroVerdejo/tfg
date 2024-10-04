const lang = {
  "es": {
    "catalog": "Catalogo",
    "profile": "Perfil",
    "profile_activeRents": "Prestamos activos",
    "genres": "Géneros",
    "error": "Error",
    "login": "Iniciar Sesión",
    "register": "Registrarse",
    "user": "Usuario",
    "password": "Contraseña",
    "login_createHere": "¿No tienes cuenta? Creala aquí.",
    "login_loginHere": "¿Ya tienes una cuenta? Inicia sesión aquí.",
    "aviable": "Disponible",
    "not_aviable": "No disponible",
    "state": "Estado",
    "sinopsis": "Sinopsis",
    "title": "Titulo",
    "author": "Autor",
    "editorial": "Editorial",
    "editorials": "Editoriales",
    "date": "Fecha de publicación",
    "pages": "Nº de páginas",
    "language": "Idioma",
    "isbn": "ISBN",
    "settings": "Ajustes",
    "logout": "Cerrar Sesión",
    "lightTheme": "Tema Claro",
    "darkTheme": "Tema Oscuro",
    "filters": "Filtros",
    "age": "Edad de lectura",
    "category": "Categoria",
  }
};

String? getLang(String value) {
  return lang["es"]?[value];
}