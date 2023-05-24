import 'dart:collection';

import 'package:despensa/ingredientes.dart';

import 'receta.dart';

class Data {
  static final Data _instance = Data._internal();
  Ingredientes _ingredientes = Ingredientes(HashMap());
  List<Receta> _recetas = [];
  bool _loadedIngredientes = false;
  bool _loadedRecetas = false;

  factory Data() {
    return _instance;
  }

  Data._internal();

  Ingredientes get ingredientes {
    if (!_loadedIngredientes) {
      Ingredientes.load().then((ingredientes) {
        _ingredientes = ingredientes;
        _loadedIngredientes = true;
      });
    }
    return _ingredientes;
  }

  List<Receta> get recetas {
    if (!_loadedRecetas) {
      Receta.load().then((recetas) {
        _recetas = recetas;
        _loadedRecetas = true;
      });
    }
    return _recetas;
  }

  void saveIngredientes() {
    Ingredientes.save(_ingredientes);
  }

  void saveRecetas() {
    Receta.save(_recetas);
  }

  static String keyForNombre(String nombre) {
    List<int> intValues = [];
    for (var i = 0; i < nombre.length; i++) {
      intValues.add(nombre.codeUnitAt(i));
    }
    return intValues.join();
  }

  static String adecuateNombre(String nombre) {
    return nombre.trim().replaceAll(RegExp(r'\[|\]|\.|\d+'), '').toLowerCase();
  }
}
