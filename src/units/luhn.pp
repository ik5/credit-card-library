(*
    Luhn algorithm implementation Copyright (C) 2009 Ido Kanner (LINESIP)

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
unit Luhn;

interface

{
  The function return the sum that created by the algorithm.
  With that people can calculate valid Credit Card number (for example).

  Parameters:
     * ANumber   - The number to be chekced (it can be padded by 0 on the left, and we need to keep it).
     * MaxLength - If MaxLength is bigger then 0 and the String is smaller in length then MaxLength,
                   then the number will be padded on the left with 0.
   
   Return:
     The sum of ANumber
}
function sum_numbers(const ANumber : String; MaxLength : Integer = 0) : Integer;

{
   The function validates if a number if it works properly when using the Luhn algorithm.

   Parameters:
     * ANumber   - The number to be chekced (it can be padded by 0 on the left, and we need to keep it).
     * MaxLength - If MaxLength is bigger then 0 and the String is smaller in length then MaxLength,
                   then the number will be padded on the left with 0.
   
   Return:
     * True  - Valid number according to the algorithm (result mod 10 = 0).
     * False - Invalid number according to the algorithm (result mod 10 != 0).
}
function validate(const ANumber : String; MaxLength : Integer = 0) : Boolean; inline;

implementation
uses
{$IFDEF FPC}
     StrUtils,
{$ENDIF}
     SysUtils;

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

{
  remove chars that are not listed in a charset

  Parameters:
    * AString - The string we wish to go over
    * charset - The charset of allowed chars 
               (chars that are not part of charset will not be included in the result)
 
  Return:
    A string with only valid chars
}
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

(*

From wikipedia: http://en.wikipedia.org/wiki/Luhn_algorithm

The formula verifies a number against its included check digit, which is usually appended to a partial account number to generate the full account number. This account number must pass the following test:

   1. Counting from the check digit, which is the rightmost, and moving left, double the value of every second digit.
   2. Sum the digits of the products together with the undoubled digits from the original number.
   3. If the total ends in 0 (put another way, if the total modulus 10 is congruent to 0), then the number is valid according to the Luhn formula; else it is not valid.

As an illustration, if the account number is 49927398716, it will be validated as follows:

   1. Double every second digit, from the rightmost: (1×2) = 2, (8×2) = 16, (3×2) = 6, (2×2) = 4, (9×2) = 18
   2. Sum all digits (digits in parentheses are the products from Step 1): 6 + (2) + 7 + (1+6) + 9 + (6) + 7 + (4) + 9 + (1+8) + 4 = 70
   3. Take the sum modulo 10: 70 mod 10 = 0; the account number is valid.

*)

function sum_numbers(const ANumber : String; MaxLength : Integer = 0) : Integer;
var
  num        : String;   // the numbers we are working on
  digit      : Byte;     // the digit that we extracted from num
  i          : integer;  // the loop value
  rotated    : Byte;     // internal storage for rotate_mul
  num_length : Integer;  // the length of num

 function rotate_mul : Byte; inline; // rotate multiple value ...
 begin
   // internal use of rotated. It was defined in the parent function
   // in order to store the content for every usage of the for loop.
   if rotated = 1 then      
     rotated := 2
   else
     rotated := 1;

   Result := rotated; // return the value of rotated.
 end;

begin
  result     := 0;
  rotated    := 0;                              // For the first time we need it to return us 1, so we trick it to do so
  num        := TrimChars(ANumber, ['0'..'9']); // remove nun number chars from ANumber and store it in num
  if num = '' then
    Exit(-1);
  num_length := length(num);                    // store the length of num

  if (MaxLength > 0) and (num_length < MaxLength) then // Should we padd left with 0 ?
   begin
    num        := AddChar('0', num, MaxLength); // place 0 in the beginning of the missing numbers
    num_length := MaxLength;                    // store the new length of num (it will be the same as MaxLength)
   end;
   
  for i := num_length downto 1 do // go from right to left, and not from left to right
    begin
      digit := StrToInt(num[i]) * rotate_mul; // Take the corrent number and multiple it either in 1 or in 2.
      if digit  > 9 then // if we have a number bigger then 10
        digit := (digit div 10) + (digit mod 10); // we take the left side and add the right side of the number (1+2 for 12)

      inc(result, digit); // Add the digit to the result
    end;
end;

function validate(const ANumber : String; MaxLength : Integer = 0) : Boolean; inline;
begin
  // validate the number returned from sum_numbers does not have a reminder
  // if it have, then the number is not valid
  Result := (sum_numbers(ANumber, MaxLength) mod 10) = 0;
end;


end.
