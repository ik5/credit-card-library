(*
    credit card validation unit Copyright (C) 2009 Ido Kanner (LINESIP)

    This library is free software; you can redistribute it and/or modify it
    under the terms of the GNU Lesser General Public License as published by the
    Free Software Foundation; either version 2.1 of the License, or (at your
    option) any later version.

    This library is distributed in the hope that it will be useful, but WITHOUT
    ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
    FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License
    for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with this library; if not, write to the Free Software Foundation,
    Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
*)
{$MODE OBJFPC}
unit creditcard_validity;

interface

type
 (* most of the credit cards on this list where taken from the following links:
    http://en.wikipedia.org/wiki/Credit_card_number
    https://www.paypal.com/en_US/vhelp/paypalmanager_help/credit_card_numbers.htm
*)
                    // Global/American
  CreditCardType = (cctMasterCard,
                    cctVisa,
                    cctAmericanExpress,
                    cctDiners,
                    cctDiscover,
                    cctMaestro,

                    // Japan
                    cctJCB,

                    //Irland
                    cctLaser,

                    // U.K.
                    cctSolo,
                    cctSwitch,

                    // Israel
                    cctIsracard,

                    cctUnknown);

type
  TCreditCardPrefix     = array of Cardinal;
  TCredtCardLength      = array of Word;
  TCreditCardValidation = function (const aNumber : string; MaxLength : Integer = 0) : Boolean;

type
  TNumberValidationRecord = record
                              Name                : String;                 // The string name of the rule, you can like that
                                                                            // create a sub types of Visa, Diners, MasterCards etc...
                                                                            // The string is case insensitive
                              CreditType          : CreditCardType;         // The type of the credit card
                              Prefix              : TCreditCardPrefix;      // The prefix numbers of valid credit cards
                              NumberLength        : TCredtCardLength;       // The valid length of numbers for the credit card number
                              Validation          : TCreditCardValidation;  // The validation function for this credit card
                            end;

{
  Register a creditCard record to the system.

  Parameters:
    * CreditCard - A record that stores the rules for the credit card

  Returns:
    Returns the index number of the registered record

  Warning:
    This function does not update existed credit card that is already registered,
    it will add the updated record as a new one.
}
function RegisterCreditCard(CreditCard : TNumberValidationRecord) : Integer;

{
  Override exsited record of a credit card with a new one.

  Parameters:
    * CreditCard - The credit card record that replaces the old one
    * aID        - The id of the record to be changed

  Throw Exception if the aID is out of range
}
procedure UpdateRegisteredCreditCard(CreditCard : TNumberValidationRecord; aID : integer);

{
  Unregister a credit card record by it's index number.

  Parameters:
    * ID - The record id of the credit card

  Throw Exception if the aID is out of range
}
procedure UnregisterCreditCard(const ID : Integer);

{
  Unregister a credit card record by it's name.

  parameters:
    * aName - the name of the credit card to be unregistered

  Throw Exception if the aID is out of range

  Note: This method is more accurate if you create sub types of credit cards.
}
procedure UnregisterCreditCard(aName : String);

{
   Finds the index of a credit card name

   Parameters:
     * aName - The name of the credit card

   Returns:
     The index number of the registered credit card or -1 if not found
}
function FindCreditCardName(const aName : String) : integer;

{
   Finds the index of a credit card type

   Parameters:
     * aType - The type of the credit card

   Returns:
     The index number of the registered credit card or -1 if not found
}
function FindCreditCardType(const aType : CreditCardType) : integer;

{
 This function checks if a number belongs to a specific credit card company.
  Note: It does *NOT* validate the number itself, only the structure of the number

  Parameters:
   * aNumber - The credit card number
   * aID     - The index of the credit card

  Return:
   * True  - The credit card number have the right structure for the requested type
   * False - The structure is wrong to the type of credt card
}
function IsCreditType(const aNumber : String; aID : integer) : Boolean;

{
  This function checks if a number belongs to a specific credit card company.
  Note: It does *NOT* validate the number itself, only the structure of the number

  Parameters:
   * aNumber - The credit card number
   * aType   - The credit card type

  Return:
   * True  - The credit card number have the right structure for the requested type
   * False - The structure is wrong to the type of credt card
}
function IsCreditType(const aNumber : String; aType : CreditCardType) : Boolean; inline;

{
  This function checks if a number belongs to a specific credit card company.
  Note: It does *NOT* validate the number itself, only the structure of the number

  Parameters:
   * aNumber - The credit card number
   * aName   - The name of the credit card as registed

  Return:
   * True  - The credit card number have the right structure for the requested type
   * False - The structure is wrong to the type of credt card
}
function IsCreditType(const aNumber : String; aName : String) : Boolean; inline;

{
  The function check to see if the number structure passes the checksum tests (such as luhn).
  Note: It does not check the validity of the credit card number, or if the number actually belongs to that company.

  Parameters:
    * aNumber - The credit card number to check
    * aID     - The index of the credit card that was registered

  Return:
    * True  - The checksum passed
    * False - The checksum did not passed
}
function IsValidCreditCardNumber(const aNumber : String; aID : Integer) : Boolean;

{
  The function check to see if the number structure passes the checksum tests (such as luhn).
  Note: It does not check the validity of the credit card number, or if the number actually belongs to that company.

  Parameters:
    * aNumber - The credit card number to check
    * aType   - The type of the credit card

  Return:
    * True  - The checksum passed
    * False - The checksum did not passed
}
function IsValidCreditCardNumber(const aNumber : String; aType : CreditCardType) : Boolean; inline;

{
  The function check to see if the number structure passes the checksum tests (such as luhn).
  Note: It does not check the validity of the credit card number, or if the number actually belongs to that company.

  Parameters:
    * aNumber - The credit card number to check
    * aName   - The name of the credit card as registed

  Return:
    * True  - The checksum passed
    * False - The checksum did not passed
}
function IsValidCreditCardNumber(const aNumber : String; aName : String) : Boolean; inline;

{
  The function validate the number structure and checksum

  Parameters:
    * aNumber - The credit card number to check
    * aID     - The index of the credit card that was registered

  Return:
    * True  - The number is valid
    * False - The number is invalid
}
function IsValidStructureAndNumber(const aNumber : String; aID : Integer) : Boolean;

{
 The function validate the number structure and checksum

  Parameters:
    * aNumber - The credit card number to check
    * aType   - The type of the credit card

  Return:
    * True  - The number is valid
    * False - The number is invalid
}
function IsValidStructureAndNumber(const aNumber : String; aType : CreditCardType) : Boolean; inline;

{
 The function validate the number structure and checksum

  Parameters:
    * aNumber - The credit card number to check
    * aName   - The name of the credit card as registed

  Return:
    * True  - The number is valid
    * False - The number is invalid
}
function IsValidStructureAndNumber(const aNumber : String; aName : String) : Boolean; inline;

{
  Check to see if the credit card name already registered

  Parameters:
    * aName   - The name of the credit card as registered

  Return:
    * True  - The credit card is registered
    * False - The credit card is not registered
}
function IsCreditNameRegistered(aName : String) : Boolean; inline;

{
  Check to see if a given number is a valid Isracard number structure.
  This function does not uses Luhn, because Isracard uses different
  algorithm in order to validate a proper structure.

  Parameters:
     * ANumber   - The number to be chekced (it can be padded by 0 on the left, and we need to keep it).
     * MaxLength - Is not in use, but exists for API purpose

   Return:
     * True  - Valid number according to the algorithm
     * False - Invalid number according to the algorithm
}
function IsracardValidNumber(const aNumber : string; MaxLength : Integer = 0) : Boolean;

implementation
uses SysUtils, Luhn
{$IFDEF FPC}
     , strutils
{$ENDIF}
;

{$IFNDEF FPC}
function AddChar(Ch: Char; const S: string; N: Integer): string;
var
 Len : Integer;
begin
  Len    := Length(S);

  if Len < N then
    Result := StringOfChar(Ch, N-len) + S;
  else
    Result := S;
end;

{$ENDIF}

type
  TCharSet = set of Char;

function TrimChars(const AString : String; charset : TCharset) : String; inline;
var
  i : integer;
begin
  Result := '';
  for i := 1 to Length(Astring) do     // go over AString
    begin
      if AString[i] in charset then    // does our current char exists at the charset ?
        Result := Result + AString[i]; // if so, then lets store it
    end;
end;

var
  CreditCardList  : array of TNumberValidationRecord;
  RegisteredCards : Integer;

function RegisterCreditCard(CreditCard : TNumberValidationRecord) : Integer;
begin
  if RegisteredCards = Ord(High(CreditCardList)) then
    SetLength(CreditCardList, Length(CreditCardList) + 1);

  inc(RegisteredCards);
  CreditCardList[RegisteredCards] := CreditCard;
  Result := RegisteredCards;
end;

procedure UpdateRegisteredCreditCard(CreditCard : TNumberValidationRecord; aID : integer);
begin
  if not aID in [0..RegisteredCards] then
    raise Exception.CreateFmt('The ID (%d) of the credit card is out side of range.', [aID]);

  CreditCardList[aID] := CreditCard;
end;

procedure UnregisterCreditCard(const ID : Integer);
var
  i             : integer;
  start, finish : integer;
begin
  if not ID in [0..RegisteredCards] then
    raise Exception.CreateFmt('The ID (%d) of the credit card is out side of range.', [ID]);

  start  := 0;
  finish := RegisteredCards;
  case ID of
    0               : begin
                       Start  := 1;
                      end;
    else begin
          if ID = RegisteredCards then
            Start  := RegisteredCards
          else
            start := ID + 1;
         end;
  end;

  for i := start to finish do
   begin
     CreditCardList[i - 1] := CreditCardList[i];
   end;

   dec(RegisteredCards);
   SetLength(CreditCardList, RegisteredCards);
end;

function FindCreditCardName(const aName : String) : integer;
var
  i : integer;
begin
 Result := -1;

 for i := 0 to RegisteredCards do
   begin
     if AnsiCompareText(CreditCardList[i].Name, aName) = 0 then
       begin
         Result := i;
         break;
       end;
   end;
end;

function FindCreditCardType(const aType : CreditCardType) : integer;
var
  i : integer;
begin
  Result := -1;

  for i := 0 to RegisteredCards do
   begin
     if CreditCardList[i].CreditType = aType then
       begin
         Result := i;
         break;
       end;
   end;

end;

procedure UnregisterCreditCard(aName : String);
var
  i     : integer;
begin
  i := FindCreditCardName(aName);

  if i >= 0 then
    UnregisterCreditCard(i);
end;

function IsCreditType(const aNumber : String; aID : Integer) : boolean;
var
  i     : integer;
  found : Boolean;
  len   : integer;
  num   : string;
  s     : string;
begin
  if (aID < 0) or (aID > RegisteredCards) then
    Exit(False);

  num   := TrimChars(aNumber, ['0'..'9']);

  found := false;
  len   := Length(num);

  for i := Low(CreditCardList[aID].NumberLength) to High(CreditCardList[aID].NumberLength) do
   begin
     if CreditCardList[aID].NumberLength[i] = len then
       begin
         found := true;
         break;
       end;
   end;

  if not found then
    exit(False);

  // Unknown prefix, so we do not need to check further
  if Length(CreditCardList[aID].Prefix) = 0 then
    Exit(True);

  found := false;


  for i := Low(CreditCardList[aID].Prefix) to High(CreditCardList[aID].Prefix) do
    begin
      s := copy(num, 1, length(IntToStr(CreditCardList[aID].Prefix[i])));
      if StrToInt(s) = CreditCardList[aID].Prefix[i] then
        begin
          found := true;
          break;
        end;
    end;

  Result := found;
end;

function IsCreditType(const aNumber : String; aType : CreditCardType) : Boolean; inline;
var
  idx   : integer;
begin
  idx    := FindCreditCardType(aType);
  Result := IsCreditType(aNumber, idx);
end;

function IsCreditType(const aNumber : String; aName : String) : Boolean; inline;
var
  idx : integer;
begin
  idx    := FindCreditCardName(aName);
  Result := IsCreditType(aNumber, idx);
end;

function IsValidCreditCardNumber(const aNumber : String; aID : Integer) : Boolean;
begin
  if (aID < 0) or (aID > RegisteredCards) then
    Exit(False);

  Result := CreditCardList[aID].Validation(aNumber);
end;

function IsValidCreditCardNumber(const aNumber : String; aType : CreditCardType) : Boolean; inline;
var
  idx : integer;
begin
  idx    := FindCreditCardType(aType);
  Result := IsValidCreditCardNumber(aNumber, idx);
end;

function IsValidCreditCardNumber(const aNumber : String; aName : String) : Boolean; inline;
var
  idx : integer;
begin
  idx    := FindCreditCardName(aName);
  Result := IsValidCreditCardNumber(aNumber, idx);
end;

function IsValidStructureAndNumber(const aNumber : String; aID : Integer) : Boolean;
begin
  if (aID < 0) or (aID > RegisteredCards) then
    Exit(False);

  Result := IsCreditType(aNumber, aID) and IsValidCreditCardNumber(aNumber, aID);
end;

function IsValidStructureAndNumber(const aNumber : String; aType : CreditCardType) : Boolean; inline;
var
  idx : integer;
begin
  idx    := FindCreditCardType(aType);
  Result := IsValidStructureAndNumber(aNumber, idx);
end;

function IsValidStructureAndNumber(const aNumber : String; aName : String) : Boolean; inline;
var
  idx : integer;
begin
  idx    := FindCreditCardName(aName);
  Result := IsValidStructureAndNumber(aNumber, idx);
end;

function IsCreditNameRegistered(aName : String) : Boolean; inline;
begin
  Result := FindCreditCardName(aName) >= 0;
end;

function IsracardValidNumber(const aNumber : string; MaxLength : Integer = 0) : Boolean;
const
  MultipleTable : array[1..9] of Byte =
    (9, 8, 7, 6, 5, 4, 3, 2, 1);
var
  num   : String;
  len   : integer;
  i     : byte;
  tmp   : byte;
  total : byte;
begin
  num := TrimChars(aNumber, ['0'..'9']);

  if (num = '') or (Length(num) > 9) then
    Exit(False);

  num   := AddChar('0', num, 9);
  len   := Length(num);
  total := 0;
  for i := 1 to len do
    begin
      tmp := StrToInt(num[i]) * MultipleTable[i];
      inc(total, tmp);
    end;

  result := (total mod 11) = 0;
end;

procedure InitList;

function PopulateRecord(aName       : String;                aCreditType   : CreditCardType;
                        aPrefix     : Array of Cardinal;     aNumberLength : Array of Word;
                        aValidation : TCreditCardValidation                                    ) : TNumberValidationRecord;
var
  i               : integer;
begin
  with Result do
    begin
     Name         := aName;
     CreditType   := aCreditType;
     SetLength(Prefix, Length(aPrefix));
     SetLength(NumberLength, Length(aNumberLength));
     for i := Low(aPrefix)       to High(aPrefix)       do Prefix[i]       := aPrefix[i];
     for i := Low(aNumberLength) to High(aNumberLength) do NumberLength[i] := aNumberLength[i];
     validation   := aValidation;
    end;
end;

type
  TRange = array of cardinal;

function GetRange(aFrom, aTo : Cardinal) : TRange;
var
  c : integer;
  i : cardinal;
begin
  SetLength(Result, (aTo - aFrom) + 1);
  c := 0;
  for i := aFrom to aTo do
    begin
      Result[c] := i;
      inc(c);
    end;
end;

var
 i, c : cardinal;
 arr  : TRange;

// Information was taken from: http://en.wikipedia.org/wiki/Credit_card_numbers

begin
  RegisterCreditCard(PopulateRecord('MasterCard', cctMasterCard, [51, 52, 53, 54, 55], [16], @validate));
  RegisterCreditCard(PopulateRecord('Visa', cctVisa, [4], [13,16], @validate));
  RegisterCreditCard(PopulateRecord('Visa Electron', cctVisa, [417500, 4917,4913,4508,4844], [16], @validate));
  RegisterCreditCard(PopulateRecord('American Express', cctAmericanExpress, [34, 37], [15], @validate));
  RegisterCreditCard(PopulateRecord('Diners Club Carte Blanche', cctDiners, [300, 301, 302, 303, 304, 305], [14], @validate));
  RegisterCreditCard(PopulateRecord('Diners Club International', cctDiners, [36], [14], @validate));
  RegisterCreditCard(PopulateRecord('Diners Club US and Canada', cctDiners, [54, 55], [16], @validate));

  // There is a big range (799 numbers) to be added, so here is a small code to do it
  SetLength(arr, 806);
  arr[0] := 6011;
  c := 1;
  for i := 622126 to 622925 do
    begin
      arr[c] := i;
      inc(c);
    end;

  for i := 644 to 649 do
    begin
      arr[c] := i;
      inc(c);
    end;

  arr[c] := 65;

  RegisterCreditCard(PopulateRecord('Discover', cctDiscover, arr, [16], @validate)); //Adding the 806 numbers
  RegisterCreditCard(PopulateRecord('JCB', cctJCB, GetRange(3528, 3589), [16], @validate));

  RegisterCreditCard(PopulateRecord('Laser', cctLaser, [6304, 6706, 6771, 6709], [16, 17, 18, 19], @validate));
  RegisterCreditCard(PopulateRecord('Maestro', cctMaestro, [5018,5020,5038,6304,6759,6761], [12, 13, 14, 15, 16, 17, 18, 19], @validate));
  RegisterCreditCard(PopulateRecord('Solo', cctSolo, [6334, 6767], [16,18,19], @validate));
  RegisterCreditCard(PopulateRecord('Switch', cctSwitch, [4903,4905,4911,4936,564182,633110,6333,6759], [16,18,19], @validate));
  RegisterCreditCard(PopulateRecord('Isracard', cctIsracard, [], [8, 9], @IsracardValidNumber));

end;

initialization
  SetLength(CreditCardList, Ord(high(CreditCardType)));
  RegisteredCards := -1;
  InitList;
end.
