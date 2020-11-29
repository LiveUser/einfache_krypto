library einfache_krypto;
import 'package:flutter/material.dart';

//TODO: Remove all print() statements before publishing
//Check if the number is prime
bool isPrime(int number){
  if(number % 2 == 1 && 2 <= number  || number == 2){
    //Its prime
    return true;
  }else{
    //Its not prime
    return false;
  }
}
//Makes numbers prime if they are not
class MakePrime{
  int primeNumber;
  MakePrime(int number){
    //If number is negative make it positive
    if(number < 0){
      number = number.abs();
    }
    //Make it prime if it is not
    if(!isPrime(number)){
      if(number <= 2){
        number = 2;
      }else{
        //Make it prime if it is not
        number++;
      }
    }
    //If its not prime make it
    this.primeNumber = number;
  }
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
  CipherGen({@required int seed,@required MakePrime securityLevel}){
    //Calculate p and q
    String password = seed.toString();
    if(password.length == 0 || password == null){
      throw 'Password seed with no integers or null';
    }else if(password.length == 1){
      p = int.parse(password);
      p = MakePrime(p).primeNumber;
      q = p % 2 == 0? p + 1 : p + 2;
    }else{
      int midpoint = (password.length / 2).ceil();
      p = MakePrime(int.parse(password.substring(0,midpoint))).primeNumber;
      q = MakePrime(int.parse(password.substring(midpoint,password.length))).primeNumber;
      //Make sure that p and q are never the same
      if(p == q){
        q = p % 2 == 0? p + 1 : p + 2;
      }
    }
    print('p = $p \nq = $q');
    //Find the largest value on the password
    int largestNumber = p < q ? q : p;
    int smallestNumber = p < q ? p : q;
    //Calculate N
    N = p * q;
    print('N = $N');
    //Calculate phi Φ
    phi = (p-1) * (q - 1);
    print('phi = $phi');
    //Calculate e(Int between 1 and phi)
    print('Largest int on the list is $largestNumber');
    e = ((smallestNumber / largestNumber) * phi).floor();
    //Make e prime
    e = MakePrime(e).primeNumber;
    print('e = $e');
    //Choose a d
      //Find the number n time where e * d (mod phi) == 1
    int timesFound = 0;
    while(timesFound != securityLevel.primeNumber){
      int checking = (e * d) % phi;
      //If found one equal to one add it
        //print('$e x $d % $phi = $checking');
      if(checking == 1){
        timesFound++;
      }
      //Add only if I have to keep iterating
      if(timesFound != securityLevel.primeNumber){
        d++;
      }
        //print('$d. Found: $timesFound/${securityLevel.primeNumber}');
    }
    print('d = $d');
    //End of key variables generation
  }
}

/// Cryptographic Library. API Functions.
// ignore: camel_case_types
class Einfache_Krypto {
  //Encrypts the given data using a password and security key. The bigger the security key number the safer it is but the longer it takes to compute.
  static List<int> cipher({@required List<int> data,@required int password,@required int securityLevel}){
    //Generate private and public keys
    CipherGen generated = CipherGen(seed: password,securityLevel: MakePrime(securityLevel));
    //Encrypt the text
    List<int> cipheredData = [];
    for(int i = 0;i < data.length; i++){
      print('Cipher ${data[i]} -> ${data[i].modPow(generated.e, generated.N)}');
      //Encrypt and add
      cipheredData.add(data[i].modPow(generated.e, generated.N));
    }
    //Return the encrypted data
    return cipheredData;
  }
  static List<int> decipher({@required List<int> data,@required int password,@required int securityLevel}){
    //Generate private and public keys
    CipherGen generated = CipherGen(seed: password,securityLevel: MakePrime(securityLevel));
    //Decrypt the text
    List<int> decipheredData = [];
    for(int i = 0;i < data.length; i++){
      //Encrypt and add
      decipheredData.add(data[i].modPow(generated.d, generated.N));
    }
    //Return decrypted data
    return decipheredData;
  }
}
