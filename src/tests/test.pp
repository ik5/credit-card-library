program test_case;
uses creditcard_validity;
{
 The test cases where taken from:
 https://www.paypal.com/en_US/vhelp/paypalmanager_help/credit_card_numbers.htm
 http://www.darkcoding.net/credit-card-numbers/

 And a credit card number generator:
 http://www.darkcoding.net/credit-card-generator/
}

type
  TNumbers = record
               Number : String;
               Name   : String;
             end;

const
// This list is only for valid credit card number that where generated randomlly
  NumberList : array[0..93] of TNumbers =
   (
      // American Express
     (Number : '371771713512447';  Name : 'American Express'),
     (Number : '379223928879973';  Name : 'American Express'),
     (Number : '372167848994429';  Name : 'American Express'),
     (Number : '370022462062361';  Name : 'American Express'),
     (Number : '341919908570335';  Name : 'American Express'),
     (Number : '378282246310005';  Name : 'American Express'),
     (Number : '371449635398431';  Name : 'American Express'),
     (Number : '378734493671000';  Name : 'American Express'),
     (Number : '379827610563644';  Name : 'American Express'),
     (Number : '372082132867654';  Name : 'American Express'),
     (Number : '379449366986554';  Name : 'American Express'),
     (Number : '341982181404689';  Name : 'American Express'),
     (Number : '344561765158817';  Name : 'American Express'),

     // Mastercard
     (Number : '5551416012310520';  Name : 'MasterCard'),
     (Number : '5479799029026810';  Name : 'MasterCard'),
     (Number : '5375976218361639';  Name : 'MasterCard'),
     (Number : '5206895824941862';  Name : 'MasterCard'),
     (Number : '5292790411258314';  Name : 'MasterCard'),
     (Number : '5192160119468980';  Name : 'MasterCard'),
     (Number : '5385565507622567';  Name : 'MasterCard'),
     (Number : '5527946405392926';  Name : 'MasterCard'),
     (Number : '5148703870095644';  Name : 'MasterCard'),
     (Number : '5305809540079378';  Name : 'MasterCard'),
     (Number : '5555555555554444';  Name : 'MasterCard'),
     (Number : '5105105105105100';  Name : 'MasterCard'),
     (Number : '5148694234131813';  Name : 'MasterCard'),
     (Number : '5298919644637143';  Name : 'MasterCard'),
     (Number : '5287368024892832';  Name : 'MasterCard'),
     (Number : '5347055554779491';  Name : 'MasterCard'),
     (Number : '5352949268055945';  Name : 'MasterCard'),
     (Number : '5395585950515793';  Name : 'MasterCard'),
     (Number : '5206897578382566';  Name : 'MasterCard'),
     (Number : '5398938883511412';  Name : 'MasterCard'),
     (Number : '5510653626525651';  Name : 'MasterCard'),
     (Number : '5463596840887083';  Name : 'MasterCard'),

     // Visa
     (Number : '4716766025785646';  Name : 'Visa'),
     (Number : '4556101389827136';  Name : 'Visa'),
     (Number : '4929963567559371';  Name : 'Visa'),
     (Number : '4716658127924696';  Name : 'Visa'),
     (Number : '4024007198674706';  Name : 'Visa'),
     (Number : '4058663373320918';  Name : 'Visa'),
     (Number : '4929188281466576';  Name : 'Visa'),
     (Number : '4556912093971196';  Name : 'Visa'),
     (Number : '4916114720531742';  Name : 'Visa'),
     (Number : '4486940591521242';  Name : 'Visa'),
     (Number : '4486836683505';     Name : 'Visa'),
     (Number : '4698653996303';     Name : 'Visa'),
     (Number : '4486875217181';     Name : 'Visa'),
     (Number : '4539262710778';     Name : 'Visa'),
     (Number : '4929768903151';     Name : 'Visa'),
     (Number : '4556574935415970';  Name : 'Visa'),
     (Number : '4916907779181743';  Name : 'Visa'),
     (Number : '4539598204043405';  Name : 'Visa'),
     (Number : '4716672341433277';  Name : 'Visa'),
     (Number : '4132998725571291';  Name : 'Visa'),
     (Number : '4916094278041916';  Name : 'Visa'),
     (Number : '4532269147402119';  Name : 'Visa'),
     (Number : '4556712716095039';  Name : 'Visa'),
     (Number : '4556569962564039';  Name : 'Visa'),
     (Number : '4556602209427593';  Name : 'Visa'),
     (Number : '4024007183870';     Name : 'Visa'),
     (Number : '4916814843812';     Name : 'Visa'),
     (Number : '4929778366829';     Name : 'Visa'),
     (Number : '4929312821966';     Name : 'Visa'),
     (Number : '4916863997170';     Name : 'Visa'),
     (Number : '4111111111111111';  Name : 'Visa'),
     (Number : '4012888888881881';  Name : 'Visa'),
     (Number : '4222222222222';     Name : 'Visa'),

     // Diners
     (Number : '30302780947895';  Name : 'Diners Club Carte Blanche'),
     (Number : '30132053644626';  Name : 'Diners Club Carte Blanche'),
     (Number : '36327429110153';  Name : 'Diners Club International'),
     (Number : '30285274876987';  Name : 'Diners Club Carte Blanche'),
     (Number : '30396359650526';  Name : 'Diners Club Carte Blanche'),
     (Number : '30106808279979';  Name : 'Diners Club Carte Blanche'),

     // Discover
     (Number : '6011111111111117';  Name : 'Discover'),
     (Number : '6011000990139424';  Name : 'Discover'),
     (Number : '6011673893278414';  Name : 'Discover'),
     (Number : '6011461008863654';  Name : 'Discover'),
     (Number : '6011488133053786';  Name : 'Discover'),

     //JCB Warning: For now it seems not to support this numbers
     (Number : '210053967836276';   Name : 'JCB'),
     (Number : '180002760682805';   Name : 'JCB'),
     (Number : '180030035470771';   Name : 'JCB'),
     (Number : '3158178989165137';  Name : 'JCB'),
     (Number : '3112493803158969';  Name : 'JCB'),
     (Number : '3158232021913564';  Name : 'JCB'),
     (Number : '3530111333300000';  Name : 'JCB'),
     (Number : '3566002020360505';  Name : 'JCB'),
     (Number : '180069215922466';   Name : 'JCB'),
     (Number : '210051633913867';   Name : 'JCB'),
     (Number : '180007679304490';   Name : 'JCB'),
     (Number : '3112210277889915';  Name : 'JCB'),
     (Number : '3337904127916709';  Name : 'JCB'),
     (Number : '3088411424446480';  Name : 'JCB'),

     // Switch
     (Number : '6331101999990016';  Name : 'Switch')

     //(Number : '';  Name : ''),
   );

procedure print_valid(aNumber : TNumbers);
const cValid : array[Boolean] of string = ('invalid', 'valid');

begin
  write(aNumber.Name, ' number ' );
  write(aNumber.number, ' is ');
  writeln(cValid[IsValidStructureAndNumber(aNumber.number, aNumber.Name)]);
end;

var
  i : integer;

begin
  for i := 0 to High(NumberList) do
    begin
      print_valid(NumberList[i]);
    end;
end.

