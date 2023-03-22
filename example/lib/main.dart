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

final pixSicoob = PixSicoob(
  clientID: 'CLIENT_ID',
  certificateBase64String: 'CERT_BASE64_STRING',
  certificatePassword: 'CERTIFICATE_PASSWORD',
);

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Api Pix V2 Sicoob'),
      ),
      body: FutureBuilder(
        future: pixSicoob.getToken().then(
              (token) => pixSicoob.fetchTransactions(
                token: token,
                dateTimeRange: DateTimeRange(
                  start: DateTime.now().subtract(const Duration(days: 30)),
                  end: DateTime.now(),
                ),
              ),
            ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return const Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              if (snapshot.hasData) {
                int length = snapshot.data!.length;

                return RefreshIndicator(
                  onRefresh: () {
                    return Future(() => setState(() {}));
                  },
                  child: ListView.builder(
                    itemCount: length,
                    itemBuilder: (context, index) {
                      final Pix transaction = snapshot.data![index];

                      return ListTile(
                        title: Text(transaction.pagador.nome.split(' ')[0]),
                        subtitle: Text(transaction.valor),
                        trailing: Text(transaction.horario),
                      );
                    },
                  ),
                );
              }
              return const Center(
                child: Text('Nenhuma transação encontrada'),
              );
          }
        },
      ),
    );
  }
}
