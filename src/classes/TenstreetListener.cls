/* 
* Creates HTTP REST endpoint to Tenstreet to POST new/updated prospects to
* @author Mark Troupe
* @since 08.08.2016 (MM.dd.yyyy)
*/
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
        Contact con;
            

        try{
            data = TenstreetListenerData.parseTenstreetData(req.requestBody.toString());
            List<Contact> matchingContacts = [Select Id, FirstName, LastName, Email,
                                            MailingStreet, MailingPostalCode,
                                            MailingCity, Phone from Contact 
                                        where Email =: data.personalData.contactData.InternetEmailAddress];
            if (matchingContacts.size() == 0){
                //create contact
                con = new Contact();
                setContactFields(con, data);
                insert con;
                responseDesc = 'New record created.';

            }else{
                con = matchingContacts[0];
                setContactFields(con, data);
                update con;
                responseDesc = 'Existing record updated';

            }
        }catch(Exception e){
            responseDesc = e.getMessage();
            flag = REJECTED_FLAG;

            
        }
        createTenstreetHistoryRecord(con.Id, flag, responseDesc);
        res.addHeader('Content-Type','text/xml');
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

    private static void createTenstreetHistoryRecord(Id contactId, String flag, String description){
        Tenstreet_History__c th = new Tenstreet_History__c();
        th.Action__c = 'Updated from Tenstreet';
        th.Result__c = flag;
        th.Contact__c = contactId;
        th.Description__c = description;
        insert th;
    
    }

    private static void setContactFields(Contact con, TenstreetListenerData data){
        Org_Settings__c settings = Org_Settings__c.getInstance();

        con.AccountId = settings.Tenstreet_Account_Id__c;
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
        con.TS_Last_App_Date__c = (data.applicationData.lastApplicationDate != null) ? DateTime.valueOf(data.applicationData.lastApplicationDate) : null;
        con.pi__score__c = (data.applicationData.customDataElements.customDataElementsMap.get('marketingScore') != null)
                ? Decimal.valueOf(data.applicationData.customDataElements.customDataElementsMap.get('marketingScore'))
                : null;
        con.pi__grade__c = data.applicationData.customDataElements.customDataElementsMap.get('marketingGrade');
        con.TS_Experience__c = data.applicationData.customDataElements.customDataElementsMap.get('experience');
        con.TS_Division__c = data.applicationData.customDataElements.customDataElementsMap.get('division');
        con.TS_Disqualified_Reason__c = data.applicationData.customDataElements.customDataElementsMap.get('disqualifiedReason');
        con.TS_Declined_Reason__c = data.applicationData.customDataElements.customDataElementsMap.get('declinedReason');
        con.pi__first_activity__c = (data.applicationData.customDataElements.customDataElementsMap.get('marketingFirstActivity') != null) 
                ? DateTime.valueOf(data.applicationData.customDataElements.customDataElementsMap.get('marketingFirstActivity'))
                : null;
        con.pi__last_activity__c = (data.applicationData.customDataElements.customDataElementsMap.get('marketingLastActivity') != null)
                ? DateTime.valueOf(data.applicationData.customDataElements.customDataElementsMap.get('marketingLastActivity'))
                : null;
        con.TS_Fleet__c = data.applicationData.customDataElements.customDataElementsMap.get('fleet');
        con.TS_Rehire_Eligible__c = data.applicationData.customDataElements.customDataElementsMap.get('rehireReligible');
        con.TS_Source__c = data.applicationData.customDataElements.customDataElementsMap.get('applicationReferrerCode');
        con.TS_Marketing_List__c = data.applicationData.customDataElements.customDataElementsMap.get('marketingList');

    }
    
}