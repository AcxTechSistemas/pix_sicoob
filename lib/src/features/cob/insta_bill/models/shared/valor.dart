import 'dart:convert';

/// A class representing a monetary value.
/// The Valor class contains a double value representing the original amount and a private
/// string value with the same amount but formatted to two decimal places.
class Valor {
  /// The original value of the monetary amount.
  final double original;

  /// A private string representing the original value formatted to two decimal places.
  late String _originalAsFixed;

  /// Creates a new Valor instance with the specified original value.
  /// - The [_originalAsFixed] property is initialized with the original value formatted to two decimal places.
  /// - [original] The original value of the monetary amount.
  Valor({required this.original}) {
    _originalAsFixed = original.toStringAsFixed(2);
  }

  /// Converts the Valor instance to a map.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'original': _originalAsFixed,
    };
  }

  /// Creates a new Valor instance from a map.
  factory Valor.fromMap(Map<String, dynamic> map) {
    return Valor(
      original: double.parse(map['original'] as String),
    );
  }

  /// Converts the Valor instance to a JSON string.
  String toJson() => json.encode(toMap());

  /// Creates a new Valor instance from a JSON string.
  factory Valor.fromJson(String source) {
    return Valor.fromMap(json.decode(source) as Map<String, dynamic>);
  }
}
