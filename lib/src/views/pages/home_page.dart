import 'package:flutter/material.dart';
import 'package:imc_flutter/src/classes/config.dart';
import 'package:imc_flutter/src/classes/imc.dart';
import 'package:imc_flutter/src/services/config_service.dart';
import 'package:imc_flutter/src/services/imc_service.dart';
import 'package:imc_flutter/src/views/components/add_sheet.dart';
import 'package:imc_flutter/src/views/components/imc_tile_widget.dart';
import 'package:imc_flutter/src/views/components/infos_sheet.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ConfigInfo? get config => ConfigService.instance.config;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de IMC'),
        actions: [
          IconButton(
            onPressed: _configsBottomSheet,
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      floatingActionButton: config == null
          ? FloatingActionButton(
              onPressed: _configsBottomSheet,
              child: const Icon(Icons.settings),
            )
          : FloatingActionButton(
              onPressed: _addNewImcBottomSheet,
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
        child: config == null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'SEM CONFIGURAÇÕES!',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  const Center(
                    child: Text(
                      'Configure seu perfil antes de salvar seus IMCs!',
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              )
            : FutureBuilder(
                future: ImcService.instance.getIMCs(),
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

                      return ImcTile(imc: imc);
                    },
                  );
                },
              ),
      ),
    );
  }

  void _addNewImcBottomSheet() async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      elevation: 10,
      builder: (context) => const AddImcSheet(),
    );

    // ignore: use_build_context_synchronously
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
  }

  void _configsBottomSheet() async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      elevation: 10,
      builder: (context) => const InfosSheet(),
    );

    setState(() {});
  }
}
