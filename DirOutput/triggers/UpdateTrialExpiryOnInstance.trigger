/*
This trigger updates the instance expiry date on the instance record associated with the lead whose expiry is extended.
*/

trigger UpdateTrialExpiryOnInstance on Lead (after update) {
    List<Instance__c>iList = new List<Instance__c>();
    for(lead l: Trigger.New){
        if(l.KA_TrialExpiryDate__c!=Trigger.OldMap.get(l.id).KA_TrialExpiryDate__c && l.Instance__c!=null){
           Instance__c i = new Instance__c();
           i.id = l.Instance__c;
           i.Expiry_Date__c = l.KA_TrialExpiryDate__c;
           iList.add(i);
        }
        
    }
    
    if(ilist.size()>0 && ilist!=null){
        update iList;
    }
}