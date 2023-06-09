import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
part 'receta.g.dart';

@JsonSerializable()
class Receta {
  final String id;
  final String nombre;
  final List<String> idIngredientes;

  Receta(this.id, this.nombre, this.idIngredientes);

  @override
  String toString() {
    String toString = '[Nombre: $nombre, key: $id , ingredientes: [';
    for (String idIngrediente in idIngredientes) {
      toString += '[$idIngrediente]';
    }
    toString += ']';
    return toString;
  }

  factory Receta.fromJson(Map<String, dynamic> json) => _$RecetaFromJson(json);

  Map<String, dynamic> toJson() => _$RecetaToJson(this);

  static Future<List<Receta>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final recetasJson = prefs.getString('recetas');
    if (recetasJson != null) {
      final recetasList = jsonDecode(recetasJson) as List<dynamic>;
      print('Datos cargados de SharedPreferences: ');
      print(recetasList.toString());
      return recetasList.map((json) => Receta.fromJson(json)).toList();
    } else {
      return [];
    }
  }

  static Future<void> save(List<Receta> recetas) async {
    final prefs = await SharedPreferences.getInstance();
    print('Datos guardados en SharedPreferences: ');
    print(recetas.toString());
    final recetasJson =
        jsonEncode(recetas.map((receta) => receta.toJson()).toList());
    await prefs.setString('recetas', recetasJson);
  }
}
