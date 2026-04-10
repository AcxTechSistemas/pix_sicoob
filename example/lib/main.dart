import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:pix_sicoob/pix_sicoob.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? certificateBase64String;
  bool isCertificateLoaded = false;
  String? loadError;
  Map<String, dynamic>? config;

  Future<List<Pix>>? transactionsFuture;
  late PixSicoob pixSicoob;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    try {
      final configString = await rootBundle.loadString('assets/config.json');
      setState(() {
        config = json.decode(configString);
      });
    } catch (e) {
      setState(() {
        loadError =
            'Arquivo assets/config.json não encontrado. Crie um baseado no config_example.json';
      });
    }
  }

  Future<void> _loadCertificate() async {
    if (config == null) return;

    setState(() {
      loadError = null;
    });
    try {
      final certPath = config!['certificatePath'];
      final certPassword = config!['certificatePassword'];
      final clientID = config!['clientID'];

      final certData = await rootBundle.load(certPath);
      final bytes = certData.buffer.asUint8List();
      certificateBase64String = base64Encode(bytes);

      pixSicoob = PixSicoob(
        clientID: clientID,
        certificateBase64String: certificateBase64String!,
        certificatePassword: certPassword,
      );

      setState(() {
        isCertificateLoaded = true;
      });
    } catch (e) {
      setState(() {
        loadError = e.toString();
        isCertificateLoaded = false;
      });
    }
  }

  void _fetchTransactions() {
    setState(() {
      transactionsFuture = _doFetchTransactions();
    });
  }

  Future<List<Pix>> _doFetchTransactions() async {
    final token = (await pixSicoob.getToken()).getOrThrow();
    final listPix =
        (await pixSicoob.fetchTransactions(token: token)).getOrThrow();
    return listPix;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Api Pix V2 Sicoob'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (config == null)
              Card(
                color: Colors.orange.shade100,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Icon(Icons.warning, color: Colors.orange, size: 48),
                      const SizedBox(height: 8),
                      Text(
                        loadError ?? 'Carregando configuração...',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              )
            else if (!isCertificateLoaded) ...[
              ElevatedButton.icon(
                onPressed: _loadCertificate,
                icon: const Icon(Icons.security),
                label: const Text('1. Carregar Certificado e Config'),
                style:
                    ElevatedButton.styleFrom(padding: const EdgeInsets.all(16)),
              ),
              if (loadError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    'Erro:\n$loadError',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
            ] else ...[
              Card(
                color: Colors.green.shade50,
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green),
                      SizedBox(width: 12),
                      Text(
                        'Ambiente Blindado e Pronto!',
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _fetchTransactions,
                icon: const Icon(Icons.list),
                label: const Text('2. Buscar Transações'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: Colors.blue.shade50,
                ),
              ),
            ],
            const SizedBox(height: 24),
            const Divider(),
            const Text(
              'Transações Recentes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: transactionsFuture == null
                  ? const Center(child: Text('Aguardando...'))
                  : FutureBuilder<List<Pix>>(
                      future: transactionsFuture,
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return const Center(
                                child: CircularProgressIndicator());
                          case ConnectionState.done:
                            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                              return ListView.separated(
                                itemCount: snapshot.data!.length,
                                separatorBuilder: (_, __) => const Divider(),
                                itemBuilder: (context, index) {
                                  final transaction = snapshot.data![index];
                                  return ListTile(
                                    leading: const CircleAvatar(
                                        child: Icon(Icons.pix)),
                                    title: Text(transaction.pagador.nome),
                                    subtitle:
                                        Text('Horário: ${transaction.horario}'),
                                    trailing: Text(
                                      'R\$ ${transaction.valor}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else if (snapshot.hasError) {
                              final error = snapshot.error;
                              String errorMessage = error.toString();
                              if (error is PixException) {
                                errorMessage =
                                    '${error.error}\n${error.errorDescription}';
                              }
                              return Center(
                                child: Text(
                                  'Falha:\n$errorMessage',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              );
                            }
                            return const Center(
                                child: Text('Nenhuma transação.'));
                          default:
                            return const SizedBox();
                        }
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
