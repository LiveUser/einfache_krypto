# einfache_krypto

RSA Cryptography library with ease of use at its core.

Hecho en 🇵🇷 por Radamés J. Valentín Reyes

# Important notifications

- Do not use any version before Version 1.0.4+2 because there were bugs in them and a lot has changed since.

# API functions

Note: You must always convert your data to a List<int> in order to pass it as argument. securityLevel must always be greater than or equal to one. To decipher content you always need to use the same password and security level with which you encrypted it.

Ciphering:
~~~dart
Einfache_Krypto.cipher(data: data,password: password);
~~~
Deciphering:
~~~dart
Einfache_Krypto.decipher(data: x, password: password);
~~~
Key Generation:

Returns an object with all of the RSA required variable values. You can access such values using the dot notation on the object.

~~~dart
CipherGen(seed: password);
~~~
Adaptable password generation:

Generates a password that adapts to the data so that it can completely cypher it by generating a password that avoids getting problems where data values are larger than the modulo mentioned in the technical limitations section. Its the smallest number that can be used as password seed on the CipherGen class in order to successfully cipher the data.

~~~dart
Einfache_Krypto.adaptivePasswordGeneration(data: myData);//Returns the password as an int
~~~
Asymmetric Encryption:

~~~dart
Einfache_Krypto.asymmetricCipher(data: myData, publicKey: publicKey, modulo: modulo);
~~~
Asymmetric Decryption:
~~~dart
Einfache_Krypto.asymmetricDecipher(data: encryptedData, privateKey: privateKey, modulo: modulo);
~~~

Catching errors
~~~dart
try{
  //Library operations go here
  CipherGen(seed: 12);
}catch(err){
   //Error handling goes here
  if(err == CipherError.bigPassword){
      //Do this
  }else{
      //Do that
  }
}
~~~

# Library Use Example

## Symmetric Encryption and Decryption Sample

~~~dart
//Define a password
int password = 2434;
//Convert the data to a list of integers
List<int> data = 'Hello Cyphered World'.codeUnits;
//Print the original text
print('Original: ${String.fromCharCodes(data)}');
//Cypher the data
List<int> x = Einfache_Krypto.cipher(data: data,password: password);
//Print the cyphered data
print('Cyphered: ${String.fromCharCodes(x)}');
//Decipher the data
List<int> y = Einfache_Krypto.decipher(data: x, password: password);
//Print decyphered data
print('Deciphered: ${String.fromCharCodes(y)}');
~~~

## Key Generation:

All of the variables required for the RSA method shown in the Eddie Woo videos are generated and available through this object. All of the values are generated using an integer as seed.

~~~dart
//Generate Key pairs
CipherGen generated = CipherGen(seed: password);
//Encryption key
print(generated.e);
//Mod value(N variable)
print(generated.N);
~~~

## Advanced Key Generation:

A class that provides a more granular control over key generation(CipherGen class is a simplified version of this).

### Save the object into a variable:

~~~dart
//Save the class in a variable
AdvancedCipherGen key = AdvancedCipherGen();
~~~

### Step 1:

Generate the possible encryption key values based on the provided p and q variable values

~~~dart
//Perform the first step to generate the possible encryption key values for the given p q
List<int> possibleE = key.step1(p: 17, q: 22);
~~~

### Step 2: (Last step, key is ready to be used)

Select the encryption key by providing the index of the desired key.

~~~dart
//Perform second step
key.step2(eIndex: (possibleE.length - 1).floor());
~~~

### Full demo:

~~~dart
//Save the class in a variable
AdvancedCipherGen key = AdvancedCipherGen();
//Perform the first step to generate the possible encryption key values for the given p q
List<int> possibleE = key.step1(p: -5, q: 22);
//Encryption keys to pick from
print(possibleE);
//Perform second step
key.step2(eIndex: (possibleE.length - 1).floor());
print("Encryption key: ${key.e}");
print("Decryption key: ${key.d}");
print("Phi(N): ${key.phi}");
print("Modulo: ${key.N}");
~~~



## Adaptive Password:

Note: You can use the returned password number or a number bigger that itself to guarantee that all your content can be encrypted.

~~~dart
List<int> data = 'Hello from Puerto Rico Cyphered World'.codeUnits;
int password = Einfache_Krypto.adaptivePasswordGeneration(data);
List<int> encrypted = Einfache_Krypto.cipher(data: data, password: password);
List<int> decrypted = Einfache_Krypto.decipher(data: encrypted, password: password);
print('Generated adaptive password is "$password"');
print('Decrypted test: ${String.fromCharCodes(decrypted)}');
~~~
## Asymmetric Encryption Sample:

Note: You can use your previously generated private and public keys with this methods. Using CipherGen() to generate the keys is completely unnecessary and its used in this example just to generate a valid encryption decryption key pairs.

~~~dart
List<int> myData = 'Hallo Freunde'.codeUnits;
print('Original: ${String.fromCharCodes(myData)}');
CipherGen generatedKeys = CipherGen(seed: Einfache_Krypto.adaptivePasswordGeneration(myData));
List<int> encrypted = Einfache_Krypto.asymmetricCipher(data: myData, publicKey: generatedKeys.e, modulo: generatedKeys.N);
List<int> decrypted = Einfache_Krypto.asymmetricDecipher(data: encrypted, privateKey: generatedKeys.d, modulo: generatedKeys.N);
print('Asymetric decryption result: ${String.fromCharCodes(decrypted)}');
~~~



## References
I was able to understand the RSA method and create this library thanks to this marvelous learning resource. Check out eddie woo's YouTube channel.

- [The RSA Encryption Algorithm (1 of 2: Computing an Example) - YouTube](https://www.youtube.com/watch?v=4zahvcJ9glg)
- [The RSA Encryption Algorithm (2 of 2: Generating the Keys) - YouTube](https://www.youtube.com/watch?v=oOcTVTpUsPQ)

I managed to find the RSA decryption key thanks to this [stackoverflow question/thread](https://stackoverflow.com/questions/16310871/how-to-find-d-given-p-q-and-e-in-rsa). 💘 Stack Overflow.

# Technical Limitations

Note: Take into account that all data is always read by the program as numbers. Your password is a seed for all of the RSA variables that need to be generated.

- You cannot encrypt a number greater than the modulo. Modulo is generated on the background using your password(seed) or p and q values if you are using AdvancedKeyGen(modulo(variable N) is the product of p and q). After generating the key you can access all of the variables through dot notation on the key object.
  - [Explanaintion on this link](https://crypto.stackexchange.com/questions/3798/why-rsa-cant-handle-numbers-above-76/3800#:~:text=By definition you cannot encrypt,modulo n which loses information.&text=So with your n%3D77,equal in Z%2FnZ.)
- If the password is too small. The range to pick a number for the variable e may be so small that it may not contain any  number that meets the necessary criteria to use RSA encryption. Example: using 12 for the password parameter on CipherGen will throw you an error using this library.
- Using as password extremely big  numbers may generate numbers that are too big for your computer/device or client's computer/device to handle, because RSA relies on raising the numbers they will grow exponentially which means that your device may not be able to perform the necessary computation. In such case the library will throw an error.
- Even though the RSA cryptography method requires you to provide two prime numbers for p and q this library takes care of converting any input into prime numbers so that you don't have to care about that(any integer is a valid input).

