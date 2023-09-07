import 'package:flutter/material.dart';
import 'package:imc_flutter/src/classes/imc.dart';
import 'package:imc_flutter/src/services/imc_service.dart';
import 'package:imc_flutter/src/views/pages/add_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de IMC'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            elevation: 10,
            builder: (context) => const AddPage(),
          );

          // ignore: use_build_context_synchronously
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) =>
                  const HomePage(),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        },
        child: FutureBuilder(
          future: ImcService().getIMCs(),
          builder: (context, AsyncSnapshot<List<IMC>> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final imcs = snapshot.data;
            if (imcs == null || imcs.isEmpty) {
              return const Center(
                child: Text('Nenhum IMC cadastrado!'),
              );
            }

            return ListView.builder(
              itemCount: imcs.length,
              itemBuilder: (context, index) {
                final imc = imcs[index];

                return ListTile(
                  leading: imc.value > 16 && imc.value < 30
                      ? const CircleAvatar(
                          backgroundColor: Colors.green,
                          child: Icon(Icons.check, color: Colors.white),
                        )
                      : const CircleAvatar(
                          backgroundColor: Colors.red,
                          child: Icon(Icons.close, color: Colors.white),
                        ),
                  subtitle: Text(
                    "Peso: ${imc.peso} kg x Altura: ${(imc.altura * 100).toStringAsFixed(0)} cm",
                  ),
                  title: Text(
                    imc.description,
                  ),
                  trailing: Text(
                    imc.value.toStringAsFixed(2),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
