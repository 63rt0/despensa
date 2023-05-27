// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Receta _$RecetaFromJson(Map<String, dynamic> json) => Receta(
      json['id'] as String,
      json['nombre'] as String,
      Ingredientes.fromJson(json['ingredientes'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RecetaToJson(Receta instance) => <String, dynamic>{
      'id': instance.id,
      'nombre': instance.nombre,
      'ingredientes': instance.ingredientes,
    };
