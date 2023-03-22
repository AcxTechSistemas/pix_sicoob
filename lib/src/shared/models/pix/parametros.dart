// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
part 'paginacao.g.dart';

/// A class representing a set of parameters for a request.
///
/// This class contains information about a date range and pagination details.
///
/// The [Parametros] class has a constructor that requires the following parameters:
/// - [inicio]: the start date of the range.
/// - [fim]: the end date of the range.
/// - [paginacao]: a [Paginacao] object representing the pagination details.
class Parametros {
  /// The start date of the range.
  String inicio;

  /// The end date of the range
  String fim;

  // A [Paginacao] object representing the pagination details.
  Paginacao paginacao;

  Parametros({
    required this.inicio,
    required this.fim,
    required this.paginacao,
  });

  /// Serializes the [Parametros] object to a MAP object.
  ///
  /// The [toMap] method returns a [Map<String, dynamic>] object representing
  /// the [Parametros] object that will be used to create a new instance of [Parametros].
  ///
  /// The keys of the [Map] must match the names of the parameters of the [Parametros] constructor.

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'inicio': inicio,
      'fim': fim,
      'paginacao': paginacao.toMap(),
    };
  }

  /// A factory method for creating a [Parametros] object from a MAP object.
  ///
  /// This method takes a [Map<String, dynamic>] object and returns a new instance of [Parametros] class.
  ///
  /// The following keys must be present in the input [MAP] object:
  /// - 'inicio': the start date of the range.
  /// - 'fim': the end date of the range.
  /// - 'paginacao': a [Map<String, dynamic>] object representing the pagination details.
  factory Parametros.fromMap(Map<String, dynamic> map) {
    return Parametros(
      inicio: map['inicio'],
      fim: map['fim'],
      paginacao: Paginacao.fromMap(map['paginacao'] as Map<String, dynamic>),
    );
  }

  /// This method serializing the [Parametros] object to JSON string
  String toJson() => json.encode(toMap());

  ///a factory method for creating a [PIX] object from a JSON object
  factory Parametros.fromJson(String source) =>
      Parametros.fromMap(json.decode(source) as Map<String, dynamic>);
}
