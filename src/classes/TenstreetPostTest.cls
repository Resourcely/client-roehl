@isTest
public with sharing class TenstreetPostTest {
	@testSetup private static void setup() {

		Tenstreet_API_Settings__c ts = new Tenstreet_API_Settings__c();
		ts.Client_Id__c = '1234';
        ts.Password__c = '!#1234';
        ts.Service__c = 'service_update';
        ts.Service_on_Insert__c = 'service_upload';
       	ts.Company_Id__c = '1234';
		ts.Company_Name__c = 'Test Co';
		ts.URL__c = 'https://www.test.com/post';
		ts.Enabled__c = false;
		insert ts;

    
	}

	private static testMethod void testPostMatch(){
		Contact c1 = new Contact();
        c1.FirstName = 'Mr';
        c1.LastName = 'Test';
        c1.Email = 'match@test.com';
        c1.pi__grade__c = '1';

        Test.startTest();
        
        TenstreetPostTestMock mock = new TenstreetPostTestMock();
        Test.setMock(HttpCalloutMock.class, mock);

        TenstreetPost post = new TenstreetPost(c1);
        

        Tenstreet_History__c th = post.doPost();

        system.assertEquals('ACCEPTED', th.Result__c);
    }

    private static testMethod void doPostNoMatch(){

    	Contact c2 = new Contact();
        c2.FirstName = 'Mr';
        c2.LastName = 'Test';
        c2.Email = 'dontmatch@test.com';
        c2.pi__score__c = 1;

        Test.startTest();
        
        TenstreetPostTestMock mock = new TenstreetPostTestMock();
        Test.setMock(HttpCalloutMock.class, mock);

   

        TenstreetPost post = new TenstreetPost(c2);
       	Tenstreet_History__c th = post.doPost();

        system.assertEquals('ACCEPTED', th.Result__c);

        Test.stopTest();

	}


}