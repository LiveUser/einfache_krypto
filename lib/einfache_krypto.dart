library einfache_krypto;
import 'package:optimus_prime/optimus_prime.dart';

///A collection of all the errors that can be thrown by this library
enum CipherError{
  ///Try a bigger password capable of ciphering all of the content
  smallPassword,
  ///No password passed as parameter
  noPassword,
  ///Password is too big for the machine to perform the required computations
  bigPassword,
  ///eIndex is out of range
  eOutOfRange,
  ///dIndex is out of range. dIndex must be equal to or greater than 1
  dOutOfRange,
}

///Generates cryptographic keys using a more simplified, predictable manner
class CipherGen{
  int? get  p => _pValue;
  int? _pValue;
  int? get q => _qValue;
  int? _qValue;
  int? get N => _N;
  int? _N;
  int? get phi => _phi;//Φ
  int? _phi;
  //Encryption key
  int? get e => _e;
  int? _e;
  //Decryption key
  int? get d => _d;
  int? _d;
  CipherGen({required int seed}){
    //Calculate p and q
    String password = seed.toString();
    if(password.length == 0 || password == null){
      throw CipherError.noPassword;
    }else if(password.length == 1){
      _pValue = int.parse(password);
      _pValue = _pValue!.isPrime()? _pValue : OptimusPrime.primeAfter(_pValue!);
      _qValue = (_pValue! + 1).isPrime()? (_pValue! + 1) : OptimusPrime.primeAfter(_pValue! + 1);
    }else{
      int midpoint = (password.length / 2).ceil();
      _pValue = int.parse(password.substring(0,midpoint));
      //Make it prime if it is not
      _pValue = _pValue!.isPrime() ? _pValue : OptimusPrime.primeAfter(_pValue!); 
      //Parse q
      _qValue = int.parse(password.substring(midpoint,password.length));
      //Make it prime
      _qValue = _qValue!.isPrime() ? _qValue : OptimusPrime.primeAfter(_qValue!);
      //Make sure that p and q are never the same
      if(_pValue == _qValue){
        _qValue = OptimusPrime.primeAfter(_qValue!);
      }
    }
    //print('p = $p \nq = $q');
    //Find the largest value on the password
    int largestNumber = _pValue! < _qValue! ? _qValue! : _pValue!;
    int smallestNumber = _pValue! < _qValue! ? _pValue! : _qValue!;
    //Calculate N
    _N = _pValue! * _qValue!;
    //print('N = $N');
    //Calculate phi Φ
    _phi = (_pValue! - 1) * (_qValue! - 1);
    //print('phi = $phi');
    //Calculate e(Int between 1 and phi)
    //print('Largest int on the list is $largestNumber');
    //Make sure that e is coprime with N and phi
    List<int> possibleE = [];
    for(int i = 2; i < phi!; i++){
      if(i.coprimeWith(phi!) && i.coprimeWith(N!)){
        possibleE.add(i);
      }
    }
    //There are no numbers that can take the value of the variable e. None within range meet the criteria.
    if(possibleE.length == 0){
      throw CipherError.smallPassword;
    }
    int whichPosition = ((smallestNumber / largestNumber) * (possibleE.length - 1)).round();
    _e = possibleE[whichPosition];
    //print('e = $e');
    //Choose a d
      //Find the number n time where e * d (mod phi) == 1
    _d = e!.modInverse(phi!);
    //print('d = $d');
    //End of key variables generation
  }
}
///Advanced more secure key generation
class AdvancedCipherGen{
  int? get p => _pValue;
  int? _pValue;
  int? get q => _qValue;
  int? _qValue;
  int? get N => _N;
  int? _N;
  int? get phi => _phi;//Φ
  int? _phi;
  //Encryption key
  int? get e => _e;
  int? _e;
  //Decryption key
  int? get d => _d;
  int? _d;
  //Numbers that could take the value of e
  List<int> _possibleE = [];
  ///Sets p and q variables. Makes them different prime numbers and generates the necessary data for the next step.
  List<int> step1({
    required int p,
    required int q,
  }){
    //TODO: Problem may have to do with p and q not beign turned into prime when they are not prime. Find alternative to renaming the parameters name
    //Make the numbers prime if they are not and save them internally
    _pValue = p;
    _qValue = q;
    if(_pValue!.isPrime() == false){
      _pValue = OptimusPrime.primeAfter(_pValue!);
    }
    if(_qValue!.isPrime() == false){
      _qValue = OptimusPrime.primeAfter(_qValue!);
    }
    //Make sure that p and q are not the same
    if(_pValue == _qValue){
      _qValue = OptimusPrime.primeAfter(_qValue!);
    }
    //Calculate N
    _N = _pValue! * _qValue!;
    //Calculate Φ(N)
    _phi = (_pValue! - 1) * (_qValue! - 1);
    //Empty the possible e list
    _possibleE = [];
    //Find and save possible values for e
    for(int i = 2; i < phi!; i++){
      if(i.coprimeWith(phi!) && i.coprimeWith(N!)){
        _possibleE.add(i);
      }
    }
    //Return the possible values for e
    return _possibleE;
  }
  ///Generates the decryption number
  void step2({
    ///Index of the chosen possible e value
    required int eIndex,
  }){
    //Throw an error if the index is out of range
    if( eIndex < 0 || _possibleE.length <= eIndex){
      throw CipherError.eOutOfRange;
    }
    //Assign e
    _e = _possibleE[eIndex];
    //Find d and assign it
    _d = this.e!.modInverse(phi!);
  }
}

/// Cryptographic Library. API Functions.
// ignore: camel_case_types
class Einfache_Krypto {
  ///Encrypts the given data using a password and security key. The bigger the security key number the safer it is but the longer it takes to compute.
  static List<int> cipher({required List<int> data,required int password}){
    //Generate private and public keys
    CipherGen generated = CipherGen(seed: password);
    //Encrypt the data
    List<int> cipheredData = [];
    for(int i = 0;i < data.length; i++){
      if(data[i] <= generated.N!){
        //Encrypt and add
        cipheredData.add(data[i].modPow(generated.e!, generated.N!));
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
  static List<int> decipher({required List<int> data,required int password}){
    //Generate private and public keys
    CipherGen generated = CipherGen(seed: password);
    //Decrypt the data
    List<int> decipheredData = [];
    for(int i = 0;i < data.length; i++){
      //Decrypt and add
      decipheredData.add(data[i].modPow(generated.d!, generated.N!));
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
  static List<int> asymmetricCipher({required List<int> data,required int? publicKey,required int? modulo}){
    List<int> cipheredData = [];
    for(int i = 0;i < data.length; i++){
      if(data[i] <= modulo!){
        //Encrypt and add
        cipheredData.add(data[i].modPow(publicKey!, modulo));
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
  static List<int> asymmetricDecipher({required List<int> data,required int? privateKey,required int? modulo}){
    //Decrypt the data
    List<int> decipheredData = [];
    for(int i = 0;i < data.length; i++){
      //Decrypt and add
      decipheredData.add(data[i].modPow(privateKey!, modulo!));
    }
    //Return decrypted data
    return decipheredData;
  }
}