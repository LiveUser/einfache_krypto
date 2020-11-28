import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:einfache_krypto/einfache_krypto.dart';

void main() {
  test('Encrypt text', () {
    Uint8List x = Einfache_Krypto.cipher(data: 'H'.codeUnits,password: 'S');
    print(String.fromCharCodes(x));
  });
}
