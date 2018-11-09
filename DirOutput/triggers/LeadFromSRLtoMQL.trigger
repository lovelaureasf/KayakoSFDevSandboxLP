/*
Description: This trigger updates StageToMQLDate field whenever the lead comes from SRL to MQL Open
*/
trigger LeadFromSRLtoMQL on Lead (after update) {
    List<lead> llist = new List<lead>();
    for(lead l: Trigger.New){
        System.debug('in the trigger');
        System.debug('the old stage'+Trigger.OldMap.get(l.id).Stage__c);
        System.debug('the new stage is'+l.Stage__c);
        if((Trigger.OldMap.get(l.id).Stage__c=='SRL' || Trigger.OldMap.get(l.id).Stage__c=='SDL') && l.Stage__c=='MQL'){
            System.debug('the old stage'+Trigger.OldMap.get(l.id).Stage__c);
            System.debug('the new stage is'+l.Stage__c);
            l.StageToMQLDate__c = Date.today();
            l.StageToSALDate__c = null;
            l.StageToSDLDate__c = null;
            l.StageToSQLDate__c = null;
            l.StatusToContactedDate__c = null;
            l.StatusToInterestedDate__c = null;
            l.StatusToNurtureDate__c = null;
            l.StatusToQualifiedDate__c = null;
            l.StatusToUnresponsiveDate__c = null;
            llist.add(l);
        }
    }
    if(llist.size()!=0 && llist!=null){
        update llist;
    }
}