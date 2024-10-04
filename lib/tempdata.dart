const Map<String, dynamic> users = {
  "user1": {"username": "user1", "password": "user1", "level": 2},
  "admin": {"username": "admin", "password": "admin", "level": 0}
};

List<Map<String, dynamic>> books = [
  {
    "title": "The Apothecary Diaries 01",
    "author": "Natsu Hyuuga",
    "editorial": "Square Enix Manga",
    "date": "8/12/2020",
    "genres": [
      "Romance",
      "Misterio",
      "Suspense",
      "Historia",
    ],
    "category": "Manga",
    "aviable": 1,
    "description":
        "Maomao, a young woman trained in the art of herbal medicine, is forced to work as a lowly servant in the inner palace. Though she yearns for life outside its perfumed halls, she isn't long for a life of drudgery! Using her wits to break a \"curse\" afflicting the imperial heirs, Maomao attracts the attentions of the handsome eunuch Jinshi and is promoted to attendant food taster. But Jinshi has other plans for the erstwhile apothecary, and soon Maomao is back to brewing potions and...solving mysteries?!",
    "isbn": "1646090705",
    "language": "Inglés",
    "pages": 176,
    "image": "the_apothecary_diaries_1.jpg",
    "age": "14-17",
  },
  {
    "title": "Libro 2",
    "author": "Autor 2",
    "editorial": "Editorial 1",
    "date": "13/10/2007",
    "genres": [
      "genero1",
      "genero3",
    ],
    "category": "Novel",
    "aviable": 0,
    "description":
        "prentas y archivos de texto. Lorem Ipsum ha sido el texto de re tal manera que logró hacer un libro de textos especimen. No sólo sobrevivió 500 años, sino que tambien ingresó como texto de relleno en documentos electrónicos, quedando esencialmente igual al original. Fue popularizado en los 60s con la creación de las hojas , las cuales contenian pasajes de Lorem Ipsum, y más recientemente con software de autoedición, como por ejemplo Aldus PageMaker, el cual ",
    "isbn": "afahñdjhfa",
    "language": "Español",
    "pages": 233,
    "image": "book.png",
    "age": "10-13",
  },
];

final List<String> genres = [
  "genero1",
  "genero2",
  "genero3",
  "Romance",
  "Misterio",
  "Suspense",
  "Historia",
  "Aventura",
  "Acción",
  "Drama",
];

final List<String> editorials = [
  "Editorial 1",
  "Editorial 2",
  "Square Enix Manga",
];

final List<String> languages = [
  "Español",
  "Inglés",
];

final List<String> categories = [
  "Manga",
  "Novela",
];
