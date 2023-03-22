// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'parametros.dart';

/// A class representing pagination information.
///
/// The [Paginacao] class has a constructor that requires the following parameters:
///
/// - [paginaAtual]: the current page number.
/// - [itensPorPagina]: the number of itens per page.
/// - [quantidadeDePaginas]: the total number of pages.
/// - [quantidadeTotalDeItens]: the total number of items.
class Paginacao {
  /// The current page number.
  int paginaAtual;

  /// The number of itens per page
  int itensPorPagina;

  /// The total number of pages
  int quantidadeDePaginas;

  /// The total number of items
  int quantidadeTotalDeItens;

  Paginacao({
    required this.paginaAtual,
    required this.itensPorPagina,
    required this.quantidadeDePaginas,
    required this.quantidadeTotalDeItens,
  });

  /// Serializes the [Paginacao] object to a MAP object.
  ///
  /// The [toMap] method returns a [Map<String, dynamic>] object representing
  /// the [Paginacao] object that will be used to create a new instance of [Paginacao].
  ///
  /// The keys of the [Map] must match the names of the parameters of the [Paginacao] constructor.

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'paginaAtual': paginaAtual,
      'itensPorPagina': itensPorPagina,
      'quantidadeDePaginas': quantidadeDePaginas,
      'quantidadeTotalDeItens': quantidadeTotalDeItens,
    };
  }

  /// A factory method for creating a [Parametros] object from a MAP object.
  ///
  /// This method takes a [Map<String, dynamic>] object and returns a new instance of [Parametros] class.
  ///
  /// The following keys must be present in the input [MAP] object:
  /// - 'paginaAtual': the current page number.
  /// - 'itensPorPagina': the number of itens per page.
  /// - 'quantidadeDePaginas': the total number of pages.
  /// - 'quantidadeTotalDeItens': the total number of items.
  ///
  factory Paginacao.fromMap(Map<String, dynamic> map) {
    return Paginacao(
      paginaAtual: map['paginaAtual'],
      itensPorPagina: map['itensPorPagina'],
      quantidadeDePaginas: map['quantidadeDePaginas'],
      quantidadeTotalDeItens: map['quantidadeTotalDeItens'],
    );
  }

  /// Serializes the [Paginacao] object to a JSON string.
  String toJson() => json.encode(toMap());

  ///a factory method for creating a [Paginacao] object from a JSON object
  factory Paginacao.fromJson(String source) =>
      Paginacao.fromMap(json.decode(source) as Map<String, dynamic>);
}
