library einfache_krypto;
import 'package:flutter/material.dart';

class CipherGen{
  int p;
  int q;
  int N;
  int phi;//Φ
  //Encryption key
  int e;
  //Decryption key
  int d = 0;
  CipherGen(String password){
    List<int> bytes = password.codeUnits;
    //Function for finding primes
    bool isPrime(int number){
    if(number % 2 == 1 || number == 2){
        //Its prime
        return true;
      }else{
        //Its not prime
        return false;
      }
    }
    if(bytes.length == 1){
      p = p;
      q = q;
      //If numbers aren't prime make them
      if(!isPrime(p)){
        p++;
        q++;
      }
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
      if(!isPrime(p)){
        p++;
      }
      if(!isPrime(q)){
        q++;
      }
    }
    //Calculate N
    N = p * q;
    //Calculate phi Φ
    phi = (p-1) * (q - 1);
    //Calculate e(Int between 1 and phi)
      //Find the largest value on the List
      int largestNumber = 0;
      bytes.forEach((number) {
        if(largestNumber < number){
          largestNumber = number;
        }
      });
    e = ((bytes.last / largestNumber) * phi).round();
    //Make sure the number is at least 1
    e = 1 <= e ? e : 1;
    //Choose a d
      //Find the number n time where e * d (mod phi) == 1
    int timesFound = 0;
    int n = bytes.first;
    while(timesFound != n){
      int checking = (e * d) % phi;
      //If found one equal to one add it
      if(checking == 1){
        timesFound++;
      }
      //Add only if I have to keep iterating
      if(timesFound != n){
        d++;
      }
    }
    //End of key variables generation
  }
}

/// Cryptographic Library
class Einfache_Krypto {
  static List<int> cipher({@required List<int> data,@required String password}){
    //Generate the numbers for the variables
    CipherGen generated = CipherGen(password);
    print(password.codeUnits);
    print(generated);
    //Translate the password string to number
    //Generate private and public keys
    return data;
  }
  static List<int> decipher({@required List<int> data,@required String password}){
    //Return decrypted data
    return data;
  }
}
