trigger UpdateValuesOnQuote on zqu__QuoteChargeSummary__c (after insert) {
    
    Map<String,String>mapOfRatePlanNameWithType = new Map<String,String>();  
    Map<String,String>MapOfIdAndQRatePlan = new Map<String,String>();
    Map<String,zqu__QuoteChargeSummary__c>MapOfRPIdAndPlan = new Map<String,zqu__QuoteChargeSummary__c>();
    Map<String,String>MapOfRatePlanAndQuote = new Map<String,String>();
    List<zqu__Quote__c>qList = new List<zqu__Quote__c>();
     
     for(zqu__ProductRatePlan__c prp: [select id,name,type__c from zqu__ProductRatePlan__c]){
           
           MapOfRatePlanNameWithType.put(prp.Name,prp.type__c);    
           
       }
    
    for(zqu__QuoteChargeSummary__c q:Trigger.New){
        MapOfIdAndQRatePlan.put(q.id,q.zqu__QuoteRatePlan__c);
    }
    
    for(zqu__QuoteChargeSummary__c q:Trigger.New){
        if(MapOfRatePlanNameWithType.get(q.Name) == 'Primary'){
            MapOfRPIdAndPlan.put(q.zqu__QuoteRatePlan__c,q);
        }
    }
    
    for(zqu__QuoteRatePlan__c qrp:[select id,name,zqu__Quote__c,zqu__Quote__r.id from zqu__QuoteRatePlan__c where id=:MapOfRPIdAndPlan.keySet()]){
        zqu__Quote__c zq = new zqu__Quote__c();
        zq.id = qrp.zqu__Quote__r.id;
        zq.PrimaryPlan__c = MapOfRPIdAndPlan.get(qrp.id).Name;
        zq.Seat__c = MapOfRPIdAndPlan.get(qrp.id).zqu__Quantity__c;
        qList.add(zq);
    }
    
    update qList;
    
}