// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'pix.dart';

/// A class representing a Payer
///
/// The [Pagador] class has a constructor that requires the following parameters:
///
///   The Payer can be identified by either CPF or CNPJ and has a name.
/// - [nome]: The name of the payer.
///
/// - [cpf]: The CPF of the payer. Can be null if identified by CNPJ.
///
/// - [cnpj]: The CNPJ of the payer. Can be null if identified by CPF.
class Pagador {
  /// The name of the payer.
  String nome;

  /// The CPF of the payer. Can be null if identified by CNPJ.
  String? cpf;

  /// The CNPJ of the payer. Can be null if identified by CPF.
  String? cnpj;

  Pagador({
    required this.nome,
    required this.cpf,
    required this.cnpj,
  });

  /// Serializes the [Pagador] object to a MAP object.
  ///
  /// The [toMap] method returns a [Map<String, dynamic>] object representing
  /// the [Pagador] object that will be used to create a new instance of [Pagador].
  ///
  /// The keys of the [Map] must match the names of the parameters of the [Pagador] constructor.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nome': nome,
      'cpf': cpf,
      'cnpj': cnpj,
    };
  }

  /// A factory method for creating a [Pagador] object from a MAP object.
  ///
  /// This method takes a [Map<String, dynamic>] object and returns a new instance of [Pagador] class.
  ///
  /// The following keys must be present in the input [MAP] object:
  /// - 'nome':  The name of the payer.
  /// - 'cpf': The CPF of the payer. Can be null if identified by CNPJ.
  /// - 'cnpj': The CNPJ of the payer. Can be null if identified by CPF.
  ///
  factory Pagador.fromMap(Map<String, dynamic> map) {
    return Pagador(
      nome: map['nome'],
      cpf: map['cpf'],
      cnpj: map['cnpj'],
    );
  }

  /// Serializes the [Paginacao] object to a JSON string.
  String toJson() => json.encode(toMap());

  ///a factory method for creating a [Paginacao] object from a JSON object
  factory Pagador.fromJson(String source) =>
      Pagador.fromMap(json.decode(source) as Map<String, dynamic>);
}
