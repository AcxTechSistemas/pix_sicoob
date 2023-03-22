import 'dart:convert';
part 'pagador.g.dart';

///A class representing a PIX payment.
///
/// This class contains information aboute a payment made through PIX.
///
/// The [PIX] class has a constructor that requires the following parameters:
/// - [valor] the value of payment.
/// - [horario] the date and time when payment was made.
/// - [nomePagador] the name of the payer.
/// - [pagador]: a [Pagador] object representing the payer.
/// - [infoPagador] additional information about the payer.
///
/// - [devolucoes] List of values ​​returned from the transaction, and starting with an empty list
///
/// - The [endToEndId] and [txid] parameters are optional, and can be set to null.
class Pix {
  /// A unique identifier for the payment.
  String? endToEndId;

  /// A transaction ID for the payment.
  String? txid;

  /// The value of payment.
  final String valor;

  /// The date and time when the payment was made.
  final String horario;

  /// Additional information about the payer.
  final String nomePagador;

  /// A [Map<String, dynamic>] object representing the payer.
  final Pagador pagador;

  /// List of values ​​returned from the transaction, and starting with an empty list
  List devolucoes = [];

  /// Additional information about the payer.
  final String? infoPagador;

  Pix({
    this.endToEndId,
    this.txid,
    required this.valor,
    required this.horario,
    required this.nomePagador,
    required this.pagador,
    required this.devolucoes,
    required this.infoPagador,
  });

  /// Serializes the [PIX] object to a MAP object.
  ///
  /// The [toMap] method returns a [Map<String, dynamic>] object representing
  /// the [PIX] object that will be used to create a new instance of [PIX].
  ///
  /// The keys of the [Map] must match the names of the parameters of the [PIX] constructor.

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'endToEndId': endToEndId,
      'txid': txid,
      'valor': valor,
      'horario': horario,
      'nomePagador': nomePagador,
      'pagador': pagador.toMap(),
      'devolucoes': devolucoes,
      'infoPagador': infoPagador,
    };
  }

  /// A factory method for creating a [PIX] object from a MAP object.
  ///
  /// this method takes a [Map<String, dynamic>] object and returns a new instance of [PIX] class.
  ///
  /// The following keys must be present in the input MAP object:
  /// - 'valor': the value of the payment.
  /// - 'horario': the date and time when the payment was made.
  /// - 'pagador': a [Map<String, dynamic>] object representing the payer.
  /// - 'infoPagador': additional information about the payer.
  /// - 'devolucoes': List of values ​​returned from the transaction, and starting with an empty list
  ///
  /// The following key is optional:
  ///
  /// - 'endToEndId': a unique identifier for the payment.
  /// - 'txid': a transaction ID for the payment.

  factory Pix.fromMap(Map<String, dynamic> map) {
    return Pix(
        endToEndId: map['endToEndId'],
        txid: map['txid'],
        valor: map['valor'],
        horario: map['horario'],
        nomePagador: map['nomePagador'],
        pagador: Pagador.fromMap(map['pagador'] as Map<String, dynamic>),
        infoPagador: map['infoPagador'],
        devolucoes: List.from(
          (map['devolucoes'] as List),
        ));
  }

  /// This method serializing the [PIX] object to JSON string
  String toJson() => json.encode(toMap());

  ///a factory method for creating a [PIX] object from a JSON object
  factory Pix.fromJson(String source) =>
      Pix.fromMap(json.decode(source) as Map<String, dynamic>);
}
