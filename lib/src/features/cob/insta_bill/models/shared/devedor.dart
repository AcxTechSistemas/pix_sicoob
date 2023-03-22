import 'dart:convert';

/// A class representing a debtor entity, with optional CPF and CNPJ attributes and a required name attribute.
class Devedor {
  /// The debtor's CPF (optional).
  final String? cpf;

  /// The debtor's CNPJ (optional).
  final String? cnpj;

  /// The debtor's name (required).
  final String nome;

  /// Creates a new instance of [Devedor].
  ///
  /// - [cpf]: The debtor's CPF (optional).
  /// - [cnpj]: The debtor's CNPJ (optional).
  /// - [nome]: The debtor's name (required).
  Devedor({
    this.cpf,
    this.cnpj,
    required this.nome,
  });

  /// Converts this [Devedor] instance to a [Map] of key-value pairs.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'cpf': cpf,
      'cnpj': cnpj,
      'nome': nome,
    };
  }

  /// Creates a new instance of [Devedor] from a [Map] of key-value pairs.
  factory Devedor.fromMap(Map<String, dynamic> map) {
    return Devedor(
      cpf: map['cpf'] != null ? map['cpf'] as String : null,
      cnpj: map['cnpj'] != null ? map['cnpj'] as String : null,
      nome: map['nome'] as String,
    );
  }

  /// Converts this [Devedor] instance to a JSON string.
  String toJson() => json.encode(toMap());

  /// Creates a new instance of [Devedor] from a JSON string.
  factory Devedor.fromJson(String source) {
    return Devedor.fromMap(json.decode(source) as Map<String, dynamic>);
  }
}
