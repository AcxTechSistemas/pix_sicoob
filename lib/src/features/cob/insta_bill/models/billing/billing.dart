// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import '../shared/devedor.dart';
import '../shared/info_adicionais.dart';
import '../shared/valor.dart';
import 'billing_calendario.dart';

/// A class representing a billing information.
class Billing {
  /// The calendar information for the billing.
  BillingCalendario calendario;

  /// The status of the billing.
  String status;

  /// The transaction id of the billing.
  String txid;

  /// The revision number of the billing.
  int revisao;

  /// The location of the billing.
  String location;

  /// The debtor information for the billing.
  Devedor devedor;

  /// The value information for the billing.
  Valor valor;

  /// The key of the billing.
  String chave;

  /// The payer request for the billing.
  String solicitacaoPagador;

  /// Additional information for the billing.
  List<InfoAdicionais> infoAdicionais;

  /// The qrcode for the billing.
  String brcode;

  /// Creates a [Billing] instance.
  Billing({
    required this.calendario,
    required this.status,
    required this.txid,
    required this.revisao,
    required this.location,
    required this.devedor,
    required this.valor,
    required this.chave,
    required this.solicitacaoPagador,
    required this.infoAdicionais,
    required this.brcode,
  });

  /// Returns a [Map] representation of the [Billing] instance.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'calendario': calendario.toMap(),
      'status': status,
      'txid': txid,
      'revisao': revisao,
      'location': location,
      'devedor': devedor.toMap(),
      'valor': valor.toMap(),
      'chave': chave,
      'solicitacaoPagador': solicitacaoPagador,
      'infoAdicionais': infoAdicionais.map((x) => x.toMap()).toList(),
      'brcode': brcode,
    };
  }

  /// Creates a [Billing] instance from a [Map] representation.
  factory Billing.fromMap(Map<String, dynamic> map) {
    return Billing(
      calendario:
          BillingCalendario.fromMap(map['calendario'] as Map<String, dynamic>),
      status: map['status'] as String,
      txid: map['txid'] as String,
      revisao: map['revisao'] as int,
      location: map['location'] as String,
      devedor: Devedor.fromMap(map['devedor'] as Map<String, dynamic>),
      valor: Valor.fromMap(map['valor'] as Map<String, dynamic>),
      chave: map['chave'] as String,
      solicitacaoPagador: map['solicitacaoPagador'] as String,
      infoAdicionais: List<InfoAdicionais>.from(
        (map['infoAdicionais'] as List<dynamic>).map<InfoAdicionais>(
          (x) => InfoAdicionais.fromMap(x),
        ),
      ),
      brcode: map['brcode'] as String,
    );
  }

  /// Returns a JSON representation of the [Billing] instance.
  String toJson() => json.encode(toMap());

  /// Creates a [Billing] instance from a JSON representation.
  factory Billing.fromJson(String source) =>
      Billing.fromMap(json.decode(source) as Map<String, dynamic>);
}
