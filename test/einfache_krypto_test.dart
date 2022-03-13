import 'package:flutter_test/flutter_test.dart';
import 'package:einfache_krypto/einfache_krypto.dart';

void main() {
  String separator = "------------------------------------------------------------------------";
  test("CipherGen generated variables", (){
    CipherGen generatedKey = CipherGen(
      seed: 2478,
    );
    print("Generated: e=${generatedKey.e} d=${generatedKey.d} N=${generatedKey.N}");
    print(separator);
  });
  test('Encrypt and decrypt test', () {
    int password = 255001;
    List<int> data = 'Hello Cyphered World'.codeUnits;
    print('Original: ${String.fromCharCodes(data)}');
    List<int> x = Einfache_Krypto.cipher(data: data,password: password);
    print('Cyphered: ${String.fromCharCodes(x)}');
    List<int> y = Einfache_Krypto.decipher(data: x, password: password);
    print('Deciphered: ${String.fromCharCodes(y)}');
    print(separator);
  });
  test('Small Password test: should throw error', (){
    try{
      CipherGen(seed: 12);
    }catch(err){
      print(err);
    }
    print(separator);
  });
  test('Try the adaptive password generation', (){
    List<int> data = 'a'.codeUnits;
    int password = Einfache_Krypto.adaptivePasswordGeneration(data);
    List<int> encrypted = Einfache_Krypto.cipher(data: data, password: password);
    List<int> decrypted = Einfache_Krypto.decipher(data: encrypted, password: password);
    print('Generated adaptive password is "$password"');
    print('Decrypted test: ${String.fromCharCodes(decrypted)}');
    print(separator);
  });
  test('Asymetric functions test', (){
    List<int> myData = 'Hallo Freunde'.codeUnits;
    print('Original: ${String.fromCharCodes(myData)}');
    CipherGen generatedKeys = CipherGen(seed: 21513);
    List<int> encrypted = Einfache_Krypto.asymmetricCipher(data: myData, publicKey: generatedKeys.e, modulo: generatedKeys.N);
    print("Encrypted: ${String.fromCharCodes(encrypted)}");
    List<int> decrypted = Einfache_Krypto.asymmetricDecipher(data: encrypted, privateKey: generatedKeys.d, modulo: generatedKeys.N);
    print('Asymetric decryption result: ${String.fromCharCodes(decrypted)}');
    print(separator);
  });
  test("Advanced Cipher Generation", (){
    //Save the class in a variable
    AdvancedCipherGen key = AdvancedCipherGen();
    //Perform the first step to generate the possible encryption key values for the given p q
    List<int> possibleE = key.step1(p: 6, q: 97);
    print("Possible e:");
    print(possibleE);
    //Perform second step
    key.step2(eIndex: 7);
    print("Encryption key: ${key.e}");
    print("Decryption key: ${key.d}");
    print("Phi(N): ${key.phi}");
    print("Modulo: ${key.N}");
    List<int> myData = 'Hallo Freunde'.codeUnits;
    print("Minimum password required = ${Einfache_Krypto.adaptivePasswordGeneration(myData)}");
    print('Original: ${String.fromCharCodes(myData)}');
    List<int> encrypted = Einfache_Krypto.asymmetricCipher(data: myData, publicKey: key.e, modulo: key.N);
    print("Encrypted: ${String.fromCharCodes(encrypted)}");
    List<int> decrypted = Einfache_Krypto.asymmetricDecipher(data: encrypted, privateKey: key.d, modulo: key.N);
    print('Asymetric decryption result: ${String.fromCharCodes(decrypted)}');
    print(separator);
  });
}