library einfache_krypto;
import 'package:flutter/material.dart';
import 'package:optimus_prime/optimus_prime.dart';
import 'dart:math';

//TODO: Remove all print() statements before publishing
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
    String password = seed.toString();
    if(password.length == 0 || password == null){
      throw 'Password seed with no integers or null';
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
      throw 'Password seed is too small. Pick a bigger number';
    }
    int whichPosition = ((smallestNumber / largestNumber) * possibleE.length).floor();
    e = possibleE[whichPosition];
    print('e = $e');
    //Choose a d
      //Find the number n time where e * d (mod phi) == 1
    int timesFound = 0;
    while(timesFound != securityLevel){
      int checking = (e * d) % phi;
      //If found one equal to one add it
        //print('$e x $d % $phi = $checking');
      if(checking == 1){
        timesFound++;
      }
      //Add only if I have to keep iterating
      if(timesFound != securityLevel){
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
    CipherGen generated = CipherGen(seed: password,securityLevel: securityLevel);
    //Encrypt the data
    List<int> cipheredData = [];
    for(int i = 0;i < data.length; i++){
      if(data[i] <= generated.N){
        //Encrypt and add
        cipheredData.add(data[i].modPow(generated.e, generated.N));
      }else{
        throw 'Password seed generated a small modulo(N value). You have to pick a bigger password int.';
      }
    }
    //Return the encrypted data
    return cipheredData;
  }
  static List<int> decipher({@required List<int> data,@required int password,@required int securityLevel}){
    //Generate private and public keys
    CipherGen generated = CipherGen(seed: password,securityLevel: securityLevel);
    //Decrypt the data
    List<int> decipheredData = [];
    for(int i = 0;i < data.length; i++){
      if(data[i] <= generated.N){
        //Encrypt and add
        decipheredData.add(data[i].modPow(generated.d, generated.N));
      }else{
        throw 'Password seed generated a small modulo(N value). You have to pick a bigger password int.';
      }
    }
    //Return decrypted data
    return decipheredData;
  }
  //Generate a password capable of cyphering your data to avoid getting any thrown errors
  static int adaptivePasswordGeneration(List<int> data){
    int biggestInteger = 0;
    data.forEach((thisNumber) {
      if(biggestInteger < thisNumber){
        biggestInteger = thisNumber;
      }
    });
    //Calculate all of the factors
    List<int> factors = [];
    int midpoint = (biggestInteger / 2).floor();
    for(int i = 1; i < midpoint; i++){
      if(biggestInteger % i == 0 && i.isPrime()){
        factors.add(i);
      }
    }
    print('Factors: $factors');
    //Pick a random factor
    int p = factors[Random().nextInt(factors.length)];
    //Find the other number with whi
    int q = (biggestInteger / p).round();
    String concatenatedPQ = '$p$q';
    int password = int.parse(concatenatedPQ);
    return password;
  }
}
//TODO: You need a larger number as password. RSA doeesn\'t work if the generated modulo(variable N) is smaller than the number you are trying to encrypt
