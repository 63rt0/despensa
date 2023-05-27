// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ingrediente.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ingrediente _$IngredienteFromJson(Map<String, dynamic> json) => Ingrediente(
      json['nombre'] as String,
      json['despensa'] as bool,
      json['compra'] as bool,
    );

Map<String, dynamic> _$IngredienteToJson(Ingrediente instance) =>
    <String, dynamic>{
      'nombre': instance.nombre,
      'despensa': instance.despensa,
      'compra': instance.compra,
    };
