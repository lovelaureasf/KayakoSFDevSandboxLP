trigger ResponeTimeCalculation on Lead (before update) {

    
    if(checkRecursive.runOnce())
    {
        Map<Id, User> usrmap = new Map<Id, User>([SELECT id,SDR__C from User where SDR__C = true]);
        
        for(Lead ld: trigger.new)
        {
            if(ld.Assigned_SDR__c == null && usrmap.containskey(ld.ownerid))
            {
                ld.Assigned_SDR__c = ld.ownerid;
                ld.SDR_Assign_Date__C = System.now();
            }
            
            if(ld.Assigned_SDR__c != null && ld.SDR_First_modified_Date_Time__c == null && ld.Status != Trigger.OldMap.get(ld.id).status)
            {
                ld.SDR_First_Modified_Date_Time__c = System.now();
            }
        }    
    }
}