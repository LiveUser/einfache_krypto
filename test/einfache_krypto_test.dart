import 'package:flutter_test/flutter_test.dart';
import 'package:einfache_krypto/einfache_krypto.dart';

void main() {
  test('Encrypt and decrypt test', () {
    int password = 4;
    String text = 'H';
    print('Original:$text');
    print('Password: $password');
    List<int> x = Einfache_Krypto.cipher(data: text.codeUnits,password: password,securityLevel: 1);
    print('Cyphered: ${String.fromCharCodes(x)}');
    List<int> y = Einfache_Krypto.decipher(data: x, password: password, securityLevel: 1);
    print('Deciphered: ${String.fromCharCodes(y)}');
  });
}
