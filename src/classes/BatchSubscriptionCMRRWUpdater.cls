global class BatchSubscriptionCMRRWUpdater implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext BC) {  // The start context will collect all subscriptions in chunk of 200.
        
        String query = 'select id,name,CMRRWithDiscount__c,Zuora__MRR__c from Zuora__Subscription__c';
        System.debug('in locator');
        return Database.getQueryLocator(query);  
    }
    
    
    global void execute(Database.BatchableContext BC, List<Zuora__Subscription__c> scope) { 
        Map<String,String>MapOfNameOfChargeAndType = new Map<String,String>();     //holds the name of charge and type   
        List<Zuora__Subscription__c>subsToUpdate = new  List<Zuora__Subscription__c>(); // holds the subscriptions to update
        Set<String>SubsIds = new Set<String>(); //subscription ids to iterate on
        Map<String,List<Zuora__SubscriptionProductCharge__c>>MapOfSubIdAndListOfSPC = new Map<String,List<Zuora__SubscriptionProductCharge__c>>();
        for(zqu__ProductRatePlan__c rp:[select id,name,Type__c from zqu__ProductRatePlan__c]){
            MapOfNameOfChargeAndType.put(rp.name,rp.Type__c);   
        }
        
        System.debug('into the scope');
        
        for(Zuora__Subscription__c s:scope){
                SubsIds.add(s.id);
        }
        
        for(Zuora__SubscriptionProductCharge__c spc :[select id,name,Zuora__MonthlyRecurringRevenue__c,Zuora__Model__c,Zuora__Price__c,Zuora__BillingPeriod__c,Zuora__Subscription__r.id,Zuora__RatePlanName__c,Zuora__UnitOfMeasure__r.Name  from Zuora__SubscriptionProductCharge__c where Zuora__Subscription__r.id IN:SubsIds]){
            if(!MapOfSubIdAndListOfSPC.keySet().contains(spc.Zuora__Subscription__r.id)){
                MapOfSubIdAndListOfSPC.put(spc.Zuora__Subscription__r.id,new List<Zuora__SubscriptionProductCharge__c>{spc});
            }else{
                MapOfSubIdAndListOfSPC.get(spc.Zuora__Subscription__r.id).add(spc);
            }
        }
        
        for(Zuora__Subscription__c s:scope){
            s.CMRRWithDiscount__c = 0;
            Boolean discountapplied = false;
            if(MapOfSubIdAndListOfSPC.keySet().contains(s.id)){
            for(Zuora__SubscriptionProductCharge__c spc: MapOfSubIdAndListOfSPC.get(s.id)){
                //if(!spc.Name.contains('Renewal')){
                    //System.debug('not renewal');
                if(MapOfNameOfChargeAndType.keySet().contains(spc.Zuora__RatePlanName__c )){
                        System.debug('product map contains the name of the spc');
                    if(MapOfNameOfChargeAndType.get(spc.Zuora__RatePlanName__c ).contains('Discount')){
                        System.debug('type is discount');
                        discountapplied = true;
                        if(spc.Zuora__Model__c.contains('Percentage') && spc.Zuora__BillingPeriod__c.contains('Month')){
                            System.debug('percent and monthly');
                            s.CMRRWithDiscount__c = s.Zuora__MRR__c - (s.Zuora__MRR__c*spc.Zuora__Price__c/100);
                        }else if(spc.Zuora__Model__c.contains('Fixed') && spc.Zuora__BillingPeriod__c.contains('Month')){
                            System.debug('fixed and monthly');
                            s.CMRRWithDiscount__c = s.Zuora__MRR__c - spc.Zuora__Price__c;
                        }else if(spc.Zuora__Model__c.contains('Percentage') && spc.Zuora__BillingPeriod__c.contains('Annual')){
                             System.debug('percent and annual');
                            s.CMRRWithDiscount__c = s.Zuora__MRR__c - (s.Zuora__MRR__c*(spc.Zuora__Price__c)/100);
                        }else if(spc.Zuora__Model__c.contains('Fixed') && spc.Zuora__BillingPeriod__c.contains('Annual')){
                             System.debug('fixed and annual');
                            s.CMRRWithDiscount__c =s.Zuora__MRR__c - (spc.Zuora__Price__c/12);
                        }
                    }else{
                         if(spc.Zuora__UnitOfMeasure__r.Name=='Agents' && !discountapplied){
                             s.CMRRWithDiscount__c =s.Zuora__MRR__c;
                        } 
                        
                        if((spc.Zuora__UnitOfMeasure__r.Name=='' || spc.Zuora__UnitOfMeasure__r.Name== null) && !discountapplied && spc.name.contains('Renewal')){
                             s.CMRRWithDiscount__c =s.Zuora__MRR__c;
                        }         
                    
                    }
                    
                    
                    
                }
            //}
              
              if(spc.name == 'Fusion OnDemand (Kayako 3 Upgrade)'){
                  s.CMRRWithDiscount__c =s.Zuora__MRR__c;
              }
          
          }
              subsToUpdate.add(s);
               System.debug('updating'+s);
          }     
        }
    
        update subsToUpdate;
    }        
        
    global void finish(Database.BatchableContext BC) {
    
    }
        
    
}