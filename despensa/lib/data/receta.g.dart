// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Receta _$RecetaFromJson(Map<String, dynamic> json) => Receta(
      json['id'] as String,
      json['nombre'] as String,
      (json['idIngredientes'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$RecetaToJson(Receta instance) => <String, dynamic>{
      'id': instance.id,
      'nombre': instance.nombre,
      'idIngredientes': instance.idIngredientes,
    };
