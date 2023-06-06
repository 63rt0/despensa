import 'dart:collection';

import 'package:despensa/data/ingrediente.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ingredientes.dart';
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

  void removeIngrediente(String key) {
    ingredientes.removeIngrediente(key);
    _saveIngredientes();
  }

  void removeIngredienteFrom(String key, Ingredientes otrosIngredientes) {
    otrosIngredientes.removeIngrediente(key);
  }

  List<dynamic> addIngrediente(String nombre,
      {bool despensa = false, bool compra = false}) {
    List<dynamic> newIngredienteEntry =
        _createIngredienteEntry(nombre, despensa: despensa, compra: compra);
    ingredientes.addIngrediente(newIngredienteEntry[0], newIngredienteEntry[1]);
    _saveIngredientes();
    return newIngredienteEntry;
  }

  List<dynamic> addIngredienteTo(String nombre, Ingredientes otrosIngredientes,
      {bool despensa = false, bool compra = false}) {
    List<dynamic> newIngredienteEntry =
        _createIngredienteEntry(nombre, despensa: despensa, compra: compra);
    otrosIngredientes.addIngrediente(
        newIngredienteEntry[0], newIngredienteEntry[1]);
    return newIngredienteEntry;
  }

  void updateIngredienteCompra(String key, bool compra) {
    ingredientes.updateIngredienteCompra(key, compra);
    _saveIngredientes();
  }

  void updateIngredienteDespensa(String key, bool compra) {
    ingredientes.updateIngredienteDespensa(key, compra);
    _saveIngredientes();
  }

  Receta addReceta(String nombreReceta, String nombresIngredientes) {
    Receta nuevaReceta = _createReceta(nombreReceta, nombresIngredientes);
    recetas.add(nuevaReceta);
    _saveRecetas();

    return nuevaReceta;
  }

  List<Receta> cocinables() {
    List<Receta> cocinables = [];
    Ingredientes ingredientesEnDespensa = filteredIngredientesInDespensa("");
    for (Receta receta in recetas) {
      bool cocinable = true;
      for (Ingrediente ingrediente in receta.ingredientes.hashMap.values) {
        if (ingredientesEnDespensa.hashMap
                .containsKey(keyForNombre(ingrediente.nombre)) ==
            false) {
          cocinable = false;
          break;
        }
      }
      if (cocinable) {
        cocinables.add(receta);
      }
    }
    return cocinables;
  }

  void removeReceta(int index) {
    recetas.removeAt(index);
    _saveRecetas();
  }

  void _saveIngredientes() {
    Ingredientes.save(ingredientes);
  }

  void _saveRecetas() {
    Receta.save(recetas);
  }

  static Future<void> clear(String datos) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$datos');
    print('Datos borrados de SharedPreferences: $datos');
  }

  String keyForNombre(String nombre) {
    List<int> intValues = [];
    for (var i = 0; i < nombre.length; i++) {
      intValues.add(nombre.codeUnitAt(i));
    }
    return intValues.join();
  }

  String adecuateNombre(String nombre) {
    return nombre.trim().replaceAll(RegExp(r'\[|\]|\.|\d+'), '').toLowerCase();
  }

  List<dynamic> _createIngredienteEntry(String nombre,
      {bool despensa = false, bool compra = false}) {
    nombre = adecuateNombre(nombre);
    Ingrediente nuevoIngrediente = Ingrediente(nombre, despensa, compra);

    String key = keyForNombre(nombre);

    return [key, nuevoIngrediente];
  }

  Receta _createReceta(String nombreReceta, String nombresIngredientes) {
    List<String> listaNombresIngredientes =
        nombresIngredientes.trim().split(',');

    HashMap<String, Ingrediente> ingredientesRecetaHashMap = HashMap();

    //Se añaden los ingredientes
    for (int i = 0; i < listaNombresIngredientes.length; i++) {
      List<dynamic> nuevoIngrediente =
          addIngrediente(listaNombresIngredientes.elementAt(i));
      ingredientesRecetaHashMap.putIfAbsent(
          nuevoIngrediente[0], () => nuevoIngrediente[1]);
    }

    //Se crea la receta
    Ingredientes ingredientesReceta = Ingredientes(ingredientesRecetaHashMap);
    nombreReceta = adecuateNombre(nombreReceta);
    String idReceta = keyForNombre(nombreReceta);
    return Receta(idReceta, nombreReceta, ingredientesReceta);
  }

  Ingredientes filteredIngredientes(String searchTerm) {
    Ingredientes filteredIngredientes = Ingredientes(HashMap());

    ingredientes.hashMap.forEach((key, value) {
      if (value.nombre.contains(searchTerm)) {
        filteredIngredientes.hashMap[key] = value;
      }
    });

    return filteredIngredientes;
  }

  Ingredientes filteredIngredientesInDespensa(String searchTerm) {
    Ingredientes filteredIngredientes = Ingredientes(HashMap());

    ingredientes.hashMap.forEach((key, value) {
      if (value.despensa && value.nombre.contains(searchTerm)) {
        filteredIngredientes.hashMap[key] = value;
      }
    });

    return filteredIngredientes;
  }

  Ingredientes filteredIngredientesInCompra(String searchTerm) {
    Ingredientes filteredIngredientes = Ingredientes(HashMap());

    ingredientes.hashMap.forEach((key, value) {
      if (value.compra && value.nombre.contains(searchTerm)) {
        filteredIngredientes.hashMap[key] = value;
      }
    });

    return filteredIngredientes;
  }
}
