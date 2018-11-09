trigger SendSyncRequestOnInstanceChange on Lead (after update) {

    for(Lead l:Trigger.New){
        if(l.Instance__c !=Trigger.OldMap.get(l.id).Instance__c){
            InstanceSyncHandler.handleEvent(l.Instance__r.uuid__c,String.valueOf(l.Instance__r.Expiry_Date__c),String.valueOf(l.id),String.valueOf(l.ka_product__c));
        }
    }    
    
}