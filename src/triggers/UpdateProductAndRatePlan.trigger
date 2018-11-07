trigger UpdateProductAndRatePlan on Zuora__Subscription__c (after update) {
    
    Set<String>idSet = new Set<String>();
    
    
    for(Zuora__Subscription__c zs: Trigger.New){
        if(Trigger.OldMap.get(zs.id).Zuora__Version__c!=zs.Zuora__Version__c){
            idSet.add(zs.id);          
        }
    }
    
    
       Map<String,String>mapOfRatePlanNameWithType = new Map<String,String>();
       List<Zuora__Subscription__c>subsToUpdate = new List<Zuora__Subscription__c>();
       Map<String,List<Zuora__SubscriptionProductCharge__c>>mapOfSubwithListOfSPC = new Map<String,List<Zuora__SubscriptionProductCharge__c>>();
       Set<String>subsIds = new Set<String>();
       
       
       for(zqu__ProductRatePlan__c prp: [select id,name,type__c from zqu__ProductRatePlan__c]){
           
           MapOfRatePlanNameWithType.put(prp.Name,prp.type__c);    
           
       }
       
       for(Zuora__SubscriptionProductCharge__c zs: [select id,name,Zuora__UnitOfMeasure__c,Zuora__Subscription__r.id,Zuora__Quantity__c,Zuora__Product__r.Name,Zuora__Product__r.id,Zuora__RatePlanName__c from Zuora__SubscriptionProductCharge__c where Zuora__Subscription__r.id IN:idSet]){
           
           if(MapOfRatePlanNameWithType.keySet().contains(zs.Zuora__RatePlanName__c) && MapOfRatePlanNameWithType.get(zs.Zuora__RatePlanName__c)=='Primary'){
               if(mapOfSubwithListOfSPC.keySet().contains(zs.Zuora__Subscription__r.id)){
                   mapOfSubwithListOfSPC.get(zs.Zuora__Subscription__r.id).add(zs);
               }else{
                   mapOfSubwithListOfSPC.put(zs.Zuora__Subscription__r.id,new List<Zuora__SubscriptionProductCharge__c>{zs});
               }
           }
           
           
           subsIds.add(zs.Zuora__Subscription__r.id);
           
           
           
           
           
           
       }
       
       
       for(Zuora__Subscription__c zs : [select id,name from Zuora__Subscription__c where id IN:subsIds]){
           
           Integer seats = 0;
           String  primaryplan = '';
           String  productname = '';
           
          if(mapOfSubwithListOfSPC.containsKey(zs.id)){ 
           for(Zuora__SubscriptionProductCharge__c spc: mapOfSubwithListOfSPC.get(zs.id)){
                   if(spc.Zuora__Quantity__c!=null && !spc.name.contains('Collaborators')){
                   seats = seats+Integer.valueOf(spc.Zuora__Quantity__c);
                   }
                   if(!spc.name.contains('Additional') && !spc.name.contains('Collaborators')){
                       primaryplan = spc.name;
                       productname = spc.Zuora__Product__r.id;
                   }
           
           }
              
              if(productName !='')
              {
                  Zuora__Subscription__c s = new Zuora__Subscription__c();
                  
                  s.id = zs.id;
                  
                  s.RatePlan__c = primaryplan;
                  
                  System.debug('the id is'+productname);
                  s.Product_Name__c = productName;
                  
                  s.Seats__c = seats;
                 
                  subsToUpdate.add(s);
              }
         }     
       
       }
       
       
       
       if(subsToUpdate.size()>0 && subsToUpdate!=null){  
           update subsToUpdate;
       }

}