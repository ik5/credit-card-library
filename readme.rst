About
=====

The following library contain source code for validating the checksum and structure of known credit cards companies.
This information is released under LGPL and intended to help creating free library for checking validity of credit cards.
The intent in the long run of this library is to be a shard library so all programming languages can use it using binding.
The code does not arrive instead of automatic banking validation systems, but as a measure that should arrive prior of using such system.

Remarks
-------

The following version 0.1 beta is not fully checked, and there are few known problems:
  1. Not a full support for JCB - There is a need for additional information regarding that credit card.
  2. Not a full support for Isracard - There is a need for additional information regarding the allowed prefix of the credit card, and a generator to validate numbers as much as possible.
  3. There are several credit cards that I did not find any generators for, so I did not check them.  
  4. The current list of supported credit cards (including the ones that where not checked yet):
     * MasterCard
     * Visa (13 and 16 in length)
     * Visa Electron
     * American Express
     * Diners Club Carte Blanche
     * Diners Club International
     * Diners Club US and Canada
     * Discover
     * JCB
     * Laser
     * Maestro
     * Solo
     * Switch
     * Isracard

If you have information about additional credit cards or you can help working on existed credit cards, please donate your code to this units so anyone could use your work.

Files included by this package:
  * README                     - This file
  * lgpl-3.0.txt               - The library license
  * src/test.pp                - Some simple tests for the library (work in progress)
  * src/luhn.pp                - Implementation of the Luhn algorithm 
  * src/creditcard_validity.pp - The validation library (contain documentation inside for now -> will be extracted on next versions to an html document using fpdoc)
  
=============================================================================================
= This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; =
= without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. =  
= See the GNU Lesser General Public License for more details.                               =
=                                                                                           =
=    IF YOU DO NOT AGREE WITH THE TERMS OF THE LGPL LICENSE, DO NOT USE THIS LIBRARY !!!    =
=============================================================================================

