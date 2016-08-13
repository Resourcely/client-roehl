trigger TenstreetHistoryTrigger on Tenstreet_History__c (after insert) {

	List<Id> contactIds = new List<Id>();
	for (Tenstreet_History__c th : trigger.new){
		contactIds.add(th.Contact__c);
	}
	Map<Id, Contact> contactMap = new Map<Id, Contact>([select Id, Most_Recent_Tenstreet_Message__c 
										from Contact where Id in: contactIds]);
	for (Tenstreet_History__c th : trigger.new){
		contactMap.get(th.Contact__c).Most_Recent_Tenstreet_Message__c = th.Description__c;
	}
	update contactMap.values();
}