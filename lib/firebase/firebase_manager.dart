import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

FirebaseFirestore db = FirebaseFirestore.instance;
final storage = FirebaseStorage.instance;

class FirestoreManager {
  //? |                   |
  //? | GESTION DE LIBROS |
  //? |                   |

  // * Devolvera la lista de libros
  Future<Map<String, dynamic>> getBooks() async {
    Map<String, dynamic> books = {};

    // Carga la Coleccion "Books"
    await db.collection("Books").get().then((event) {
      // Recorre los Documentos
      for (var doc in event.docs) {
        // Excluye los documentos "Tags" y "Popularity"
        if (doc.id != "Tags" && doc.id != "Popularity") {
          // Introduce los Documentos de los libros
          books[doc.id] = doc.data();
        }
      }
    });
    return books;
  }

  // * Devolvera la lista de libros uniendo los datos de los duplicados
  Future<Map<String, dynamic>> getMergedBooks() async {
    StorageManager storageManager = StorageManager();

    // Obtiene los libros
    Map<String, dynamic> books = await getBooks();

    Map<String, dynamic> result = {};

    // Recorre cada Documento
    for (var claveExterna in books.keys) {
      // Valor combinado para "aviable"
      bool valorCombinado = false;

      Map<String, dynamic> libroCombinado = {};

      // Carga los libros
      var subMapa = books[claveExterna];
      // Recorre los libros del Documento
      for (var claveInterna in subMapa.keys) {
        // Carga el libro
        var objeto = subMapa[claveInterna];
        // Actualiza el valor del campo combinado en caso de que sea true
        valorCombinado = valorCombinado || objeto["aviable"];

        // Si el libro no se ha cargado en libroCombinado
        if (libroCombinado.isEmpty) {
          // Introduce la imagen
          objeto["image"] = await storageManager.getImage(objeto["isbn"]);
          // Carga la imagen
          libroCombinado = objeto;
        }
      }

      // Introduce el valor combinado
      libroCombinado["aviable"] = valorCombinado;
      // Carga el libro con los datos combinados
      result[claveExterna] = libroCombinado;
    }

    return result;
  }

  // * Devolvera un libro uniendo los datos de los duplicados
  Future<Map<String, dynamic>> getMergedBook(String key) async {
    StorageManager storageManager = StorageManager();

    Map<String, dynamic> book = {};

    // Obtiene los datos del documento del libro
    DocumentSnapshot doc = await db.collection("Books").doc(key).get();
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // Si el documento contiene mas de 1 libro
    if (data.length > 1) {
      // Valor combinado para "aviable"
      bool valorCombinado = false;
      // Recorre cada libro
      for (var claveInterna in data.keys) {
        // Carga el libro
        var objeto = data[claveInterna];
        // Actualiza el valor del campo combinado en caso de que sea true
        valorCombinado = valorCombinado || objeto["aviable"];

        // Si el libro no se ha cargado todavia en book
        if (book.isEmpty) {
          // Introduce la imagen
          objeto["image"] = await storageManager.getImage(objeto["isbn"]);
          // Carga en libro
          book = objeto;
        }
      }

      // Introduce el valor combinado
      book["aviable"] = valorCombinado;
    } else {
      // Carga el libro
      book = data["00001"];
      // Introduce la imagen
      book["image"] = await storageManager.getImage(book["isbn"]);
    }

    return book;
  }

  // * Devolvera la lista de libros que se encuentren en la lista con sus datos unidos
  Future<Map<String, dynamic>> getMergedBooksList(List<dynamic> list) async {
    StorageManager storageManager = StorageManager();

    Map<String, dynamic> booklist = {};

    // Recorre la lista con los identificadores de los libros
    for (String bookid in list) {
      // Carga los datos del libro
      Map<String, dynamic> book = await getMergedBook(bookid);
      // Introduce la imagen
      book["image"] = await storageManager.getImage(book["isbn"]);
      // Introduce el libro en la lista
      booklist[book["isbn"]] = book;
    }

    return booklist;
  }

  // * Devolvera la lista de libros sin unir los datos de los duplicados
  Future<Map<String, dynamic>> getUnMergedBooks() async {
    StorageManager storageManager = StorageManager();

    // Obtiene los libros
    Map<String, dynamic> books = await getBooks();

    Map<String, dynamic> result = {};

    // Recorre Documento
    for (var claveExterna in books.keys) {
      // Carga los libros de ese Documento
      var subMapa = books[claveExterna];

      // Recorre cada libro
      for (var claveInterna in subMapa.keys) {
        // Carga el libro
        var objeto = subMapa[claveInterna];
        // Introduce la imagen
        objeto["image"] = await storageManager.getImage(objeto["isbn"]);
        // Introduce el libro con su ID combinado como clave
        result[objeto["id"]] = objeto;
      }
    }

    return result;
  }

  // * Devolvera un libro sin unir los datos de los duplicados
  Future<Map<String, dynamic>> getUnMergedBook(String bookId) async {
    StorageManager storageManager = StorageManager();

    // Divide el ID conjunto del libro para sacar el ISBN y el ID individual
    var splitted = bookId.split("-");
    String isbn = splitted[0];
    String id = splitted[1];

    Map<String, dynamic> book = {};
    // Obtiene los datos del Documento del libro
    DocumentSnapshot doc = await db.collection("Books").doc(isbn).get();
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    // Carga los datos del libro individual
    book = data[id];
    // Introduce la imagen
    book["image"] = await storageManager.getImage(book["isbn"]);

    return book;
  }

  // ?

  //? |                     |
  //? | GESTION DE USUARIOS |
  //? |                     |

  // * Devolvera true/false segun si el usuario existe o no
  Future<bool> checkUser(String email) async {
    // Carga el Documento del usuario
    DocumentSnapshot doc = await db.collection("Users").doc(email).get();
    // Comprueba si existe
    return doc.exists;
  }

  // * Devolvera true/false segun si la contraseña coincide con la del usuario o no
  Future<bool> checkPassword(String email, String password) async {
    // Carga el Documento del usuario
    DocumentSnapshot doc = await db.collection("Users").doc(email).get();
    // Carga la contraseña del usuario
    String data = doc.get("password");
    // Comprueba si coincide
    return data == password;
  }

  // * Devolvera un mapa con los datos del usuario
  Future<Map<String, dynamic>> getUser(String email) async {
    // Carga el Documento del usuario
    log("log-user1");
    log("email: $email");
    DocumentSnapshot doc = await db.collection("Users").doc(email).get();
    log("id: ${doc.id}");
    log("log-user2");
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    // Carga los datos del usuario
    log("log-user3");
    Map<String, dynamic> user = {
      "username": data["username"],
      "password": data["password"],
      "email": data["email"],
      "level": data["level"],
    };
    log("log-user4");
    return user;
  }

  // ?

  //? |                       |
  //? | GESTION DE ETIQUETAS  |
  //? |                       |

  // * Devolvera la lista de categorias registradas
  Future<List<String>> getCategories() async {
    // Carga el Documento de los tags
    DocumentSnapshot doc = await db.collection("Books").doc("Tags").get();
    // Carga las categorias
    List<dynamic> data = doc.get("categories");
    // Ordena por orden alfabetico
    data.sort();
    return data.cast<String>().toList();
  }

  // * Devolvera la lista de generos registrados
  Future<List<String>> getGenres() async {
    // Carga el Documento de los tags
    DocumentSnapshot doc = await db.collection("Books").doc("Tags").get();
    // Carga los generos
    List<dynamic> data = doc.get("genres");
    // Ordena por orden alfabetico
    data.sort();
    return data.cast<String>().toList();
  }

  // * Devolvera la lista de editoriales registradas
  Future<List<String>> getEditorials() async {
    // Carga el Documento de los tags
    DocumentSnapshot doc = await db.collection("Books").doc("Tags").get();
    // Carga las editoriales
    List<dynamic> data = doc.get("editorials");
    // Ordena por orden alfabetico
    data.sort();
    return data.cast<String>().toList();
  }

  // * Devolvera la lista de lenguajes registrados
  Future<List<String>> getLanguages() async {
    // Carga el Documento de los tags
    DocumentSnapshot doc = await db.collection("Books").doc("Tags").get();
    // Carga las editoriales
    List<dynamic> data = doc.get("languages");
    // Ordena por orden alfabetico
    data.sort();
    return data.cast<String>().toList();
  }

  // * Devolvera un mapa con todos los tags { "categories" | "genres" | "editorials" | "languages" }
  Future<Map<String, List<String>>> getTags() async {
    Map<String, List<String>> map = {};
    // Almacena los distintos tags en un mapa
    map["categories"] = await getCategories();
    map["genres"] = await getGenres();
    map["editorials"] = await getEditorials();
    map["languages"] = await getLanguages();
    return map;
  }

  // * Devolvera una lista con los 3 libros mas populares
  Future<List<String>> getPopularity() async {
    // Carga el Documento de popularidad
    DocumentSnapshot doc = await db.collection("Books").doc("Popularity").get();
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // Ordenara el mapa de mayor a menor
    List<MapEntry<String, dynamic>> sortedEntries = data.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Reconstruye el mapa
    Map<String, dynamic> sortedData = Map.fromEntries(sortedEntries);
    // Crea una sublista con los 3 libros mas populares
    List<String> popularBooks = sortedData.keys.toList().sublist(0, 3);
    return popularBooks;
  }

  // ?

  //? |                                           |
  //? | GESTION DE DATOS RELACIONADOS AL USUARIO  |
  //? |                                           |

  // * Devolvera la lista "rents" del usuario
  Future<List<dynamic>> getUserRents(String email) async {
    // Carga el Documento del usuario
    DocumentSnapshot doc = await db.collection("Users").doc(email).get();
    // Carga la lista de libros alquilados
    List<dynamic> rents = await doc.get("rents");
    return rents;
  }

  // * Devolvera la lista "wishlist" del usuario enviado
  Future<List<dynamic>> getUserWishList(String email) async {
    // Carga el Documento del usuario
    DocumentSnapshot doc = await db.collection("Users").doc(email).get();
    // Carga la lista de libros en la lista de deseados
    List<dynamic> wishlist = await doc.get("wishlist");
    return wishlist;
  }

  // * Añadira el libro a la lista "wishlist" del usuario
  Future<void> addUserWishList(String email, String isbn) async {
    // Crea la referencia al usuario
    final userRef = db.collection("Users").doc(email);
    // Carga el Documento del usuario
    DocumentSnapshot doc = await userRef.get();
    // Carga la lista de libros en la lista de deseados
    List<dynamic> wishlist = await doc.get("wishlist");
    // Añade el nuevo libro a la lista
    wishlist.add(isbn);
    // Actualiza el valor en la base de datos
    userRef.update({"wishlist": wishlist});
  }

  // * Eliminara el libro de la lista "wishlist" del usuario
  Future<void> deleteUserWishList(String email, String isbn) async {
    // Crea la referencia al usuario
    final userRef = db.collection("Users").doc(email);
    // Carga el documento del usuario
    DocumentSnapshot doc = await userRef.get();
    // Carga la lista de libros en la lista de deseados
    List<dynamic> wishlist = await doc.get("wishlist");
    // Elimina el libro de la lista
    wishlist.remove(isbn);
    // Actualiza el valor en la base de datos
    userRef.update({"wishlist": wishlist});
  }

  // * Devolvera true/false segun si el libro se encuentra en la "wishlist" del usuario o no
  Future<bool> checkUserWishList(String email, String isbn) async {
    // Carga la lista de deseados del usuario
    List<dynamic> wishlist = await getUserWishList(email);
    // Comprueba si el libro se encuentra en la lista
    return wishlist.contains(isbn);
  }

  // * Devolvera la lista "waitlist" del usuario
  Future<List<dynamic>> getUserWaitList(String email) async {
    // Carga el Documento del usuario
    DocumentSnapshot doc = await db.collection("Users").doc(email).get();
    // Carga la lista de libros en la lista de espera
    List<dynamic> waitlist = await doc.get("waitlist");
    return waitlist;
  }

  // * Añadira el libro a la lista "waitlist" del usuario
  Future<void> addUserWaitList(String email, String isbn) async {
    // Crea la referencia al usuario
    final userRef = db.collection("Users").doc(email);
    // Carga el Documento del usuario
    DocumentSnapshot doc = await userRef.get();
    // Carga la lista de libros en la lsita de espera
    List<dynamic> waitlist = await doc.get("waitlist");
    // Añade el nuevo libro a la lista
    waitlist.add(isbn);
    // Actualiza el valor en la base de datos
    userRef.update({"waitlist": waitlist});
  }

  // * Eliminara el libro de la lista "waitlist" del usuario
  Future<void> deleteUserWaitList(String email, String isbn) async {
    // Crea la referencia al usuario
    final userRef = db.collection("Users").doc(email);
    // Carga el Documento del usuario
    DocumentSnapshot doc = await userRef.get();
    // Carga la lista de libros en la lsita de espera
    List<dynamic> waitlist = await doc.get("waitlist");
    // Elimina el libro de la lsita
    waitlist.remove(isbn);
    // Actualiza el valor en la base de datos
    userRef.update({"waitlist": waitlist});
  }

  // * Devolvera true/false segun si el libro se encuentra en la "waitlist" del usuario o no
  Future<bool> checkUserWaitList(String email, String isbn) async {
    // Carga la lista de espera del usuario
    List<dynamic> waitlist = await getUserWaitList(email);
    // Comprueba si el libro se encuentra en la lista
    return waitlist.contains(isbn);
  }

  // * Devolvera true/false si alguno de los libros de la "waitlist" se encuentra disponible
  Future<bool> checkUserWaitListAviability(String email) async {
    // Carga la lista de espera del usuario
    List<dynamic> waitList = await getUserWaitList(email);
    // Recorre la lista
    for (String bookid in waitList) {
      // Carga el libro de la lista
      Map<String, dynamic> book = await getMergedBook(bookid);
      // Comprueba si esta disponible
      if (book["aviable"]) {
        return true;
      }
    }
    return false;
  }

  // ?
}

class StorageManager {
  // Referencia al directorio con las imagenes de los libros
  final bookimagesRef = storage.ref().child("book-images");

  // * Devolvera la URL de la imagen del libro
  Future<String> getImage(String isbn) async {
    // Crea la referencia a la imagen
    var imageRef = bookimagesRef.child("$isbn.png");
    // Carga la URL de la imagen
    String imageUrl = await imageRef.getDownloadURL();
    return imageUrl;
  }
}
