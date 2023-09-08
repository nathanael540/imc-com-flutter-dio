import 'dart:convert';

class ConfigInfo {
  String nome;
  double altura;

  ConfigInfo({
    required this.nome,
    required this.altura,
  }) : assert(nome.isNotEmpty && altura > 0);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nome': nome,
      'altura': altura,
    };
  }

  factory ConfigInfo.fromMap(Map<String, dynamic> map) {
    return ConfigInfo(
      nome: map['nome'] as String,
      altura: map['altura'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory ConfigInfo.fromJson(String source) =>
      ConfigInfo.fromMap(json.decode(source) as Map<String, dynamic>);
}
