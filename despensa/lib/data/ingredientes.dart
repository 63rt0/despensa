import 'dart:collection';
import 'ingrediente.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

part 'ingredientes.g.dart';

@JsonSerializable()
class Ingredientes {
  @JsonKey(fromJson: _hashMapFromJson, toJson: _hashMapToJson)
  final HashMap<String, Ingrediente> hashMap;

  Ingredientes(this.hashMap);

  void addIngrediente(String key, Ingrediente nuevoIngrediente) {
    hashMap.putIfAbsent(key, () => nuevoIngrediente);
  }

  void removeIngrediente(String key) {
    hashMap.remove(key);
  }
  
  void updateIngredienteDespensa(String key, bool despensa) {
    Ingrediente toRemove = hashMap[key]!;
    toRemove.despensa = despensa;
    hashMap[key] = toRemove;
  }

    void updateIngredienteCompra(String key, bool compra) {
    Ingrediente toRemove = hashMap[key]!;
    toRemove.compra = compra;
    hashMap[key] = toRemove;
  }

  

  static HashMap<String, Ingrediente> _hashMapFromJson(
      Map<String, dynamic> json) {
    final hashMap = HashMap<String, Ingrediente>();
    json.forEach((key, value) {
      hashMap[key.toString()] = Ingrediente.fromJson(value);
    });
    return hashMap;
  }

  static Map<String, dynamic> _hashMapToJson(
      HashMap<String, Ingrediente> hashMap) {
    final json = <String, dynamic>{};
    hashMap.forEach((key, value) {
      json[key.toString()] = value.toJson();
    });
    return json;
  }

  factory Ingredientes.fromJson(Map<String, dynamic> json) =>
      _$IngredientesFromJson(json);

  Map<String, dynamic> toJson() {
    return {
      'hashMap': hashMap,
    };
  }

  static Future<void> save(Ingredientes ingredientes) async {
    final prefs = await SharedPreferences.getInstance();
    final ingredientesJson = jsonEncode(ingredientes.toJson());
    print('Datos guardados en SharedPreferences: ');
    print(ingredientes.hashMap.toString());
    await prefs.setString('ingredientes', ingredientesJson);
  }

  static Future<Ingredientes> load() async {
    //Ingredientes.clear();
    final prefs = await SharedPreferences.getInstance();
    final ingredientesJson = prefs.getString('ingredientes');
    if (ingredientesJson != null) {
      final ingredientesMap =
          jsonDecode(ingredientesJson) as Map<String, dynamic>;
      final hashMapIngredientes = _hashMapFromJson(ingredientesMap['hashMap']);
      print('Datos cargados de SharedPreferences: $hashMapIngredientes');
      return Ingredientes(hashMapIngredientes);
    } else {
      print('No se encontraron datos en SharedPreferences');
      return Ingredientes(HashMap<String, Ingrediente>());
    }
  }


}
