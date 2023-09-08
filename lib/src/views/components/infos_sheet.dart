import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imc_flutter/src/classes/config.dart';
import 'package:imc_flutter/src/services/config_service.dart';

class InfosSheet extends StatefulWidget {
  const InfosSheet({super.key});

  @override
  State<InfosSheet> createState() => _InfosSheetState();
}

class _InfosSheetState extends State<InfosSheet> {
  final _nomeController = TextEditingController();
  final _alturaController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final config = await ConfigService.instance.getConfig();

      if (config != null) {
        _nomeController.text = config.nome;
        _alturaController.text = (config.altura * 100).toStringAsFixed(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Configurações'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              "Informe seus dados e acompanhe seu IMC:",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _nomeController,
              onChanged: (value) => setState(() {}),
              decoration: InputDecoration(
                labelText: 'Nome',
                border: const OutlineInputBorder(),
                errorText: _nomeController.text.isEmpty
                    ? "Nome não pode ser vazio!"
                    : null,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _alturaController,
              onChanged: (value) => setState(() {}),
              maxLength: 3,
              decoration: InputDecoration(
                labelText: 'Altura (cm)',
                border: const OutlineInputBorder(),
                errorText: _validarEmpty(_alturaController, "Altura inválida!"),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _nomeController.text.isNotEmpty &&
                      _alturaController.text.isNotEmpty
                  ? _saveInfos
                  : null,
              child: const Text('SALVAR INFORMAÇÕES'),
            ),
          ],
        ),
      ),
    );
  }

  String? _validarEmpty(
    TextEditingController controller,
    String mensagemErro,
  ) {
    String text = controller.text;
    text = text.replaceAll(",", ".");

    if (text.isNotEmpty && (double.tryParse(text) == null)) {
      return mensagemErro;
    }

    if (text.isNotEmpty && double.tryParse(text)! == 0) {
      return "O valor deve ser maior que zero!";
    }

    return null;
  }

  void _saveInfos() async {
    String nome = _nomeController.text;
    int altura = int.tryParse(_alturaController.text) ?? 0;

    if (altura == 0 || nome.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(nome.isEmpty
              ? 'O nome não pode ser vazio!'
              : 'A altura deve ser maior que zero!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      ConfigInfo config = ConfigInfo(nome: nome, altura: altura / 100);

      await ConfigService.instance.setConfig(config);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${config.nome} seus dados foram salvos com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao salvar informações!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
