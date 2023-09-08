import 'package:flutter/material.dart';
import 'package:imc_flutter/src/classes/imc.dart';
import 'package:imc_flutter/src/services/config_service.dart';
import 'package:imc_flutter/src/services/imc_service.dart';

class AddImcSheet extends StatefulWidget {
  const AddImcSheet({super.key});

  @override
  State<AddImcSheet> createState() => _AddImcSheetState();
}

class _AddImcSheetState extends State<AddImcSheet> {
  final _pesoController = TextEditingController();

  // Get da altura direto do Singleton
  double get altura => ConfigService.instance.config!.altura;

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
          title: const Text('Adicionar IMC'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              "Informe seu peso abaixo para salvar o IMC:",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _pesoController,
              maxLength: 3,
              onChanged: (value) => setState(() {}),
              decoration: InputDecoration(
                labelText: 'Peso (kg)',
                border: const OutlineInputBorder(),
                errorText: _validarEmpty(_pesoController, "Peso inválido!"),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: TextEditingController(
                text: (altura * 100).toStringAsFixed(0),
              ),
              enabled: false,
              decoration: const InputDecoration(
                labelText: 'Altura (cm)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pesoController.text.isNotEmpty ? _addNewImc : null,
              child: const Text('SALVAR'),
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

  void _addNewImc() async {
    double peso = double.tryParse(
          _pesoController.text.replaceAll(",", "."),
        ) ??
        0;

    if (peso == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Peso deve ser maior que zero!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      IMC imc = IMC(
        peso: peso.toDouble(),
        altura: altura,
        data: DateTime.now(),
      );

      await ImcService.instance.saveIMC(imc);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('IMC (${imc.description}) salvo com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao salvar IMC!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
