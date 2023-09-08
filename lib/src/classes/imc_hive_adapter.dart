import 'package:hive_flutter/hive_flutter.dart';
import 'package:imc_flutter/src/classes/imc.dart';

class IMCHiveAdapter extends TypeAdapter<IMC> {
  @override
  int get typeId => 54;

  @override
  IMC read(BinaryReader reader) {
    return IMC(
      altura: reader.read(),
      peso: reader.read(),
      data: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, IMC obj) {
    writer.write(obj.altura);
    writer.write(obj.peso);
    writer.write(obj.data);
  }
}
