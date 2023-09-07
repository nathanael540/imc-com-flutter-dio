import 'dart:convert';

class IMC {
  final double peso;
  final double altura;

  IMC({
    required this.peso,
    required this.altura,
  }) : assert(peso > 0 && altura > 0);

  String get imc => value.toStringAsFixed(2);

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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'peso': peso,
      'altura': altura,
    };
  }

  factory IMC.fromMap(Map<String, dynamic> map) {
    return IMC(
      peso: map['peso'] as double,
      altura: map['altura'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory IMC.fromJson(String source) =>
      IMC.fromMap(json.decode(source) as Map<String, dynamic>);
}
