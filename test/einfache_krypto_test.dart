import 'package:flutter_test/flutter_test.dart';
import 'package:einfache_krypto/einfache_krypto.dart';

void main() {
  test('Encrypt and decrypt test', () {
    int password = 27;
    String text = 'H';
    print('Original:$text');
    print('Password: $password');
    List<int> x = Einfache_Krypto.cipher(data: text.codeUnits,password: password,securityLevel: 2);
    print('Cyphered: $x');
    List<int> y = Einfache_Krypto.decipher(data: x, password: password, securityLevel: 2);
    print('Deciphered: $y');
  });
}
