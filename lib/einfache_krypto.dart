library einfache_krypto;
import 'package:meta/meta.dart';
import 'package:optimus_prime/optimus_prime.dart';

///A collection of all the errors that can be thrown by this library
enum CipherError{
  ///Try a bigger password capable of ciphering all of the content
  smallPassword,
  ///No password passed as parameter
  noPassword,
  ///Password is too big for the machine to perform the required computations
  bigPassword,
}

//Generates cryptographic keys
class CipherGen{
  int p = 0;
  int q = 0;
  int N = 0;
  int phi = 0;//Φ
  //Encryption key
  int e = 0;
  //Decryption key
  int d = 0;
  CipherGen({@required int seed,@required int securityLevel}){
    //Calculate p and q
    String password = seed == null ? null : seed.toString();
    if(password.length == 0 || password == null){
      throw CipherError.noPassword;
    }else if(password.length == 1){
      p = int.parse(password);
      p = p.isPrime()?p:OptimusPrime.primeAfter(p);
      q = (p+1).isPrime()? (p+1) : OptimusPrime.primeAfter(p + 1);
    }else{
      int midpoint = (password.length / 2).ceil();
      p = int.parse(password.substring(0,midpoint));
      //Make it prime if it is not
      p = p.isPrime() ? p : OptimusPrime.primeAfter(p); 
      //Parse q
      q = int.parse(password.substring(midpoint,password.length));
      //Make it prime
      q = q.isPrime() ? q : OptimusPrime.primeAfter(q);
      //Make sure that p and q are never the same
      if(p == q){
        q = OptimusPrime.primeAfter(q);
      }
    }
    //print('p = $p \nq = $q');
    //Find the largest value on the password
    int largestNumber = p < q ? q : p;
    int smallestNumber = p < q ? p : q;
    //Calculate N
    N = p * q;
    //print('N = $N');
    //Calculate phi Φ
    phi = (p-1) * (q - 1);
    //print('phi = $phi');
    //Calculate e(Int between 1 and phi)
    //print('Largest int on the list is $largestNumber');
    //Make sure that e is coprime with N and phi
    List<int> possibleE = [];
    for(int i = 1; i <= phi; i++){
      if(i.coprimeWith(phi) && i.coprimeWith(N)){
        if(i.isPrime()){
          possibleE.add(i);
        }
      }
    }
    //There are no numbers that can take the value of the variable e. None within range meet the criteria.
    if(possibleE.length == 0){
      throw CipherError.smallPassword;
    }
    int whichPosition = ((smallestNumber / largestNumber) * (possibleE.length - 1)).floor();
    e = possibleE[whichPosition];
    //print('e = $e');
    //Choose a d
      //Find the number n time where e * d (mod phi) == 1
    int timesFound = 0;
    while(timesFound != securityLevel){
      int checking = (e * d) % phi;
      //If found one equal to one add it
        ////print('$e x $d % $phi = $checking');
      if(checking == 1){
        timesFound++;
      }
      //Add only if I have to keep iterating
      if(timesFound != securityLevel){
        d++;
      }
        ////print('$d. Found: $timesFound/${securityLevel.primeNumber}');
    }
    //print('d = $d');
    //End of key variables generation
  }
}

/// Cryptographic Library. API Functions.
// ignore: camel_case_types
class Einfache_Krypto {
  ///Encrypts the given data using a password and security key. The bigger the security key number the safer it is but the longer it takes to compute.
  static List<int> cipher({@required List<int> data,@required int password,@required int securityLevel}){
    //Generate private and public keys
    CipherGen generated = CipherGen(seed: password,securityLevel: securityLevel);
    //Encrypt the data
    List<int> cipheredData = [];
    for(int i = 0;i < data.length; i++){
      if(data[i] <= generated.N){
        //Encrypt and add
        cipheredData.add(data[i].modPow(generated.e, generated.N));
        //Check that the computer was able to compute, operations that are to big are registered as infinite
        if(cipheredData[i] == double.infinity){
          throw CipherError.bigPassword;
        }
      }else{
        throw CipherError.smallPassword;
      }
    }    
    //Return the encrypted data
    return cipheredData;
  }
  ///Decrypts the given data using a password and security key. The bigger the security key number the safer it is but the longer it takes to compute.
  static List<int> decipher({@required List<int> data,@required int password,@required int securityLevel}){
    //Generate private and public keys
    CipherGen generated = CipherGen(seed: password,securityLevel: securityLevel);
    //Decrypt the data
    List<int> decipheredData = [];
    for(int i = 0;i < data.length; i++){
      //Decrypt and add
      decipheredData.add(data[i].modPow(generated.d, generated.N));
    }
    //Return decrypted data
    return decipheredData;
  }
  ///Generate a password capable of cyphering your data to avoid throwing errors. All numbers smaller than the generated will fail to cipher all the data
  static int adaptivePasswordGeneration(List<int> data){
    int biggestInteger = 0;
    data.forEach((thisNumber) {
      if(biggestInteger < thisNumber){
        biggestInteger = thisNumber;
      }
    });
    //Pick a random factor
    int p = biggestInteger;
    int q = 1;
    //Zeros to make the password valid when it's split in the middle by CipherGen
    String middleZeroes = "";
    int pLength = p.toString().length; 
    if(pLength > 0){
      for(int i = 0; i < (pLength - 1); i++){
        middleZeroes += "0";
      }
    }
    String concatenatedPQ = '$p$middleZeroes$q';
    int password = int.parse(concatenatedPQ);
    return password;
  }
  ///Encrypt your data without handing a shared encryption/decryption key or generation seed, which is the basic asymetric encryption purpose.
  static List<int> asymmetricCipher({@required List<int> data,@required int publicKey,@required int modulo}){
    List<int> cipheredData = [];
    for(int i = 0;i < data.length; i++){
      if(data[i] <= modulo){
        //Encrypt and add
        cipheredData.add(data[i].modPow(publicKey, modulo));
        if(cipheredData[i] == double.infinity){
          throw CipherError.bigPassword;
        }
      }else{
        throw CipherError.smallPassword;
      }
    }
    //Return the encrypted data
    return cipheredData;
  }
  ///Decrypt your data without handing the private key or generation seeds to decrypt it, which is the basic asymetric encryption purpose.
  static List<int> asymmetricDecipher({@required List<int> data,@required int privateKey,@required int modulo}){
    //Decrypt the data
    List<int> decipheredData = [];
    for(int i = 0;i < data.length; i++){
      //Decrypt and add
      decipheredData.add(data[i].modPow(privateKey, modulo));
    }
    //Return decrypted data
    return decipheredData;
  }
}