## Version 1.0.5+3 - November 20 2022
* Removed dependency on flutter
## Version 1.0.4+2 - September 29 2021
* Added null safety
* Updated yet again Optimus Prime
## Version 1.0.4+1 - September 28 2021
* Updated the OptimusPrime version(the library for finding primes in which this library depends on)
## Version 1.0.3+3 - September 23 2021
* Switched the .floor() to .round() on the CipherGen class
* Added a notice about the changes stated above
* added the get keyword to the variables stored on the CipherGen and AdvancedCipherGen class to prevent people from setting values. Only getting the value works now.
* Reviewed the libraries created by myself that this project depends on to verify that they were working properly
* Used different variable names(on the CipherGen and AdvancedCipherGen classes(invisible to the library user)) due to the fact that using this.p and this.q as object properties and using the parameter names p and q on a function inside the classes created a name conflict that resulted in the program calculating things the wrong way even though the program was written correctly and employed the use of this keyword to attempt to differentiate between them

## Version 1.0.3+2 - September 21 2021

* Switched the while loop used for finding the decryption key with the formula e.modInverse(phi). Previous attempts had failed results and this solution appears to work. 
* Stopped filtering out the non prime numbers from the possible e values. All of the previous versions of this library allowed only prime numbers to be possible encryption key values.
* Removed the securityLevel and the dInstance arguments due to finding that the method I used previously did not work due to a misinterpretation of the method(my bad🤣)

## Version 1.0.3+1 - September 1 2021
* Added the AdvancedCipherGen class to provide another way for creating RSA keys in order to give the end-user a more granular control over key generation

## Version 1.0.2+1 - August 13 2021
* Yet another attempt to solve the issue with adaptivePasswordGeneration not generating a password capable of ciphering all of the content

## Version 1.0.2+1 - August 5 2021

* Added an enum called CipherError which contains the thrown errors
* adaptivePasswordGeneration was generating passwords that where to small and the algorithm had unnecessary recursion, both errors were fixed.
* The software now throws an error when ciphering content with a password that is too big for the device to compute(throws CipherError.bigPassword)
* Switched my Improvised License for the MIT License on the License file

## Version 1.0.1+2 - January 15 2021
* Change the import from material to meta to enable the use of @required keyword

## Version 1.0.1+1 - December 7 2020
* Added methods for asymetric encryption which is the core purpose of RSA method.

## Version 1.0.0+3 - December 6 2020
* Fix for adaptivePasswordGeneration for when there are no possible factors for generating the password using my previous method. To prevent throwing an unecessary error for which this function was mainly created.

## Version 1.0.0+2 - December 6 2020
* Removed print statements from the library to avoid printing crap into library users console

## Version 1.0.0 - December 6 2020
* All core library functionalities added
* Decent documentation with examples added to the README.md