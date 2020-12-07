import 'package:flutter_test/flutter_test.dart';
import 'package:einfache_krypto/einfache_krypto.dart';

void main() {
  test('Encrypt and decrypt test', () {
    int password = 2434;
    List<int> data = 'Hello Cyphered World'.codeUnits;
    print('Original: ${String.fromCharCodes(data)}');
    List<int> x = Einfache_Krypto.cipher(data: data,password: password,securityLevel: 2);
    print('Cyphered: ${String.fromCharCodes(x)}');
    List<int> y = Einfache_Krypto.decipher(data: x, password: password, securityLevel: 2);
    print('Deciphered: ${String.fromCharCodes(y)}');
  });
  test('Small Password test: should throw error', (){
    try{
      CipherGen(seed: 12,securityLevel: 12);
    }catch(err){
      print(err);
    }
  });
  test('Should throw the small modulo error', (){
    try{
      int password = 15;
      List<int> data = [1034];
      print('Original: $data');
      Einfache_Krypto.cipher(data: data,password: password,securityLevel: 2);
    }catch(err){
      print(err);
    }
  });
  test('Try the adaptive password generation', (){
    List<int> data = 'a'.codeUnits;
    int password = Einfache_Krypto.adaptivePasswordGeneration(data);
    List<int> encrypted = Einfache_Krypto.cipher(data: data, password: password, securityLevel: 2);
    List<int> decrypted = Einfache_Krypto.decipher(data: encrypted, password: password, securityLevel: 2);
    print('Generated adaptive password is "$password"');
    print('Decrypted test: ${String.fromCharCodes(decrypted)}');
  });
}
