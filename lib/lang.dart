const lang = {
  "es": {
    "catalog": "Catálogo",
    "profile": "Perfil",
    "userActiveRents": "Préstamos activos",
    "genres": "Géneros",
    "genre": "Género",
    "error": "Error",
    "login": "Iniciar Sesión",
    "register": "Registrarse",
    "user": "Usuario",
    "username": "Nombre de usuario",
    "password": "Contraseña",
    "login_createHere": "¿No tienes cuenta? Créala aquí.",
    "login_loginHere": "¿Ya tienes una cuenta? Inicia sesión aquí.",
    "aviable": "Disponible",
    "notAviable": "No disponible",
    "state": "Estado",
    "sinopsis": "Sinopsis",
    "title": "Título",
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
    "category": "Categoría",
    "categories": "Categorías",
    "languages": "Idiomas",
    "cleanFilters": "Eliminar filtros",
    "hScrollTooltip":
        "Shift + rueda del ratón para desplazarte horizontalmente",
    "rentDifDays": "Días restantes",
    "espectedAviable": "Disponibilidad esperada",
    "wishlist": "Lista de deseados",
    "waitlist": "Recordatorios",
    "deleteFromList": "Eliminar elemento de la lista",
    "id": "ID",
    "popularBooks": "Libros más populares",
    "email": "Correo electrónico",
    "alertDialog-confirm": "¿Estás seguro?",
    "deleteBookListDialog-title": "Se eliminará el libro de la lista",
    "deleteBookListDialog-true": "Eliminar",
    "deleteBookListDialog-false": "Cancelar",
    "deleteBookDialog-title": "Se eliminará el libro",
    "deleteAllBookDialog-title": "Se eliminarán todos los libros como este",
    "wishListToggle-add": "Libro añadido a la lista de deseados",
    "wishListToggle-del": "Libro eliminado de la lista de deseados",
    "waitListToggle-add": "Libro añadido a recordatorios",
    "waitListToggle-del": "Libro eliminado de recordatorios",
    "rentBook": "Nuevo préstamo",
    "bookId": "Identificador del libro",
    "userId": "Identificador del usuario",
    "returnDate": "Fecha de devolución",
    "rentBookLoadBook": "Cargar libro",
    "rentBookLoadBook-error": "No se ha encontrado el libro",
    "rentBookLoadUser": "Cargar usuario",
    "rentBookLoadUser-error":
        "No se ha encontrado el usuario o no es un usuario válido",
    "rentBookAction": "Realizar préstamo",
    "rentBook-success": "Préstamo realizado correctamente",
    "rentBook-error": "Datos incorrectos para realizar el préstamo",
    "addBook-success": "Libro añadido correctamente",
    "addBook": "Añadir libro",
    "addTags": "Añadir etiquetas",
    "addTag-genre": "Añadir género",
    "addTag-editorial": "Añadir editorial",
    "addTag-category": "Añadir categoría",
    "addTag-language": "Añadir idioma",
    "loadBook": "Cargar libro existente",
    "selectDialogButton": "Aceptar",
    "formError-email":
        "Este campo debe contener una dirección de correo electrónico",
    "formError-required": "Este campo es obligatorio",
    "formError-minLength": "La contraseña debe tener por lo menos 8 caracteres",
    "formError-numeric": "Este campo solo puede contener valores numéricos",
    "formError-usedEmail": "Correo electrónico en uso",
    "loginError": "Datos de inicio de sesión incorrectos",
    "registerError": "Datos de registro incorrectos",
    "users": "Usuarios",
    "active": "Activo",
    "notActive": "Inactivo",
    "addUser": "Añadir usuario",
    "worker": "Trabajador",
    "admin": "Administrador",
    "level": "Nivel",
    "editBook": "Editar libro",
    "saveBook": "Guardar libro",
    "returnBook": "Devolver libro",
    "waitlistReminder": "Hay libros de tus recordatorios disponibles",
    "waitlistShortcut": "Pulsa aquí para ver tus recordatorios",
    "returnBookAction": "Devolver",
    // ^^ Corregido ^^
    "returnBook-success": "Se ha devuelto el libro correctamente",
    "returnBook-select": "Selecciona un libro para devolver",
    "save": "Guardar",
    "imageSelect": "Selecciona una imagen",
    "deleteUser": "Se eliminara al siguiente usuario",
    "confirmation": "¿Estas seguro?",
    "changeAviability": "Cambiar disponibilidad",
    "deleteBook": "Eliminar este libro",
    "deleteAllBooks": "Eliminar todos los libros como este",
    "noActiveRents": "No tienes ningun prestamo activo",
    "contactUs": "Contactanos",
    "home": "Inicio",
    "send": "Enviar",
    "solve": "Marcar como solucionado",
    "contacts": "Soporte",
    "comments": "Comentarios",
    "prio-on": "Dar prioridad",
    "prio-off": "Quitar prioridad",
    "deleteCommentDialog-title": "Se eliminara el siguiente comentario",
    "content": "Contenido",
    "type": "Tipo",
    "send-confirmation": "Se ha enviado correctamente",
    "catalog-hint": "Escribe un titulo para buscarlo",
  }
};

String getLang(String value) {
  return "${lang["es"]?[value]}";
}
