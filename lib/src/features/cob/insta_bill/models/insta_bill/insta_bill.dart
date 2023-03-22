import 'dart:convert';
import 'calendario.dart';
import '../shared/devedor.dart';
import '../shared/info_adicionais.dart';
import '../shared/valor.dart';

/// The InstaBill class represents a payment request in the Cob Api.
class InstaBill {
  /// The calendar information for the payment request.
  Calendario calendario;

  /// The debtor information for the payment request.
  Devedor devedor;

  /// The value information for the payment request.
  Valor valor;

  /// The key for the payment request.
  String chave;

  /// The payer request for the payment request.
  String solicitacaoPagador;

  /// The additional information for the payment request.
  List<InfoAdicionais> infoAdicionais;

  /// Constructs a new instance of the [InstaBill] class.
  ///
  /// The [calendario], [devedor], [valor], [chave], [solicitacaoPagador],
  /// and [infoAdicionais] arguments are all required.
  InstaBill({
    required this.calendario,
    required this.devedor,
    required this.valor,
    required this.chave,
    required this.solicitacaoPagador,
    required this.infoAdicionais,
  });

  /// Creates a payment request instance from a map.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'calendario': calendario.toMap(),
      'devedor': devedor.toMap(),
      'valor': valor.toMap(),
      'chave': chave,
      'solicitacaoPagador': solicitacaoPagador,
      'infoAdicionais': infoAdicionais.map((x) => x.toMap()).toList(),
    };
  }

  /// Creates a payment request instance from a map.
  factory InstaBill.fromMap(Map<String, dynamic> map) {
    return InstaBill(
      calendario: Calendario.fromMap(map['calendario'] as Map<String, dynamic>),
      devedor: Devedor.fromMap(map['devedor'] as Map<String, dynamic>),
      valor: Valor.fromMap(map['valor'] as Map<String, dynamic>),
      chave: map['chave'] as String,
      solicitacaoPagador: map['solicitacaoPagador'] as String,
      infoAdicionais: List<InfoAdicionais>.from(
        (map['infoAdicionais'] as List<int>).map<InfoAdicionais>(
          (x) => InfoAdicionais.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  /// Converts the payment request instance to a JSON string.
  String toJson() => json.encode(toMap());

  /// Creates a payment request instance from a JSON string.
  factory InstaBill.fromJson(String source) {
    return InstaBill.fromMap(json.decode(source) as Map<String, dynamic>);
  }
}
