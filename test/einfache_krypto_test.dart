import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:einfache_krypto/einfache_krypto.dart';

void main() {
  test('Encrypt text', () {
    List<int> x = Einfache_Krypto.cipher(data: 'H'.codeUnits,password: 'S',securityLevel: 2);
    print(String.fromCharCodes(x));
  });
}
