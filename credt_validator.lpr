(*
    credit card validation library Copyright (C) 2009 Ido Kanner (LINESIP)

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
library credt_validator;

{$mode objfpc}{$H+}{$PACKRECORDS C}{$MACRO ON}
  {$IFDEF UNIX}
    {$CALLING CDECL}
  {$ENDIF}

uses
  Classes, sysutils
  { you can add units after this }, creditcard_validity,
  luhn;

{$IFDEF WINDOWS}{$R credt_validator.rc}{$ENDIF}

const
  cMasterCard      = $0;
  cVisa            = $1;
  cAmericanExpress = $2;
  cDiners          = $3;
  cDiscover        = $4;
  ctMaestro        = $5;
  cJCB             = $6;
  cLaser           = $7;
  cSolo            = $8;
  cSwitch          = $9;
  cIsracard        = $A;
  ctUnknown        = $B;

function luhn_10(aNumber : PChar; MaxLength : Integer = 0) : Byte;
var
 S : string;
begin
 S := StrPas(aNumber);
 Result := Byte(luhn.validate(S, MaxLength));
end;



exports
   luhn_10
   ;

begin
end.

