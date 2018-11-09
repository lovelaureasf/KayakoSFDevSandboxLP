Public class InstanceHandler {
    public static void updateTrialExpirydate(Map<Id, Instance__c> oldInstance, Map<Id, Instance__c> newInstance){
     
        Set<Id> instanceIds = new Set<Id>();
        
        for (Instance__c objInstance: newInstance.values()) {
            if(objInstance.Expiry_Date__c != oldInstance.get(objInstance.Id).Expiry_Date__c ) {
                instanceIds.add(objInstance.Id);
            }
        }
        
        if(!instanceIds.isEmpty()) {
            Map<Id, Lead> mapLeads = new Map<Id, Lead>();
            for (Lead leadObj: [Select Trial_Expiry__c, id, Instance__c from LEAD where Instance__c IN: instanceIds ]) {
                //if(objInstance.Expiry_Date__c != oldInstance.get(objInstance.Id).Expiry_Date__c ) {
                    mapLeads.put(leadObj.Id, new Lead(Id=leadObj.Id,Trial_Expiry__c = oldInstance.get(leadObj.Instance__c ).Expiry_Date__c));
                //}
            }
            
            if(!mapLeads.isEmpty()) {
                update mapLeads.values();
            }
        }
     
    }
    
}