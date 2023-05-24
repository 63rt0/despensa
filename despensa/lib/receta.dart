import 'dart:collection';

import 'package:despensa/ingredientes.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'data.dart';

part 'receta.g.dart';

@JsonSerializable()
class Receta {
  final String id;
  final String nombre;
  final Ingredientes ingredientes;

  Receta(this.id, this.nombre, this.ingredientes);

  static Receta addReceta(String nombreReceta, String nombresIngredientes) {
    List<String> listaNombresIngredientes =
        nombresIngredientes.trim().split(',');

    HashMap<String, String> ingredientesRecetaHashMap = HashMap();
    
    //Se añaden los ingredientes
    for (int i = 0; i < listaNombresIngredientes.length; i++) {
      var ingrediente = Ingredientes.addIngrediente(listaNombresIngredientes.elementAt(i));
      ingredientesRecetaHashMap.putIfAbsent(ingrediente[0], () => ingrediente[1]);
    }

    //Se crea la receta
    Ingredientes ingredientesReceta = Ingredientes(ingredientesRecetaHashMap);
    nombreReceta = Data.adecuateNombre(nombreReceta);
    String idReceta = Data.keyForNombre(nombreReceta);
    Receta nuevaReceta = Receta(idReceta, nombreReceta, ingredientesReceta);

    //Se añade
        Data data = Data();
    data.recetas.add(nuevaReceta);
    data.saveRecetas();

    return nuevaReceta;
  }

  String nombresIngredientes() {
    return ingredientes.hashMap.values.join(', ');
  }

  factory Receta.fromJson(Map<String, dynamic> json) => _$RecetaFromJson(json);

  Map<String, dynamic> toJson() => _$RecetaToJson(this);

  static Future<List<Receta>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final recetasJson = prefs.getString('recetas');
    if (recetasJson != null) {
      final recetasList = jsonDecode(recetasJson) as List<dynamic>;
      return recetasList.map((json) => Receta.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  static Future<void> save(List<Receta> recetas) async {
    final prefs = await SharedPreferences.getInstance();
    final recetasJson =
        jsonEncode(recetas.map((receta) => receta.toJson()).toList());
    await prefs.setString('recetas', recetasJson);
  }
}
