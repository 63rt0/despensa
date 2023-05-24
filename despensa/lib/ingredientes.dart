import 'dart:collection';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'data.dart';

part 'ingredientes.g.dart';

@JsonSerializable()
class Ingredientes {
  @JsonKey(fromJson: _hashMapFromJson, toJson: _hashMapToJson)
  final HashMap<String, String> hashMap;

  Ingredientes(this.hashMap);

  static List<dynamic> addIngrediente(String nombre) {
    nombre = Data.adecuateNombre(nombre);
    String ingredienteKey = Data.keyForNombre(nombre);

    Data().ingredientes.hashMap.putIfAbsent(ingredienteKey, () => nombre);
    Data().saveIngredientes();

    return [ingredienteKey, nombre];
  }

  static HashMap<String, String> _hashMapFromJson(Map<String, dynamic> json) {
    final hashMap = HashMap<String, String>();
    json.forEach((key, value) {
      hashMap[key.toString()] = value.toString();
    });
    return hashMap;
  }

  static Map<String, dynamic> _hashMapToJson(HashMap<String, String> hashMap) {
    final json = <String, dynamic>{};
    hashMap.forEach((key, value) {
      json[key.toString()] = value.toString();
    });
    return json;
  }

  factory Ingredientes.fromJson(Map<String, dynamic> json) =>
      _$IngredientesFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientesToJson(this);

  static Future<void> save(Ingredientes ingredientes) async {
    final prefs = await SharedPreferences.getInstance();
    final ingredientesJson = jsonEncode(ingredientes.toJson());
    print('Datos guardados en SharedPreferences: ');
    print(ingredientes.hashMap.toString());
    await prefs.setString('ingredientes', ingredientesJson);
  }

  static Future<Ingredientes> load() async {
    final prefs = await SharedPreferences.getInstance();
    final ingredientesJson = prefs.getString('ingredientes');
    if (ingredientesJson != null) {
      final ingredientesMap =
          jsonDecode(ingredientesJson) as Map<String, dynamic>;
      final hashMapIngredientes =
          Ingredientes._hashMapFromJson(ingredientesMap);
          
    print('Datos cargador de SharedPreferences: $hashMapIngredientes');
      return Ingredientes(hashMapIngredientes);
    } else {
      print('No se encontraron datos en SharedPreferences');
      return Ingredientes(HashMap<String, String>());
    }
  }
}
