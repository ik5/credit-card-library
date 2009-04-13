/*
 * Script Name: ccvalidate.js
 * Written By:  Kevin King                    (Kevin@PrecisOnline.com)
 *              for Precision Solutions, Inc. (http://www.PrecisOnline.com)
 *
 * Date:        28 Oct 2002
 *
 * Description: This script validates the basic accuracy of a credit card 
 *              number.  It expects the card type and card number to have 
 *              been entered/selected, and then the verifyCard function can 
 *              be called to verify the accuracy of the card number.
 *
 *              This script does not ensure that the card is active, so it 
 *              is possible that while the card number is accurate, the card 
 *              itself may have been deactivated by the issuer (i.e. for lost 
 *              or stolen cards).
 *
 *              THIS SOFTWARE IS PROVIDED AS-IS AND AUTHOR PROVIDES NO 
 *              WARRANTIES, EITHER EXPRESSED OR IMPLIED, REGARDING THE 
 *              APPLICABILITY OR FITNESS OF THIS SOFTWARE FOR ANY SPECIFIC 
 *              PURPOSE.
 *
 *              By using this software, you implicitly warrant your use
 *              will conform to normal legitimate business purposes.  Author 
 *              is not responsible for, and will assist authorities in the 
 *              prosecution of, any use of this software that is in violation
 *              of United States or international law.
 *
 *****************************************************************************
 * Modifications
 *****************************************************************************
 * Date.....  Changed By.....  Description of Change..........................
 * 30 Jan 06  Kevin King       Added Australian BankCard support per details
 *                             received from Paul Bronshteyn (thanks again,
 *                             Paul!).
 * 28 Jan 06  Kevin King       Corrected Delta rules as identified by Paul
 *                             Bronshteyn (thanks Paul!).
 * 26 Jan 06  Kevin King       Added checkCvc function to verify CVV/CID values.
 * 20 Jan 06  Kevin King       Updated Maestro and Solo rules per
 *                             http://www.barclaycardmerchantservices.co.uk/existing_customers/operational/pdf/binranges.pdf
 * 16 Mar 05  Kevin King       Updated to add Delta and Maestro card support.
 * 05 Apr 03  Kevin King       Updated SWITCH card validation table.  Added
 *                             support for validating SOLO cards.
 */

var cc_checksum;                   // Number: The calculated checksum for the card
var cc_fail_reason;                // Text: Explains the reason for the failure
var cc_switch_startDateLength;     // Number: Count of digits in start date or 0=no start date  (Switch/SOLO)
var cc_switch_issueLength;         // Number: Count of digits in issue number or 0=no issue number (Switch/SOLO)
var cc_cvc_length;                 // Number: Count of digits in CVV2

/*
 *****************************************************************************
 * Verify the check digit
 *****************************************************************************
 */
  
function luhnCheck(cardNbr)
{
    var result     = true;
  
    var ndx        = cardNbr.length - 1;
    var checkDigit = cardNbr.substr(ndx,1);
    var multiplier = 2;
    var accum      = 0;
  
    while(ndx)
    {
        var cardCh = cardNbr.substr(ndx - 1,1);
        if(cardCh >= 0 && cardCh <= 9)
        {
            var thisValue  = cardCh * multiplier;
            while(thisValue > 0)
            {
                accum += Math.floor(thisValue % 10);
                thisValue = Math.floor(thisValue / 10);
            }

            multiplier = (multiplier == 2 ? 1 : 2);
        }

        ndx--;
    }
  
    cc_checksum = ((10 - (accum % 10)) % 10);
    if(cc_checksum != checkDigit)
        result = false;

    return(result);
}

/*
 *****************************************************************************
 * Verify the card number is all numbers
 *****************************************************************************
 */

function checkDigits(cardNbr)
{
    var result = true;
    var ndx;
  
    for(ndx = 0 ; ndx < cardNbr.length && result ; ++ndx)
    {
        var cardCh = cardNbr.substr(ndx,1);
        if(cardCh < '0' || cardCh > '9')
            result = false;
    }
  
    return(result);
}

/*
 *****************************************************************************
 * Verify the prefix and length is proper for this type of card
 *****************************************************************************
 */
 
function checkPrefixAndLength(cardType, cardNbr)
{
    var result    = false;
  
    var amexRules    = new Array("37,37,15,3","34,34,15,3");
    var discRules    = new Array("6011,6011,16");
    var dinersRules  = new Array("36,36,14","38,38,14","300,305,14");
    var enrouteRules = new Array("2014,2014,15","2149,2149,15");
    var jcbRules     = new Array("3,3,16","2131,2131,15","1800,1800,15");
    var mcRules      = new Array("51,55,16,3");
    var visaRules    = new Array("4,4,13,3","4,4,16,3");
    var switchRules  = new Array("490302,490309,18,,1","490335,490339,18,,1","491101,491102,16,,1",
                                 "491174,491182,18,,1","493600,493699,19,,1","564182,564182,16,,2",
                                 "633300,633300,16,,0","633301,633301,19,,1","633302,633349,16,,0",
                                 "675900,675900,16,,0","675901,675901,19,,1","675902,675904,16,,0",
                                 "675905,675905,19,,1","675906,675917,16,,0","675918,675918,19,,1",
                                 "675919,675937,16,,0","675938,675940,18,,1","675941,675949,16,,0",
                                 "675950,675962,19,,1","675963,675997,16,,0","675998,675998,19,,1",
                                 "675999,675999,16,,0");
    var soloRules    = new Array("633450,633453,16,,0","633454,633457,16,,0","633458,633460,16,,0",
                                 "633461,633461,18,,1","633462,633472,16,,0","633473,633473,18,,1",
                                 "633474,633475,16,,0","633476,633476,19,,1","633477,633477,16,,0",
                                 "633478,633478,18,,1","633479,633480,16,,0","633481,633481,19,,1",
                                 "633482,633489,16,,0","633490,633493,16,,1","633494,633494,18,,1",
                                 "633495,633497,16,,2","633498,633498,19,,1","633499,633499,18,,1",
                                 "676700,676700,16,,0","676701,676701,19,,1","676702,676702,16,,0",
                                 "676703,676703,18,,1","676704,676704,16,,0","676705,676705,19,,1",
                                 "676706,676707,16,,2","676708,676711,16,,0","676712,676715,16,,0",
                                 "676716,676717,16,,0","676718,676718,19,,1","676719,676739,16,,0",
                                 "676740,676740,18,,1","676741,676749,16,,0","676750,676762,19,,1",
                                 "676763,676769,16,,0","676770,676770,19,,1","676771,676773,16,,0",
                                 "676774,676774,18,,1","676775,676778,16,,0","676779,676779,18,,1",
                                 "676780,676781,16,,0","676782,676782,18,,1","676783,676794,16,,0",
                                 "676795,676795,18,,1","676796,676797,16,,0","676798,676798,19,,1",
                                 "676799,676799,16,,0");
    var maestroRules = new Array("490303,490303,16/18/19","493698,493699,16/18/19","633302,633349,16/18/19",
                                 "675900,675999,16/18/19");
    var deltaRules   = new Array("413733,413737,16","446200,446299,16","453978,453979,16",
                                 "454313,454313,16","454432,454435,16","454742,454742,16",
                                 "456725,456745,16","465830,465879,16","465901,465950,16",
                                 "484409,484410,16","490960,490979,16","492181,492182,16",
                                 "498824,498824,16");
    var abcRules     = new Array("560,651,16");
    
    var thisRules;
  
    switch(cardType)
    {
        case "A"  : thisRules = amexRules;
                    break;
        case "D"  : thisRules = discRules;
                    break;
        case "DC" : thisRules = dinersRules;
                    break;
        case "E"  : thisRules = enrouteRules;
                    break;
        case "J"  : thisRules = jcbRules;
                    break;
        case "M"  : thisRules = mcRules;
                    break;
        case "S"  : thisRules = switchRules;
                    break;
        case "SO" : thisRules = soloRules;
                    break;
        case "V"  : thisRules = visaRules;
                    break;
        case "MA" : thisRules = maestroRules;
                    break;
        case "DA" : thisRules = deltaRules;
                    break;
        case "AB" : thisRules = abcRules;
                    break;
        default   : thisRules = new Array();
                    break;
    }
  
    var ndx;
    var ruleDetails;

    for(ndx = 0 ; ndx < thisRules.length && !result ; ++ndx)
    {
        thisRule    = thisRules[ndx];
        ruleDetails = thisRule.split(",");
        
        var hiPrefix        = ruleDetails[0];
        var loPrefix        = ruleDetails[1];
        var valLengths      = ruleDetails[2].split("/");
        var cvcLength       = ruleDetails[3]
        var issueLength     = ruleDetails[4];
        var startDateLength = ruleDetails[5];
        
        /*
         * Verify card number length
         */
         
        var cardPrefix = cardNbr.substr(0,hiPrefix.length);
        if(cardPrefix >= hiPrefix && cardPrefix <= loPrefix)
        {
            if(valLengths[0] != 0)
            {
                result = false;
                for(lengthNdx = 0 ; lengthNdx < valLengths.length && !result ; ++lengthNdx)
                {
                    if(cardNbr.length == valLengths[lengthNdx])
                    {
                      result = true;
                    }
                }
            }
            else
            {
                result = true;
            }

            if(result)
            {
            }
            
            if(result)
            {
                cc_switch_startDateLength = startDateLength;
                cc_switch_issueLength     = issueLength;
                cc_cvc_length             = cvcLength;
            }
        }
    }
    
    return(result);
}

/*
 *****************************************************************************
 * Returns the name of the card type (for errors)
 *****************************************************************************
 */

function cardTypeName(cardType)
{
    var result;
  
    switch(cardType)
    {
        case "A" : result = "American Express";
                   break;
        case "D" : result = "Discover";
                   break;
        case "DC": result = "Diners Club";
                   break;
        case "E" : result = "Enroute"
                   break;
        case "J" : result = "JCB";
                   break;
        case "M" : result = "MasterCard";
                   break;
        case "S" : result = "Switch";
                   break;
        case "SO": result = "SOLO";
                   break;
        case "V" : result = "VISA";
                   break;
        case "MA": result = "Maestro";
                   break;
        case "DA": result = "Delta";
                   break;
        case "AB": result = "Australian BankCard";
                   break;
        default  : result = "unknown";
                   break;
    }
  
    return(result);
}
/*
 *****************************************************************************
 * Validate card verification code (CVV2/CID)
 *****************************************************************************
 */
 
function checkCvc(cardCvc)
{
    var result = true;
    
    if(cc_cvc_length > 0)
    {
        result = (cardCvc.length == cc_cvc_length);
    }
    
    return(result);
}

/*
 *****************************************************************************
 * Verify the card number
 *****************************************************************************
 * Incoming Parameters: 
 *   cardType:  A  - American Express
 *              AB - Australian BankCard
 *              D  - Discover
 *              DA - Delta
 *              DC - Diners Club
 *              E  - Enroute
 *              J  - JCB
 *              M  - MasterCard
 *              MA - Maestro
 *              S  - Switch
 *              SO - SOLO
 *              V  - VISA
 *   cardNbr:   Numeric card number, appropriate length determined by card 
 *              type/prefix.
 *
 */

function verifyCard(cardType,cardNbr)
{
    var result = true;
  
    if(cardNbr != "")
    {
        result = checkDigits(cardNbr);
        if(result == true)
        {
            result = checkPrefixAndLength(cardType,cardNbr);
            if(result == true)
            {
                result = luhnCheck(cardNbr);
                if(result == false)
                {
                    cc_fail_reason = "Incorrect checksum";
                }
            }
            else
            {
                cc_fail_reason = "Card length or type is incorrect";
            }
        }
        else
        {
            cc_fail_reason = "Card number must be fully numeric"; 
        }
  
        if (result == false)
        {
            alert("The " + cardTypeName(cardType) + " card number entered is incorrect!");
        }
    }
    else
      result = false;
  
    return(result);
}

