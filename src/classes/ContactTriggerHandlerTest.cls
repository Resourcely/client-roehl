/* 
* Tests the Tenstreet Post through the Contact trigger.
* @author Mark Troupe
* @since 08.08.2016 (MM.dd.yyyy)
*/
@isTest
public with sharing class ContactTriggerHandlerTest {
	
	@testSetup private static void setup() {

		Tenstreet_API_Settings__c ts = new Tenstreet_API_Settings__c();
		ts.Client_Id__c = '1234';
        ts.Password__c = '!#1234';
        ts.Service__c = 'service_update';
        ts.Company_Id__c = '1234';
		ts.Company_Name__c = 'Test Co';
		ts.URL__c = 'https://www.test.com/post';
		ts.Enabled__c = true;
		insert ts;

	}

	/* 
	* Simulates updating a contact in SF that already exists in Tenstreet.
	* Also creates the contact in SF first.
	* @author Mark Troupe
	* @since 08.08.2016 (MM.dd.yyyy)
	*/
	private static testMethod void testPostMatchInsertThenUpdate(){
		Contact c1 = new Contact();
        c1.FirstName = 'Mr';
        c1.LastName = 'Test';
        c1.Email = 'match@test.com';
        c1.Driver_Id__c = 999999991;
        c1.pi__grade__c = '1';

        Test.startTest();
        TenstreetPostTestMock mock = new TenstreetPostTestMock();
        Test.setMock(HttpCalloutMock.class, mock);

   		insert c1;

        c1.pi__grade__c = '2';

        update c1;

        Test.stopTest();

        List<Tenstreet_History__c> th = [select Description__c, Result__c from Tenstreet_History__c
        									order by createdDate asc];
        system.assertEquals(2, th.size());

        //assert a Tenstreet update on insert into SF
		system.assertEquals('ACCEPTED', th[0].Result__c);
		system.assertEquals('Record update.', th[0].Description__c);
	
		//assert a Tenstreet update on update in SF
		system.assertEquals('ACCEPTED', th[1].Result__c);
		system.assertEquals('Record update.', th[1].Description__c);
	
    }

    /* 
	* Simulates the creation of a new Contact in SF that doesn't exist
	* in Tenstreet.
	* @author Mark Troupe
	* @since 08.08.2016 (MM.dd.yyyy)
	*/
    private static testMethod void testPostDontMatchInsert(){
		Contact c1 = new Contact();
        c1.FirstName = 'Mr';
        c1.LastName = 'Test';
        c1.Email = 'dontmatch@test.com';
        c1.Driver_Id__c = 999999992;
        c1.pi__grade__c = '1';

        Test.startTest();
        TenstreetPostTestMock mock = new TenstreetPostTestMock();
        Test.setMock(HttpCalloutMock.class, mock);

   		insert c1;

        Test.stopTest();

        List<Tenstreet_History__c> th = [select Description__c, Result__c from Tenstreet_History__c
        									order by createdDate asc];
        system.assertEquals(1, th.size());
        //assert that the record was rejected for no match.
		system.assertEquals('REJECTED', th[0].Result__c);
	}

	private static testMethod void testBulkMatchInsertThenUpdate(){

		List<Contact> contacts = new List<Contact>();

		for (Integer i = 0; i < 55; i++){
			Contact c1 = new Contact();
	        c1.FirstName = 'Mr';
	        c1.LastName = 'Test';
	        c1.Email = 'match@test.com';
	        c1.Driver_Id__c = i;
	        c1.pi__grade__c = '1';
		}

		Test.startTest();

		insert contacts;

		Test.stopTest();

		Set<Id> historyContactIds = new Set<Id>();
		List<Tenstreet_History__c> histories = [select Contact__c from Tenstreet_History__c];
		for (Tenstreet_History__c th : histories)
			historyContactIds.add(th.Contact__c);

		for (Contact c : contacts)
			system.assert(historyContactIds.contains(c.Id));

	}


}