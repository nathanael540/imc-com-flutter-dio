import 'package:intl/intl.dart';

class IMC {
  final double peso;
  final double altura;
  final DateTime data;

  IMC({
    required this.peso,
    required this.altura,
    required this.data,
  }) : assert(peso > 0 && altura > 0);

  String get imc => value.toStringAsFixed(2);

  String get dataDeCadastro => DateFormat('dd/MM/yyyy').format(data);

  double get value {
    return peso / (altura * altura);
  }

  String get description {
    if (value < 16) {
      return 'Magreza grave';
    } else if (value < 17) {
      return 'Magreza moderada';
    } else if (value < 18.5) {
      return 'Magreza leve';
    } else if (value < 25) {
      return 'Saudável';
    } else if (value < 30) {
      return 'Sobrepeso';
    } else if (value < 35) {
      return 'Obesidade Grau I';
    } else if (value < 40) {
      return 'Obesidade Grau II (severa)';
    } else {
      return 'Obesidade Grau III (mórbida)';
    }
  }
}
