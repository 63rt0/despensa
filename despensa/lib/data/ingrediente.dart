
import 'package:json_annotation/json_annotation.dart';

part 'ingrediente.g.dart';

@JsonSerializable()
class Ingrediente {
  final String nombre;
  final bool despensa;
  final bool compra;

  Ingrediente(this.nombre, this.despensa, this.compra);


  factory Ingrediente.fromJson(Map<String, dynamic> json) => _$IngredienteFromJson(json);

  Map<String, dynamic> toJson() => _$IngredienteToJson(this);

}
