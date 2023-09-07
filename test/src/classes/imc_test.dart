import 'package:flutter_test/flutter_test.dart';
import 'package:imc_flutter/src/classes/imc.dart';

void main() {
  test('Calcula o IMC - 80kg | 1.75m', () {
    expect(
      IMC(peso: 80, altura: 1.75).value,
      allOf([greaterThan(26.12), lessThan(26.13)]),
    );
  });

  test('Calcula o IMC - 93kg | 1.76m', () {
    expect(
      IMC(peso: 93, altura: 1.76).value,
      allOf([greaterThan(30.02), lessThan(30.03)]),
    );
  });

  test('Verifica a descrição do IMC - 93kg | 1.76m', () {
    expect(
      IMC(peso: 93, altura: 1.76).description,
      equals('Obesidade Grau I'),
    );
  });

  test('Verifica a descrição do IMC - 80kg | 1.75m', () {
    expect(
      IMC(peso: 80, altura: 1.75).description,
      equals('Sobrepeso'),
    );
  });
}
