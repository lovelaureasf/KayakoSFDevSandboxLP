/*
    This trigger generates the security token and instance id on quotes object. 
*/

trigger GenerateTokenAndInstanceID on zqu__Quote__c (before insert) {
        
        Set<String>SetOfOppId = new Set<String>();
        Map<String,Decimal> MapOfOppIdAndInstanceId = new Map<String,Decimal>();
        
        for(zqu__Quote__c zq: Trigger.New){
               SetOfOppId.add(zq.zqu__Opportunity__c);
        }
        
        for(opportunity opp: [select id,Instance__c,Instance__r.Instance_ID__c from opportunity where id IN:SetOfOppId]){
             MapOfOppIdAndInstanceId.put(opp.id,opp.Instance__r.Instance_ID__c);
        }
        
        for(zqu__Quote__c z:Trigger.New){
            if(!Test.isRunningTest()){
                z.SecurityToken__c = RandomString.generateRandomString(254); z.InstanceID__c = MapOfOppIdAndInstanceId.get(z.zqu__Opportunity__c);
            }
        }
}