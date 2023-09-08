import 'package:flutter/material.dart';
import 'package:imc_flutter/src/classes/imc.dart';

class ImcTile extends StatelessWidget {
  final IMC imc;

  const ImcTile({
    super.key,
    required this.imc,
  });

  @override
  Widget build(BuildContext context) {
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
      title: Text(
        "${imc.description} (${imc.value.toStringAsFixed(2)})",
      ),
      subtitle: Text(
        "Peso: ${imc.peso} kg | Altura: ${(imc.altura * 100).toStringAsFixed(0)} cm",
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.deepPurple),
          color: Colors.deepPurple.withOpacity(0.1),
        ),
        child: Text(
          imc.dataDeCadastro,
          style: const TextStyle(color: Colors.deepPurple, fontSize: 12),
        ),
      ),
    );
  }
}
