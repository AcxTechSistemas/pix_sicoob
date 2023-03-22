import 'dart:convert';

/// A model class representing a calendar object with creation and expiration timestamps.
class BillingCalendario {
  /// The timestamp of calendar creation.
  String criacao;

  /// The timestamp of calendar expiration.
  int expiracao;

  /// Creates a new [BillingCalendario] instance with the specified creation and expiration timestamps.
  ///
  /// - [criacao] The timestamp of calendar creation. Cannot be null.
  /// - [expiracao] The timestamp of calendar expiration. Cannot be null.
  BillingCalendario({
    required this.criacao,
    required this.expiracao,
  });

  /// Converts the current [Calendario] object to a [Map] object.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'criacao': criacao,
      'expiracao': expiracao,
    };
  }

  /// Creates a new [Calendario] instance from a [Map] object.
  factory BillingCalendario.fromMap(Map<String, dynamic> map) {
    return BillingCalendario(
      criacao: map['criacao'] as String,
      expiracao: map['expiracao'] as int,
    );
  }

  /// Converts the current [Calendario] object to a JSON string.
  String toJson() => json.encode(toMap());

  /// Creates a new [Calendario] instance from a JSON string.
  factory BillingCalendario.fromJson(String source) {
    return BillingCalendario.fromMap(
        json.decode(source) as Map<String, dynamic>);
  }
}
