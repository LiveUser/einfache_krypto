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