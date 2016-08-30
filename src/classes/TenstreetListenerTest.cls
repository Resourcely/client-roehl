/* 
* Test class for TenstreetListener
* @author Mark Troupe
* @since 08.16.2016 (MM.dd.yyyy)
*/
@isTest
public with sharing class TenstreetListenerTest {


	
	public static testMethod void testListener(){
		RestRequest req = new RestRequest();

		RestResponse res = new RestResponse();
		req.requestURI = 'https://test.force.com/tenstreetlistener/services/apexrest/listener/';

		req.httpMethod = 'POST';

		req.requestBody = Blob.valueOf(requestString);

		RestContext.request = req;

		RestContext.response = res;

		Test.startTest();

		TenstreetListener.parseTenstreetXML();

		Test.stopTest();

		Contact c = [select Driver_Id__c from Contact limit 1];

		system.assertEquals(143717389, c.Driver_Id__c);


	}


	static String requestString = '<?xml version="1.0" encoding="UTF-8"?>' +
'<TenstreetData>' +
 '<Mode>PROD</Mode>' +
 '<DriverId>143717389</DriverId>' +
  '<CompanyId>1183</CompanyId>' +
    '<PersonalData>' +
    '<PersonName>' +
      '<Prefix/>' +
      '<GivenName>Mark New</GivenName>' +
      '<MiddleName/>' +
      '<FamilyName>Troupe4</FamilyName>' +
      '<Affix/>' +
    '</PersonName>' +
    '<PostalAddress>' +
      '<CountryCode>US</CountryCode>' +
      '<Municipality>Lincoln Park</Municipality>' +
      '<Region>MI</Region>' +
      '<PostalCode>48146</PostalCode>' +
      '<Address1>2166 Council Av</Address1>' +
      '<Address2>GLA</Address2>' +
    '</PostalAddress>' +
    '<AllPostalAddresses residence_address_more_than_x_years="yes"/>' +
    '<GovernmentID countryCode="US" issuingAuthority="SSA" documentType="SSN">snipped</GovernmentID>' +
    '<DateOfBirth>snipped</DateOfBirth>' +
    '<ContactData PreferredMethod="PrimaryPhone" PreferredTime="Any">' +
      '<InternetEmailAddress>mtroupe@gmail.com</InternetEmailAddress>' +
      '<PrimaryPhone>313-471-4045</PrimaryPhone>' +
      '<SecondaryPhone/>' +
    '</ContactData>' +


'</PersonalData>' +
'<ApplicationData>' +
'<CustomDataElements>' +
      '<CustomDataElement>' +
       '<CustomDataPrompt>Declined Reason</CustomDataPrompt>' +
       '<CustomDataValue>No Reply</CustomDataValue>' +
        '<CustomDataId>declinedReason</CustomDataId>' +
      '</CustomDataElement>' +
           '<CustomDataElement>' +
       '<CustomDataPrompt>Experience</CustomDataPrompt>' +
       '<CustomDataValue>Get Your CDL</CustomDataValue>' +
       '<CustomDataId>experience</CustomDataId>' +
     '</CustomDataElement>' +

'</CustomDataElements>' +
'</ApplicationData>' +
 '</TenstreetData>';

}