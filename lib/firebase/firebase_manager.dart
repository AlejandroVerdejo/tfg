import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tfg_library/management/add_book_data.dart';

FirebaseFirestore db = FirebaseFirestore.instance;
final storage = FirebaseStorage.instance;

class FirestoreManager {
  //? |                   |
  //? | GESTION DE LIBROS |
  //? |                   |

  // * Añadira un nuevo libro
  Future<void> addBook(Map<String, dynamic> book) async {
    String bookId = "";
    if (await checkBook(book["isbn"])) {
      DocumentSnapshot doc =
          await db.collection("Books").doc(book["isbn"]).get();
      // Carga la lista de libros alquilados
      Map<String, dynamic> bookData = doc.data() as Map<String, dynamic>;
      String lastKey = bookData.keys.toList().last;
      int newKeyInt = int.parse(lastKey);
      String bookId = (newKeyInt + 1).toString().padLeft(5, "0");
      book["id"] = "${book["isbn"]}-$bookId";
      await db.collection("Books").doc(book["isbn"]).update({bookId: book});
    } else {
      bookId = "00001";
      book["id"] = "${book["isbn"]}-$bookId";
      await db.collection("Books").doc(book["isbn"]).set({bookId: book});
      final popRef = db.collection("Books").doc("Popularity");
      popRef.update({book["isbn"]: 0});
    }
  }

  // *
  Future<void> editBook(Map<String, dynamic> newBook, Uint8List? image) async {
    String isbn = newBook["isbn"];
    final bookRef = db.collection("Books").doc(isbn);
    DocumentSnapshot doc = await bookRef.get();
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    for (var book in data.entries) {
      data[book.key]["title"] = newBook["title"];
      data[book.key]["author"] = newBook["author"];
      data[book.key]["age"] = newBook["age"];
      data[book.key]["category"] = newBook["category"];
      data[book.key]["description"] = newBook["description"];
      data[book.key]["genres"] = newBook["genres"];
      data[book.key]["editorial"] = newBook["editorial"];
      data[book.key]["language"] = newBook["language"];
      data[book.key]["pages"] = newBook["pages"];
    }
    await bookRef.set(data);

    StorageManager storageManager = StorageManager();
    if (image != null) {
      storageManager.addImage(image, newBook["isbn"]);
    }
  }

  // * Devolvera la lista de libros
  Future<Map<String, dynamic>> getBooks() async {
    Map<String, dynamic> books = {};

    // Carga la Coleccion "Books"
    await db.collection("Books").get().then((onValue) {
      // Recorre los Documentos
      for (var doc in onValue.docs) {
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
      book = data[data.keys.toList()[0]];
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

  // * Devolvera true/false segun si el libro existe o no
  Future<bool> checkIndividualBook(String bookId) async {
    // Divide el identificador
    var splitted = bookId.split("-");
    if (splitted.length > 1) {
      String isbn = splitted[0];
      String id = splitted[1];
      // Carga el Documento del libro
      DocumentSnapshot doc = await db.collection("Books").doc(isbn).get();
      // Comprueba si existe
      if (doc.exists) {
        // Carga los libros
        var books = doc.data() as Map<String, dynamic>;
        // Comprueba si existe el libro
        if (books.containsKey(id)) {
          return true;
        }
      }
    }
    return false;
  }

  // * Devolvera true/false segun si el libro existe o no
  Future<bool> checkBook(String isbn) async {
    // Carga el Documento del libro
    DocumentSnapshot doc = await db.collection("Books").doc(isbn).get();
    // Comprueba si existe
    if (doc.exists) {
      return true;
    }
    return false;
  }

  // * Devolvera true/false segun si el libro esta disponible o no
  Future<bool> checkBookAviability(String bookId) async {
    // Carga el libro
    Map<String, dynamic> book = await getUnMergedBook(bookId);
    return book["aviable"];
  }

  // * Actualizara la disponibilidad del libro
  Future<void> updateAviability(String bookId) async {
    // Divide el ID conjunto del libro para sacar el ISBN y el ID individual
    var splitted = bookId.split("-");
    String isbn = splitted[0];
    String id = splitted[1];
    final bookRef = db.collection("Books").doc(isbn);
    DocumentSnapshot doc = await db.collection("Books").doc(isbn).get();
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    Map<String, dynamic> book = data[id];
    book["aviable"] = book["aviable"] ? false : true;
    bookRef.update({id: book});
  }

  // *
  Future<void> deleteSingleBook(String bookId) async {
    // Divide el identificador
    var splitted = bookId.split("-");
    String isbn = splitted[0];
    String id = splitted[1];
    final bookRef = db.collection("Books").doc(isbn);
    DocumentSnapshot doc = await bookRef.get();
    Map<String, dynamic> books = doc.data() as Map<String, dynamic>;
    books.remove(id);
    await bookRef.set(books);
  }

  // *
  Future<void> deleteAllBooks(String bookId) async {
    final bookRef = db.collection("Books").doc(isbn);
    await bookRef.delete();
  }

  // ?

  //? |                     |
  //? | GESTION DE USUARIOS |
  //? |                     |

  // * Crear un nuevo usuario
  Future<void> addUser(Map<String, dynamic> user) async {
    user["rents"] = [];
    user["waitlist"] = [];
    user["wishlist"] = [];
    user["active"] = true;
    DocumentReference newUserRef = db.collection("Users").doc(user["email"]);
    await newUserRef.set(user);
  }

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
    DocumentSnapshot doc = await db.collection("Users").doc(email).get();
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    // Carga los datos del usuario
    Map<String, dynamic> user = {
      "username": data["username"],
      "password": data["password"],
      "email": data["email"],
      "level": data["level"],
    };

    return user;
  }

  Future<Map<String, dynamic>> getUsers() async {
    Map<String, dynamic> users = {};

    // Carga la Coleccion "Users"
    await db.collection("Users").get().then((onValue) {
      // Recorre los Documentos
      for (var doc in onValue.docs) {
        // Introduce los Documentos de los usuarios
        users[doc.id] = doc.data();
      }
    });

    return users;
  }

  Future<Map<String, dynamic>> getWorkers() async {
    Map<String, dynamic> workers = {};

    // Carga los usuarios
    Map<String, dynamic> users = await getUsers();
    for (var user in users.entries) {
      if (user.value["level"] <= 1) {
        workers[user.key] = user.value;
      }
    }

    return workers;
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

  // * Añadira una nueva categoria
  Future<void> addCategory(String category) async {
    // Crea la referencia al documento Tags
    final tagsRef = db.collection("Books").doc("Tags");
    // Carga los generos
    List<String> categories = await getCategories();
    // Añade la nueva editorial a la lista
    categories.add(category);
    tagsRef.update({"categories": categories});
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

  // * Añadira un nuevo genero
  Future<void> addGenre(String genre) async {
    // Crea la referencia al documento Tags
    final tagsRef = db.collection("Books").doc("Tags");
    // Carga los generos
    List<String> genres = await getGenres();
    // Añade la nueva editorial a la lista
    genres.add(genre);
    tagsRef.update({"genres": genres});
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

  // * Añadira una nueva editorial
  Future<void> addEditorial(String editorial) async {
    // Crea la referencia al documento Tags
    final tagsRef = db.collection("Books").doc("Tags");
    // Carga las editoriales
    List<String> editorials = await getEditorials();
    // Añade la nueva editorial a la lista
    editorials.add(editorial);
    tagsRef.update({"editorials": editorials});
  }

  // * Devolvera la lista de idiomas registrados
  Future<List<String>> getLanguages() async {
    // Carga el Documento de los tags
    DocumentSnapshot doc = await db.collection("Books").doc("Tags").get();
    // Carga las editoriales
    List<dynamic> data = doc.get("languages");
    // Ordena por orden alfabetico
    data.sort();
    return data.cast<String>().toList();
  }

  // * Añadira un nuevo idioma
  Future<void> addLanguage(String language) async {
    // Crea la referencia al documento Tags
    final tagsRef = db.collection("Books").doc("Tags");
    // Carga las editoriales
    List<String> languages = await getLanguages();
    // Añade la nueva editorial a la lista
    languages.add(language);
    tagsRef.update({"languages": languages});
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

  // * Devolvera los prestamos activos del usuario
  Future<List<dynamic>> getUserActiveRents(String email) async {
    // Carga la lista de libros alquilados
    List<dynamic> rents = await getUserRents(email);
    List activeRents = [];
    if (rents.isNotEmpty) {
      // activeRents = (rents).where((rent) => rent["active"] == true).toList();
      for (var i = 0; i < rents.length; i++) {
        if (rents[i]["active"]) {
          rents[i]["bookData"] = await getMergedBook(rents[i]["book"]["isbn"]);
          rents[i]["listPosition"] = i;
          activeRents.add(rents[i]);
        }
      }
    }
    // for (var i = 0; i < activeRents.length; i++) {
    //   activeRents[i]["bookData"] =
    //       await getMergedBook(activeRents[i]["book"]["isbn"]);
    // }
    return activeRents;
  }

  // * Devolvera la cantidad de prestamos activos del usuario
  Future<int> getUserActiveRentsNumber(String email) async {
    // Carga la lista de libros alquilados
    List<dynamic> rents = await getUserRents(email);
    List activeRents = [];
    if (rents.isNotEmpty) {
      activeRents = (rents).where((rent) => rent["active"] == true).toList();
    }
    return activeRents.length;
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

  // * Creara un nuevo prestamo de libro
  Future<void> newUserRent(
    String userEmail,
    String bookId,
    String returnDate,
  ) async {
    // Divide el identificador del libro
    var splitted = bookId.split("-");
    String isbn = splitted[0];
    String id = splitted[1];
    // Crea la referencia al usuario
    final userRef = db.collection("Users").doc(userEmail);
    // Carga la lista de prestamos del usuario
    List<dynamic> rents = await getUserRents(userEmail);
    // Crea los datos del prestamo
    Map rent = {
      "active": true,
      "book": {
        "isbn": isbn,
        "id": id,
      },
      "date": returnDate,
    };
    rents.add(rent);
    // Actualiza la lista de prestamos del usuario
    userRef.update({"rents": rents});
    // Crea la referencia del libro
    final bookRef = db.collection("Books").doc(isbn);
    // Actualiza la disponibilidad
    await bookRef.update({"$id.aviable": false});
    // Actualiza la fecha de devolucion
    await bookRef.update({"$id.return_date": returnDate});
  }

  // * Finalizara un prestamo actualizando los valores correspondientes tanto en el libro como en el usuario
  Future<void> returnUserRent(
      String email, String isbn, String id, int pos) async {
    // Crea la referencia para el usuario
    final userRef = db.collection("Users").doc(email);
    // Crea la referencia para el campo
    final bookRef = db.collection("Books").doc(isbn);
    // Carga la lista de prestamos del usuario
    List<dynamic> rents = await getUserRents(email);
    // Actualiza el prestamo correspondiente
    rents[pos]["active"] = false;
    // Actualiza la lista de prestamos del usuario
    await userRef.update({"rents": rents});
    // Actualiza la disponibilidad del libro
    await bookRef.update({"$id.aviable": true});
    // Actualiza la fecha de devolucion del libro
    await bookRef.update({"$id.return_date": ""});
  }

  // ?
}

class StorageManager {
  // Referencia al directorio con las imagenes de los libros
  final bookImagesRef = storage.ref().child("book-images");

  // * Devolvera la imagen en bytes
  Future<Uint8List?> getImage(String name) async {
    // Crea la referencia a la imagen
    var imageRef = bookImagesRef.child(name);
    // Carga la imagen
    Uint8List? imageBytes = await imageRef.getData();
    return imageBytes;
  }

  // * Añadira una imagen a la base de datos
  Future<void> addImage(Uint8List image, String name) async {
    // Crea la referencia para la imagen
    // final imageRef = bookImagesRef.child(name);
    final imageRef = storage.ref("book-images/$name");
    // Sube el archivo a la base de datos
    UploadTask uploadTask = imageRef.putData(image);

    // Se crea una snapshot para esperar a que la subida se complete
    // ignore: unused_local_variable
    TaskSnapshot snapshot = await uploadTask;
  }
}
