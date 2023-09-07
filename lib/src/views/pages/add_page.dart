import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imc_flutter/src/classes/imc.dart';
import 'package:imc_flutter/src/services/imc_service.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _pesoController = TextEditingController();
  final _alturaController = TextEditingController();

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
              "Informe os dados abaixo para calcular o IMC:",
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
              onPressed: _pesoController.text.isNotEmpty &&
                      _alturaController.text.isNotEmpty
                  ? _addNewImc
                  : null,
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
    int altura = int.tryParse(_alturaController.text) ?? 0;

    if (peso == 0 || altura == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Peso e altura devem ser maiores que zero!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      IMC imc = IMC(peso: peso.toDouble(), altura: altura / 100);

      await ImcService().saveIMC(imc);

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
