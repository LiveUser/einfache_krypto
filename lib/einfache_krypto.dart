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
      //Make it 2 if its less than 2
      if(number < 2){
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
  int p;
  int q;
  int N;
  int phi;//Φ
  //Encryption key
  int e;
  //Decryption key
  int d = 0;
  CipherGen({@required String password,@required MakePrime securityLevel}){
    List<int> bytes = password.codeUnits;
    //Function for finding primes
    if(bytes.length == 1){
      p = MakePrime(bytes.first).primeNumber;
      q = MakePrime(bytes.first).primeNumber;
    }else if(bytes.length % 2 == 0){
      int middle = (bytes.length / 2).floor();
      //Increase by one the middle if the number of numbers is uneven
      if(bytes.length % 2 == 1){
        middle++;
      }
      //Calculate p by concatenating numbers
      String pString = '';
      for(int i = 0; i < middle; i++){
        pString += bytes[i].toString();
      }
      //Calculate q by concatenating numbers
      String qString = '';
      for(int i = middle; i < bytes.length; i++){
        qString += bytes[i].toString();
      }
      p = int.parse(pString);
      q = int.parse(qString);
      //If numbers aren't prime make them
      p = MakePrime(p).primeNumber;
      q = MakePrime(q).primeNumber;
    }
    print('p = $p \nq = $q');
    //Calculate N
    N = p * q;
    print('N = $N');
    //Calculate phi Φ
    phi = (p-1) * (q - 1);
    print('phi = $phi');
    //Calculate e(Int between 1 and phi)
      //Find the largest value on the List
      int largestNumber = 0;
      bytes.forEach((number) {
        if(largestNumber < number){
          largestNumber = number;
        }
      });
    print('Largest int on the list is $largestNumber');
    e = ((bytes.last / largestNumber) * phi).round();
    //Make sure the number is at least 1
    e = 1 <= e ? e : 1;
    //Make e prime
    e = MakePrime(e).primeNumber;
    print('e = $e');
    //Choose a d
      //Find the number n time where e * d (mod phi) == 1
    int timesFound = 0;
    while(timesFound != securityLevel.primeNumber){
      int checking = (e * d) % phi;
      //If found one equal to one add it
      print('$e x $d % $phi = $checking');
      if(checking == 1){
        timesFound++;
      }
      //Add only if I have to keep iterating
      if(timesFound != securityLevel.primeNumber){
        d++;
      }
      print('$d. Found: $timesFound/${securityLevel.primeNumber}');
    }
    //End of key variables generation
  }
}

/// Cryptographic Library. API Functions.
// ignore: camel_case_types
class Einfache_Krypto {
  //Encrypts the given data using a password and security key. The bigger the security key number the safer it is but the longer it takes to compute.
  static List<int> cipher({@required List<int> data,@required String password,@required int securityLevel}){
    //Generate the numbers for the variables
    CipherGen generated = CipherGen(password: password,securityLevel: MakePrime(securityLevel));
    //Translate the password string to number
    //Generate private and public keys
    return data;
  }
  static List<int> decipher({@required List<int> data,@required String password}){
    //Return decrypted data
    return data;
  }
}
