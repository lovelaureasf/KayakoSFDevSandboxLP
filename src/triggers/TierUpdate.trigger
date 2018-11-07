trigger TierUpdate on zqu__Quote__c (before insert) {
    
    List<zqu__Quote__c>quoteList = new List<zqu__Quote__c>();
    Map<String,String>MapOfUserAndManager = new Map<String,String>();
    
    for(User u:[select id,name,ManagerId from user where isActive=true]){
        MapOfUserAndManager.put(u.id,u.ManagerId);
    }
    
    for(zqu__Quote__c z: Trigger.New){
        List<Opportunity> o = [select id,name,ownerid from opportunity where id=:z.zqu__Opportunity__c limit 1];
        if (o.size() > 0) {
            z.Tier1Approver__c = o[0].OwnerId;
            z.Tier2Approver__c = MapOfUserAndManager.get(o[0].OwnerId);
            quoteList.add(z);
        }
    }
    
    
}