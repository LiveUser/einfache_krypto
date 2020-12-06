# einfache_krypto

RSA Cryptography library with ease of use at its core.

Hecho en 🇵🇷 por Radamés J. Valentín Reyes

# API functions

Note: You must always convert your data to a List<int> in order to pass it as argument. securityLevel must always be greater than or equal to one. To decipher content you always need to use the same password and security level with which you encrypted it.

Ciphering:
~~~dart
Einfache_Krypto.cipher(data: data,password: password,securityLevel: 2);
~~~
Deciphering:
~~~dart
Einfache_Krypto.decipher(data: x, password: password, securityLevel: 2);
~~~
Key Generation:

Returns an object with all of the RSA required variable values. You can access such values using the dot notation on the object.

~~~dart
CipherGen(seed: password,securityLevel: securityLevel);
~~~
Adaptable password generation:

Generates a password that adapts to the data so that it can completely cypher it by generating a password that avoids getting problems where data values are larger than the modulo mentioned in the technical limitations section.

~~~dart
Einfache_Krypto.adaptivePasswordGeneration(data: myData);//Returns the password as an int
~~~
# Library Use Example

## Encryption and Decryption Sample

~~~dart
//Define a password
int password = 2434;
//Convert the data to a list of integers
List<int> data = 'Hello Cyphered World'.codeUnits;
//Print the original text
print('Original: ${String.fromCharCodes(data)}');
//Cypher the data
List<int> x = Einfache_Krypto.cipher(data: data,password: password,securityLevel: 2);
//Print the cyphered data
print('Cyphered: ${String.fromCharCodes(x)}');
//Decipher the data
List<int> y = Einfache_Krypto.decipher(data: x, password: password, securityLevel: 2);
//Print decyphered data
print('Deciphered: ${String.fromCharCodes(y)}');
~~~

## Key Generation:

Note: All of the variables shown in the Eddie Woo videos are available through this object.

~~~dart
//Generate Key pairs
CipherGen generated = CipherGen(seed: password,securityLevel: securityLevel);
//Encryption key
print(generated.e);
//Mod value(N variable)
print(generated.N);
~~~
## Adaptive Password:

Note: You can use the returned password number or a number bigger that itself to guarantee that all your content can be encrypted.

~~~dart
List<int> data = 'Hello Cyphered World from Puerto Rico'.codeUnits;
int password = Einfache_Krypto.adaptivePasswordGeneration(data);
List<int> encrypted = Einfache_Krypto.cipher(data: data, password: password, securityLevel: 2);
List<int> decrypted = Einfache_Krypto.decipher(data: encrypted, password: password, securityLevel: 2);
print('Generated adaptive password is "$password"');
print('Decrypted test: ${String.fromCharCodes(decrypted)}');
~~~

## References
I was able to understand the RSA method and create this library thanks to this marvelous learning resource. Check out eddie woo's YouTube channel.

- [The RSA Encryption Algorithm (1 of 2: Computing an Example) - YouTube](https://www.youtube.com/watch?v=4zahvcJ9glg)
- [The RSA Encryption Algorithm (2 of 2: Generating the Keys) - YouTube](https://www.youtube.com/watch?v=oOcTVTpUsPQ)

# Technical Limitations

Note: Take into account that all data is always read by the program as numbers. Your password is a seed for all of the RSA variables that need to be generated.

- You cannot encrypt a number greater than the modulo. Modulo is generated on the background using your password.
  - [Explanaintion on this link](https://crypto.stackexchange.com/questions/3798/why-rsa-cant-handle-numbers-above-76/3800#:~:text=By definition you cannot encrypt,modulo n which loses information.&text=So with your n%3D77,equal in Z%2FnZ.)
- If the password is too small. The range to pick a number for the variable e may be so small that it may not contain any  number that meets the necessary criteria to use RSA encryption. Example: using 12 for the password parameter will throw you an error using this library.
- Using as password extremely big  numbers may generate numbers that are too big for your computer/device or client's computer/device to handle, because RSA relies on raising the numbers they will grow at exponential levels. Note: There is no implementation on this library to detect and throw such error.

