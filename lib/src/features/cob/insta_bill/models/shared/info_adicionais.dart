import 'dart:convert';

/// A class that represents additional information.
class InfoAdicionais {
  /// The name of the additional information.
  final String nome;

  /// The value of the additional information.
  final double valor;

  /// The value of the additional information in fixed format.
  late String _valorAsFixed;

  /// Creates a new [InfoAdicionais] instance.
  ///
  /// - The [nome] and [valor] parameters are required.
  InfoAdicionais({
    required this.nome,
    required this.valor,
  }) {
    _valorAsFixed = valor.toStringAsFixed(2);
  }

  /// Converts this instance into a [Map] object.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nome': nome,
      'valor': _valorAsFixed,
    };
  }

  /// Creates a new [InfoAdicionais] instance from a [Map] object.
  factory InfoAdicionais.fromMap(Map<String, dynamic> map) {
    return InfoAdicionais(
      nome: map['nome'] as String,
      valor: double.parse(map['valor']),
    );
  }

  /// Converts this instance into a JSON string.
  String toJson() => json.encode(toMap());

  /// Creates a new [InfoAdicionais] instance from a JSON string.
  factory InfoAdicionais.fromJson(String source) {
    return InfoAdicionais.fromMap(json.decode(source) as Map<String, dynamic>);
  }
}
