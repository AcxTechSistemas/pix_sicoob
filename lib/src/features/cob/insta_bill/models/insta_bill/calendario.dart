import 'dart:convert';

/// A model class representing a calendar object with creation and expiration timestamps.
class Calendario {
  /// The timestamp of calendar expiration.
  final int expiracao;

  /// Creates a new [Calendario] instance with the specified creation and expiration timestamps.
  ///
  /// - [expiracao] The timestamp of calendar expiration. with default value: 3600.
  Calendario({this.expiracao = 3600});

  /// Converts the current [Calendario] object to a [Map] object.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'expiracao': expiracao,
    };
  }

  /// Creates a new [Calendario] instance from a [Map] object.
  factory Calendario.fromMap(Map<String, dynamic> map) {
    return Calendario(
      expiracao: map['expiracao'] as int,
    );
  }

  /// Converts the current [Calendario] object to a JSON string.
  String toJson() => json.encode(toMap());

  /// Creates a new [Calendario] instance from a JSON string.
  factory Calendario.fromJson(String source) {
    return Calendario.fromMap(json.decode(source) as Map<String, dynamic>);
  }
}
