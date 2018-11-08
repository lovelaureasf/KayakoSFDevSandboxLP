trigger InstanceTrigger on Instance__c (after Update) {
    InstanceHandler.updateTrialExpirydate(Trigger.oldMap, Trigger.newMap);

}