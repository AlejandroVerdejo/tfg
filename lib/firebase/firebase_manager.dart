import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tfg_library/tempdata.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

class FirestoreManager {
  Future<Map<String, dynamic>> getBooks() async {
    Map<String, dynamic> books = {};
    await db.collection("Books").get().then((event) {
      for (var doc in event.docs) {
        if (doc.id != "Tags" && doc.id != "Popularity") {
          books[doc.id] = doc.data();
        }
      }
    });
    return books;
  }

  // Metodo para eliminar los libros duplicados para mostrarlos en el catalogo
  Future<Map<String, dynamic>> getMergedBooks() async {
    Map<String, dynamic> books = await getBooks();

    Map<String, dynamic> result = {};

    books.forEach((claveExterna, subMapa) {
      // log("Doc: ${claveExterna}");
      bool valorCombinado = false;
      Map<String, dynamic> libroCombinado = {};

      subMapa.forEach((claveInterna, objeto) {
        valorCombinado = valorCombinado || objeto["aviable"];

        if (libroCombinado.isEmpty) {
          libroCombinado = objeto;
        }
      });
      libroCombinado["aviable"] = valorCombinado;
      result[claveExterna] = libroCombinado;
    });

    return result;
  }

  Future<Map<String, dynamic>> getMergedBook(String key) async {
    Map<String, dynamic> books = await getMergedBooks();
    return books[key];
  }

  Future<Map<String, dynamic>> getUnMergedBooks() async {
    Map<String, dynamic> books = await getBooks();

    Map<String, dynamic> result = {};

    books.forEach((claveExterna, subMapa) {
      subMapa.forEach((claveInterna, objeto) {
        result[objeto["id"]] = objeto;
      });
    });

    return result;
  }

  Future<Map<String, dynamic>> getUnMergedBook(String key) async {
    Map<String, dynamic> books = await getUnMergedBooks();
    return books[key];
  }

  Future<bool> checkUser(String email) async {
    DocumentSnapshot doc = await db.collection("Users").doc(email).get();
    log(doc.exists.toString());
    return doc.exists;
  }

  Future<bool> checkPassword(String email, String password) async {
    DocumentSnapshot doc = await db.collection("Users").doc(email).get();
    String data = doc.get("password");
    return data == password;
  }

  Future<Map<String, dynamic>> getUser(String email) async {
    DocumentSnapshot doc = await db.collection("Users").doc(email).get();
    return doc.data() as Map<String, dynamic>;
  }

  Future<List<String>> getCategories() async {
    DocumentSnapshot doc = await db.collection("Books").doc("Tags").get();
    List<dynamic> data = doc.get("categories");
    data.sort();
    return data.cast<String>().toList();
  }

  Future<List<String>> getGenres() async {
    DocumentSnapshot doc = await db.collection("Books").doc("Tags").get();
    List<dynamic> data = doc.get("genres");
    data.sort();
    return data.cast<String>().toList();
  }

  Future<List<String>> getEditorials() async {
    DocumentSnapshot doc = await db.collection("Books").doc("Tags").get();
    List<dynamic> data = doc.get("editorials");
    data.sort();
    return data.cast<String>().toList();
  }

  Future<List<String>> getLanguages() async {
    DocumentSnapshot doc = await db.collection("Books").doc("Tags").get();
    List<dynamic> data = doc.get("languages");
    data.sort();
    return data.cast<String>().toList();
  }

  Future<Map<String, List<String>>> getTags() async {
    Map<String, List<String>> map = {};
    map["categories"] = await getCategories();
    map["genres"] = await getGenres();
    map["editorials"] = await getEditorials();
    map["languages"] = await getLanguages();
    return map;
  }

  Future<List<String>> getPopularity() async {
    DocumentSnapshot doc = await db.collection("Books").doc("Popularity").get();
    // log("Log: ${doc.data().toString()}");
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    // log("Log: ${data}");
    // log("Log: ${data.runtimeType}");
    // log("Log: ${popularity}");
    // log("Log: ${popularity.runtimeType}");
    // var sortedPopularity = Map.fromEntries(popularity.entries.toList()
    //   ..sort(
    //     (a, b) => b.value.compareTo(a.value),
    //   ));
    // log("Ordered?: ${sortedPopularity}");
    return ["a", "b"];
  }
}
