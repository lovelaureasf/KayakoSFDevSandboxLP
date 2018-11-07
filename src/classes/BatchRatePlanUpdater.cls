global class BatchRatePlanUpdater implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {  // The start context will collect all the SPCs in chunk of 200.
        
        
        //String query='select id,name,Zuora__UnitOfMeasure__c,Zuora__Subscription__r.id,Zuora__Quantity__c,Zuora__Product__r.Name,Zuora__RatePlanName__c from Zuora__SubscriptionProductCharge__c where Zuora__UnitOfMeasure__r.Name=\'Agents\'';
        String query='select id from zuora__subscription__c';
        return Database.getQueryLocator(query);  
    }
   
    global void execute(Database.BatchableContext BC, List<Zuora__Subscription__c> scope) { //The execute context performs the main operation.
        
       Map<String,String>mapOfRatePlanNameWithType = new Map<String,String>();
       List<Zuora__Subscription__c>subsToUpdate = new List<Zuora__Subscription__c>();
       Map<String,List<Zuora__SubscriptionProductCharge__c>>mapOfSubwithListOfSPC = new Map<String,List<Zuora__SubscriptionProductCharge__c>>();
       Set<String>subsIds1 = new Set<String>();
       Set<String>subsIds = new Set<String>();
       
       for(Zuora__Subscription__c zs: scope){
           subsIds1.add(zs.id);
       }
       
       for(zqu__ProductRatePlan__c prp: [select id,name,type__c from zqu__ProductRatePlan__c]){
           
           MapOfRatePlanNameWithType.put(prp.Name,prp.type__c);    
           
       }
       
       for(Zuora__SubscriptionProductCharge__c zs: [select id,name,Zuora__UnitOfMeasure__c,Zuora__Subscription__r.id,Zuora__Quantity__c,Zuora__Product__r.Name,Zuora__Product__r.id,Zuora__RatePlanName__c,Zuora__BillingPeriod__c from Zuora__SubscriptionProductCharge__c where Zuora__Subscription__r.id IN:subsids1]){
           
           String rateplanname = zs.Zuora__RatePlanName__c;
           
           if(rateplanname!=null && rateplanname.contains('OnDemand (Kayako 3 Upgrade)') && zs.Zuora__Product__r.Name == 'Kayako 3 -> 4 OnDemand'){
                   
                   
                   if(rateplanname.contains('Case')){
                       rateplanname = 'Case (Kayako 3 Upgrade)';
                   }
                   
                   if(rateplanname.contains('Fusion')){
                       rateplanname = 'Fusion (Kayako 3 Upgrade)';
                   }        
                   
                   if(zs.Zuora__BillingPeriod__c=='Month'){
                       rateplanname = rateplanname+' - Monthly';
                   }
                   
                   if(zs.Zuora__BillingPeriod__c=='Annual'){
                       rateplanname = rateplanname+' - Annual';
                   }
           
           
           }
           
           
               System.debug('the rate plan name is'+rateplanname);
           
           if(MapOfRatePlanNameWithType.keySet().contains(rateplanname) && MapOfRatePlanNameWithType.get(rateplanname)=='Primary'){
               if(mapOfSubwithListOfSPC.keySet().contains(zs.Zuora__Subscription__r.id)){
                   mapOfSubwithListOfSPC.get(zs.Zuora__Subscription__r.id).add(zs);
               }else{
                   mapOfSubwithListOfSPC.put(zs.Zuora__Subscription__r.id,new List<Zuora__SubscriptionProductCharge__c>{zs});
               }
           }
           
           
           subsIds.add(zs.Zuora__Subscription__r.id);
           
           
           
           
           
           
       }
       
       
       for(Zuora__Subscription__c zs : [select id,name,RatePlan__c,Product_Name__c,ProductName__c,Seats__c from Zuora__Subscription__c where id IN:subsIds]){
           
           Integer seats = 0;
           String  primaryplan = '';
           String  productname = '';
           String  productname2 = '';
           Integer oldseats = Integer.valueOf(zs.Seats__c);
           String  oldprimaryplan = zs.RatePlan__c;
           String  oldproductname = zs.Product_Name__c;
           String  oldproductname2 = zs.ProductName__c;
           
          if(mapOfSubwithListOfSPC.containsKey(zs.id)){ 
           for(Zuora__SubscriptionProductCharge__c spc: mapOfSubwithListOfSPC.get(zs.id)){
                   if(spc.Zuora__Quantity__c!=null && !spc.name.contains('Collaborators')){
                   seats = seats+Integer.valueOf(spc.Zuora__Quantity__c);
                   }
                   if(!spc.name.contains('Additional') && !spc.name.contains('Collaborators')){
                       
                       primaryplan = spc.name;
                       productname = spc.Zuora__Product__r.id;
                       productname2 = spc.Zuora__Product__r.Name;
                   
                   }
           
           }
              
              Zuora__Subscription__c s = new Zuora__Subscription__c();
              
              s.id = zs.id;
              
              s.RatePlan__c = primaryplan;
              
              System.debug('the id is'+productname);
              if(productName!='' && productName!=null){
                
                s.Product_Name__c = productName;
                s.ProductName__c = productName2;
                
              }
              
              s.Seats__c = seats;
             
              if(seats!=oldSeats || productName!=oldproductName || productName2!=oldProductName2 || oldprimaryplan!=primaryplan){        
                  
                  subsToUpdate.add(s);
              
              }
         
         }     
       
       }
       
       
       
       if(subsToUpdate.size()>0 && subsToUpdate!=null){  
           update subsToUpdate;
       }

     
     
     }
 
    global void finish(Database.BatchableContext BC) {
    
    }
}