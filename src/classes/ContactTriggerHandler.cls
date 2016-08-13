/* 
* Handles the trigger logic and Tenstreet Post via the @future method.
* Bulkified and batches up contacts as one context (future method) has a limit of 100
* callouts, batches of 50 to allow for 2 callouts if the initial update fails and a  
* second callout is needed for creation.
* @author Mark Troupe
* @since 08.08.2016 (MM.dd.yyyy)
*/
public with sharing class ContactTriggerHandler {

    public Map<Id, Contact> newContactMap;
    public Map<Id, Contact> oldContactMap;
    
    public ContactTriggerHandler(Map<Id, Contact> newContactMap,
                                    Map<Id, Contact> oldContactMap) {
        this.newContactMap = newContactMap;
        this.oldContactMap = oldContactMap;
    }


    public void doTenstreet(){
        Org_Settings__c settings = Org_Settings__c.getInstance();
        if (UserInfo.getProfileId() == settings.Tenstreet_Listener_Site_Profile_Id__c)
            return;

        Tenstreet_API_Settings__c tsSettings = Tenstreet_API_Settings__c.getInstance();
        if (!tsSettings.Enabled__c)
            return;
        

        Set<Id> applicableContactIds = new Set<Id>();
        if (oldContactMap != null){
            for (Id cid : newContactMap.keySet()){
                if (newContactMap.get(cid).pi__grade__c != 
                                oldContactMap.get(cid).pi__grade__c ||
                    newContactMap.get(cid).pi__score__c !=
                                oldContactMap.get(cid).pi__score__c){
                    applicableContactIds.add(cid);
                }
            }
        }else{
            for (Id cid : newContactMap.keySet())
                applicableContactIds.add(cid);
        }
        if (applicableContactIds.size() > 50){
            Set<Id> contactIds = new Set<Id>();
            for (Id contactId : applicableContactIds){
                contactIds.add(contactId);
                if (contactIds.size() == 50){
                    sendToTenstreet(contactIds);
                    contactIds = new Set<Id>();
                }
            }
            if (contactIds.size() > 0){
                sendToTenstreet(contactIds);
            }
        }else if (applicableContactIds.size() > 0){
            sendToTenstreet(applicableContactIds);
        }



    }

    @future(callout=true)
    private static void sendToTenstreet(Set<Id> contactIds){
        List<Tenstreet_History__c> thList = new List<Tenstreet_History__c>();
        List<Contact> contacts = [select Id, 
                                    Email,
                                    FirstName,
                                    LastName,
                                    Phone,
                                    OtherPhone,
                                    pi__score__c,
                                    MailingStreet,
                                    MailingCity,
                                    MailingState,
                                    MailingPostalCode,
                                    Driver_Id__c,
                                    pi__grade__c from Contact where Id in: contactIds];
        for (Contact c : contacts){
            TenstreetPost post = new TenstreetPost(c);
            Tenstreet_History__c th = post.doPost();
            thList.add(th);
        }
        insert thList;
    }
}