@RestResource(urlMapping='/listener/*')
global with sharing class TenstreetListener {

    static final String ACCEPTED_FLAG = 'ACCEPTED';
    static final String REJECTED_FLAG = 'REJECTED';



    @HttpPost
    global static void parseTenstreetXML() {
        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;

        String responseDesc = '';
        TenstreetListenerData data;
        String flag = ACCEPTED_FLAG;

        try{
            data = TenstreetListenerData.parseTenstreetData(req.requestBody.toString());

            List<Contact> matchingContacts = [Select Id, FirstName, LastName, Email,
                                            MailingStreet, MailingPostalCode,
                                            MailingCity, Phone from Contact 
                                        where Email =: data.personalData.contactData.InternetEmailAddress];
            if (matchingContacts.size() == 0){
                //create contact
                Contact con = new Contact();
                setContactFields(con, data);
                insert con;
                responseDesc = 'New record created.';

            }else{

                setContactFields(matchingContacts[0], data);
                update matchingContacts[0];
                responseDesc = 'Existing record updated';
                flag = REJECTED_FLAG;
            }
        }catch(Exception e){
            responseDesc = e.getMessage();
        }
        res.responseBody = Blob.valueOf(generateResponse(flag, responseDesc, data.driverId));
    }


    private static String generateResponse(String flag, String description, String employeeNumber){

        return '<?xml version="1.0" encoding="UTF-8"?>' +
                            '<TenstreetResponse>'+
                            '<EmployeeNumber>'+employeeNumber+'</EmployeeNumber>'+
                            '<Status>'+flag+'</Status>'+
                            '<Description>'+description+'</Description>'+
                            '</TenstreetResponse>';

    }

    private static void setContactFields(Contact con, TenstreetListenerData data){
        con.FirstName = data.personalData.personName.givenName;
        con.LastName = data.personalData.personName.familyName;
        con.Email = data.personalData.contactData.internetEmailAddress;
        con.MailingStreet = data.personalData.postalAddress.address1;
        con.MailingStreet += '\n' + data.personalData.postalAddress.address2;
        con.MailingCity = data.personalData.postalAddress.municipality;
        con.MailingPostalCode = data.personalData.postalAddress.postalCode;
        con.MailingState = data.personalData.postalAddress.region;
        con.Driver_Id__c = Integer.valueOf(data.driverId);
        con.Phone = data.personalData.contactData.primaryPhone;
        con.OtherPhone = data.personalData.contactData.secondaryPhone;
        con.HasOptedOutOfEmail = !(data.personalData.communicationPreferences.emailOptIn);
        con.Text_Opt_Out__c = !(data.personalData.communicationPreferences.textOptIn);
        con.TS_Status__c = data.applicationData.status;
        con.TS_App_Source__c = data.applicationData.appSource;
        con.TS_Last_App_Date__c = DateTime.parse(data.applicationData.lastApplicationDate);
        con.Marketing_Score__c = data.applicationData.customDataElements.customDataElementsMap.get('marketingScore').customDataValue;
        con.Marketing_Grade__c = data.applicationData.customDataElements.customDataElementsMap.get('marketingGrade').customDataValue;
        con.TS_Experience__c = data.applicationData.customDataElements.customDataElementsMap.get('experience').customDataValue;
        con.TS_Division__c = data.applicationData.customDataElements.customDataElementsMap.get('division').customDataValue;
        con.TS_Disqualified_Reason__c = data.applicationData.customDataElements.customDataElementsMap.get('disqualifiedReason').customDataValue;
        con.TS_Declined_Reason__c = data.applicationData.customDataElements.customDataElementsMap.get('declinedReason').customDataValue;
        con.TS_First_Activity__c = data.applicationData.customDataElements.customDataElementsMap.get('marketingFirstActivity').customDataValue;
        con.TS_Last_Activity__c = data.applicationData.customDataElements.customDataElementsMap.get('marketingLastActivity').customDataValue;
        con.TS_Fleet__c = data.applicationData.customDataElements.customDataElementsMap.get('fleet').customDataValue;
        con.TS_Rehire_Eligible__c = data.applicationData.customDataElements.customDataElementsMap.get('rehireEligible').customDataValue;
        con.TS_Source__c = data.applicationData.customDataElements.customDataElementsMap.get('applicationReferrerCode').customDataValue;
        con.TS_Marketing_List__c = data.applicationData.customDataElements.customDataElementsMap.get('marketingList').customDataValue;

    }
    
}