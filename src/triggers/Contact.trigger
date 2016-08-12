trigger Contact on Contact (after insert, after update) {

	ContactTriggerHandler handler = new ContactTriggerHandler(Trigger.newMap, Trigger.oldMap);
	
	handler.doTenstreet();
}