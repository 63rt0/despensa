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
    _ingredientes.removeIngrediente(key);
    saveIngredientes();
  }

  void removeIngredienteFrom(String key, Ingredientes otrosIngredientes) {
    otrosIngredientes.removeIngrediente(key);
  }

  List<dynamic> addIngrediente(String nombre) {
    List<dynamic> nuevoIngrediente = _createIngrediente(nombre);
    _ingredientes.addIngrediente(nuevoIngrediente[0], nuevoIngrediente[1]);
    saveIngredientes();
    return nuevoIngrediente;
  }

  List<dynamic> addIngredienteTo(
      String nombre, Ingredientes otrosIngredientes) {
    List<dynamic> nuevoIngrediente = _createIngrediente(nombre);
    otrosIngredientes.addIngrediente(nuevoIngrediente[0], nuevoIngrediente[1]);
    return nuevoIngrediente;
  }

  Receta addReceta(String nombreReceta, String nombresIngredientes) {
    Receta nuevaReceta = _createReceta(nombreReceta, nombresIngredientes);
    _recetas.add(nuevaReceta);
    saveRecetas();

    return nuevaReceta;
  }

  void saveIngredientes() {
    Ingredientes.save(_ingredientes);
  }

  void saveRecetas() {
    Receta.save(_recetas);
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

  List<dynamic> _createIngrediente(String nombre) {
    nombre = adecuateNombre(nombre);
    Ingrediente nuevoIngrediente = Ingrediente(nombre, false, false);

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

    _ingredientes.hashMap.forEach((key, value) {
      if (value.nombre.contains(searchTerm)) {
        filteredIngredientes.hashMap[key] = value;
      }
    });

    return filteredIngredientes;
  }
}
