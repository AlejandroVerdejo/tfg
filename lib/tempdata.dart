const Map<String, dynamic> users = {
  "user1": {
    "email": "user1@correo.com",
    "username": "user1",
    "password": "user1",
    "level": 2,
    "rents": []
  },
  "admin": {
    "email": "admin@correo.com",
    "username": "admin",
    "password": "admin",
    "level": 0,
    "rents": []
  },
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
        "Maomao, a young woman trained in the art of herbal medicine, is forced to work as a lowly servant in the inner palace.\n\nThough she yearns for life outside its perfumed halls, she isn't long for a life of drudgery! Using her wits to break a \"curse\" afflicting the imperial heirs, Maomao attracts the attentions of the handsome eunuch Jinshi and is promoted to attendant food taster.\n\nBut Jinshi has other plans for the erstwhile apothecary, and soon Maomao is back to brewing potions and...solving mysteries?!",
    "isbn": "1646090705",
    "language": "Inglés",
    "pages": 176,
    // "image": "the_apothecary_diaries_1.jpg",
    "image":
        "https://firebasestorage.googleapis.com/v0/b/tfg-library.appspot.com/o/book-images%2Fthe_apothecary_diaries_1.jpg?alt=media&token=61c0c25b-8920-4658-8927-9a0cfeb70a74",
    "age": "14-17",
  },
  {
    "title": "El camino de las sombras",
    "author": "Brent Weeks",
    "editorial": "Plaza & Janes Editores",
    "date": "10/09/2010",
    "genres": ["Fantasia", "Acción", "Aventura", "Ciencia ficción"],
    "category": "Novela",
    "aviable": 1,
    "description":
        "El asesino perfecto no tiene un nombre, sino mil rostros...\n\nLa primera parte de «El Ángel de la Noche», la trilogía de fantasía épica que ha convertido a Brent Weeks en uno de los autores revelación de la literatura fantástica.\n\nLa muerte es un arte, y Durzo Blint lo ejecuta a la perfección, sea en una callejuela oscura o en las grandes estancias de palacio. Incluso el poderoso Sa'kagé, la organización criminal que mueve los hilos y los intereses en la ciudad de Cenaria, lo respeta.\n\nLa vida carece de valor si se ha nacido en las calles, y para Azoth la única manera de escapar a la miseria y el miedo que siempre lo han acompañado es ser temido antes que temer, matar antes de que lo maten. Si quiere sobrevivir, debe convencer a Blint de que lo acepte como aprendiz.\n\nPero aprender a asesinar con el mejor exige más que un duro adiestramiento. Hay que cambiar de identidad. Hay que olvidar el pasado y aquello en lo que se creía. Hay que aprender a moverse como las sombras en un mundo de intrigas donde nobles, plebeyos y criminales son meras piezas en una partida que acaba de empezar.\n\n«Levántate, chaval. Es hora de matar.»",
    "isbn": "8401337623",
    "language": "Español",
    "pages": 592,
    // "image": "el_camino_de_las_sombras.png",
    "image":
        "https://firebasestorage.googleapis.com/v0/b/tfg-library.appspot.com/o/book-images%2Fel_camino_de_las_sombras.png?alt=media&token=0a485950-9415-4b6f-b1a8-810e98788e00",
    "age": "a partir de 1",
  },
  {
    "title": "Al filo de las sombras",
    "author": "Brent Weeks",
    "editorial": "Plaza & Janes Editores",
    "date": "19/11/2010",
    "genres": ["Fantasia", "Acción", "Aventura", "Ciencia ficción"],
    "category": "Novela",
    "aviable": 0,
    "description":
        "El asesino perfecto no tiene un nombre, sino mil rostros...\n\nLa segunda parte de «El Ángel de la Noche», la trilogía de fantasía épica que dio a conocer a un nuevo autor del género, Brent Weeks.\n\nLa partida ha empezado. Todas las piezas han tomado posiciones e inician sus movimientos. Todas menos una.\n\nTras la muerte de Durzo Blint, su maestro, y de Logan, su mejor amigo y el legítimo heredero al trono, Kylar Stern siente que ya nada le ata a Cenaria, un país sometido a los caprichos del invasor: el rey dios Garoth Ursuul. Mientras los incendios y el pillaje se adueñan de la metrópoli, mientras miles de refugiados emprenden la huida y los resistentes se disponen a luchar, Kylar decide renunciar a su antigua vida.\n\nSin embargo, la noticia de que Logan está vivo, oculto en la peor de las prisiones, coloca a Kylar en una difícil encrucijada: su talento como asesino podría salvar a un amigo y a un país, pero... ¿a qué precio?\n\n«Diles que el Ángel de la Noche camina. Diles que la Justicia ha llegado.»",
    "isbn": "9788401339059",
    "language": "Español",
    "pages": 576,
    // "image": "al_filo_de_las_sombras.png",
    "image":
        "https://firebasestorage.googleapis.com/v0/b/tfg-library.appspot.com/o/book-images%2Fal_filo_de_las_sombras.png?alt=media&token=1708b79f-c555-458b-9050-8f4b9c3aa32b",
    "age": "a partir de 1",
  },
  {
    "title": "Frieren 01",
    "author": "Kanehito Yamada, Tsukasa Abe",
    "editorial": "NORMA Editorial",
    "date": "06/05/2022",
    "genres": ["Fantasia", "Aventura", "Magia"],
    "category": "Manga",
    "aviable": 1,
    "description":
        "Frieren es una elfa, y como para todos los de su raza, los años pasan en un suspiro… pero no es así para sus antiguos compañeros de batalla, a los que Frieren verá morir y envejecer.\n\nDe repente Frieren se da cuenta de que pese a que la vida avanza a un ritmo más lento para ella, las experiencias con sus seres queridos se le escapan de las manos.\n\nUn aire nostálgico envuelve a este manga fantástico tan entrañable que ha vendido ya más de 2,5 millones de copias en Japón.",
    "isbn": "9788467947397",
    "language": "Español",
    "pages": 184,
    // "image": "frieren_01.png",
    "image":
        "https://firebasestorage.googleapis.com/v0/b/tfg-library.appspot.com/o/book-images%2Ffrieren_01.png?alt=media&token=9b530bb6-c0ac-445d-9384-65dee4be8888",
    "age": "no especificada",
  },
];

final List<String> genres = [
  "Fantasia",
  "Romance",
  "Misterio",
  "Suspense",
  "Historia",
  "Aventura",
  "Acción",
  "Drama",
  "Ciencia ficción",
  "Magia",
];

final List<String> editorials = [
  "Square Enix Manga",
  "Plaza & Janes Editores",
  "NORMA Editorial",
];

final List<String> languages = [
  "Español",
  "Inglés",
];

final List<String> categories = [
  "Manga",
  "Novela",
];
