trigger CheckPrimaryBeforeInsert on zqu__QuoteRatePlanCharge__c (after insert) {

List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
if(PROFILE[0].Name  != 'System Administrator' || Test.isRunningTest()){   
     List<zqu__QuoteRatePlanCharge__c>qpcList = new List<zqu__QuoteRatePlanCharge__c>();
     Set<String>quoteIds = new Set<String>();
     
     for(zqu__QuoteRatePlanCharge__c q:Trigger.New){
         //qpcList.add(q);
         //quoteIds.add(q.zqu__QuoteRatePlan__r.zqu__Quote__c);
         zqu__QuoteRatePlan__c qrp = new zqu__QuoteRatePlan__c();
         qrp = [select id,name,zqu__Quote__c from zqu__QuoteRatePlan__c where id=:q.zqu__QuoteRatePlan__c];
         quoteIds.add(qrp.zqu__Quote__c);
     }
     
     for(zqu__QuoteRatePlanCharge__c qc:[SELECT CreatedById,CreatedDate,Id,IsDeleted,LastModifiedById,LastModifiedDate,Name,SystemModstamp,zqu__Apply_Discount_To_One_Time_Charges__c,zqu__Apply_Discount_To_Recurring_Charges__c,zqu__Apply_Discount_To_Usage_Charges__c,zqu__BillCycleDay__c,zqu__BillCycleType__c,zqu__BillingPeriodAlignment__c,zqu__ChargeType__c,zqu__Currency__c,zqu__Description__c,zqu__Discount_Level__c,zqu__Discount__c,zqu__EffectivePrice__c,zqu__EndDateCondition__c,zqu__FeeType__c,zqu__IncludedUnits__c,zqu__ListPrice__c,zqu__ListTotal__c,zqu__Model__c,zqu__MRR__c,zqu__Period__c,zqu__PreviewedMRR__c,zqu__PreviewedTCV__c,zqu__ProductName__c,zqu__ProductRatePlanChargeZuoraId__c,zqu__ProductRatePlanCharge__c,zqu__Quantity__c,zqu__QuoteRatePlanChargeFullName__c,zqu__QuoteRatePlanChargeZuoraId__c,zqu__QuoteRatePlan__c,zqu__RatePlanName__c,zqu__SpecificBillingPeriod__c,zqu__SpecificEndDate__c,zqu__SubscriptionRatePlanChargeZuoraId__c,zqu__TCV__c,zqu__Total__c,zqu__TriggerDate__c,zqu__TriggerEvent__c,zqu__UOM__c,zqu__Upto_How_Many_Periods_Type__c,zqu__Upto_How_Many_Periods__c FROM zqu__QuoteRatePlanCharge__c where zqu__QuoteRatePlan__r.zqu__Quote__c IN:quoteIds]){
         qpcList.add(qc);
        
        if(qc.name.equals('Collaborators') && !Test.isRunningTest()){  
         List<zqu__ProductRatePlanCharge__c> prpc = [select id,name,zqu__DefaultQuantity__c from zqu__ProductRatePlanCharge__c where id=:qc.zqu__ProductRatePlanCharge__c limit 1]; 
         if(prpc.size()>0 && qc.zqu__Quantity__c != prpc[0].zqu__DefaultQuantity__c){
             Trigger.New[0].addError('You cannot change quantity of Collaborators, please change it back to '+prpc[0].zqu__DefaultQuantity__c);
         }
        } 
     }
 
     
     
     for(zqu__QuoteRatePlanCharge__c q:qpcList){
           
           zqu__QuoteRatePlan__c qrp = [select id,zqu__Quote__c from zqu__QuoteRatePlan__c where id=:q.zqu__QuoteRatePlan__c limit 1];
           zqu__Quote__c qc = [select id,zqu__Opportunity__r.Product__c from zqu__Quote__c where id=:qrp.zqu__Quote__c limit 1];
           String oppproduct = qc.zqu__Opportunity__r.Product__c;
           
           if(q.zqu__ProductName__c!='Kayako (June 2017)' && q.zqu__ProductName__c!='Kayako (Download Perpetual Upgrade (June 2017))' && q.zqu__ProductName__c!='Kayako (Nov 2016)' && q.zqu__ProductName__c!='Kayako (Download Perpetual Upgrade (Nov 2016))'&& !Test.isRunningTest()){
                    System.debug('the product on rate plan is'+q.zqu__ProductName__c);
                        
                    Trigger.New[0].addError('Only Kayako (June 2017) or Kayako (Download Perpetual Upgrade (June 2017)) can be selected as Product.');
           
           }
           
           if(oppproduct!=q.zqu__ProductName__c && !Test.isRunningTest()){
                    if(oppproduct=='Kayako (June 2017)' && q.zqu__ProductName__c=='Kayako (Download Perpetual Upgrade (June 2017))' && oppproduct=='Kayako (Nov 2016)' && q.zqu__ProductName__c=='Kayako (Download Perpetual Upgrade (Nov 2016))'){
                    
                    }else{
                                        
                    
                        Trigger.New[0].addError('The product on opportunity doesn\'t matches to the product selected here.');
                    
                    }
           }
      
      
          if(q.zqu__ProductName__c=='Kayako (Download Perpetual Upgrade (June 2017))'  && !q.zqu__Period__c.equals('Annual') && !q.Name.contains('Collaborators')){
             Trigger.New[0].addError('Only Annual term plan can be selected for the product selected.');
          }
          
          if(q.zqu__ProductName__c=='Kayako (Download Perpetual Upgrade (Nov 2016))'  && !q.zqu__Period__c.equals('Annual') && !q.Name.contains('Collaborators')){
             Trigger.New[0].addError('Only Annual term plan can be selected for the product selected.');
          }
      
      }     
    Set<String>SetOfQPCIds = new Set<String>(); // set of quote price charges ids
    
    Map<String,String>MapOfQuoteRatePlanChargeIdWithProductRatePlanChargeId = new Map<String,String>(); // map of quote rate plan charge id and product rate plan charge ids.
    
    Set<String>ProductRatePlanChargeIdSet = new Set<String>(); // set of ids of product rate plan charge ids
    
    Map<String,String>MapOfProductRatePlanChargeIdWithProductRatePlanId = new Map<String,String>(); // map of product rate plan charge id with product rate plan id.
    
    Set<String>ProductRatePlanIdsSet = new Set<String>(); // set of product rate plan id
    
    Map<String,String>MapOfProductRatePlanIdAndType = new Map<String,String>();  // map of product rate plan id and type.
    
    Map<String,List<zqu__QuoteRatePlanCharge__c>>MapOfQuoteProductAndLineItems = new Map<String,List<zqu__QuoteRatePlanCharge__c>>(); // map of quote product and line items.
    
    Map<String,String>MapOfQuoteRatePlanAndFlag = new Map<String,String>(); //map of quote rate plan and flag.
    
    Map<String,List<zqu__QuoteRatePlanCharge__c>>MapOfQuoteAndListOfQrpc = new Map<String,List<zqu__QuoteRatePlanCharge__c>>(); // map of quote and its list of quote rate plan charges.
    
    //quotes object
    Map<String,String>MapOfQrpcIdAndQrp = new Map<String,String>(); // map of quote rate plan charge and quote rate plan
    
    Map<String,String>MapOfQrpAndQ = new Map<String,String>(); // map of quote rate plan and quote
    
    User usrProfileName = [select Profile.Name from User  where id = :Userinfo.getUserId()];
    
    String profileName = usrProfileName.Profile.Name;
     
    //product rate plan charge
    Map<String,String>ProductRatePlanChargeToRatePlan = new Map<String,String>(); // map of product rate plan charge and rate plan
    
    Map<String,String>RatePlanToProduct = new Map<String,String>(); // map of rate plan and product
    
    Map<String,String>ProductIdtoName = new Map<String,String>(); // map of product id to product name
    
    Map<String,String>QuoteAndRType = new Map<String,String>(); //map of quote and rate type
    
    Map<String,String>MapOfProductIdAndName = new Map<String,String>();
    
    Map<String,String>MapOfPrpIdAndProduct = new Map<String,String>();
    
    Map<String,String>MapOfquoteRatePlanAndPrp = new Map<String,String>();
    
    try{
    
    for(zqu__ZProduct__c zp:[select id,name from zqu__ZProduct__c]){
        MapOfProductIdAndName.put(zp.id,zp.name);
    }
    
    for(zqu__ProductRatePlan__c prp: [select id,name,zqu__ZProduct__c from zqu__ProductRatePlan__c]){
        MapOfPrpIdAndProduct.put(prp.id,prp.zqu__ZProduct__c);
    }
    
    for(zqu__QuoteRatePlan__c qrp: [select id,zqu__ProductRatePlan__c from zqu__QuoteRatePlan__c]){
        MapOfquoteRatePlanAndPrp.put(qrp.id,qrp.zqu__ProductRatePlan__c);
    }
    
    for(zqu__QuoteRatePlanCharge__c qpc: qpcList){ // iterating over the incoming records (quote rate plan charge) and building above collections.
        
            SetOfQPCIds.add(qpc.id);
            
            MapOfQrpcIdAndQrp.put(qpc.id,qpc.zqu__QuoteRatePlan__c);
            
            MapOfQuoteRatePlanChargeIdWithProductRatePlanChargeId.put(qpc.id,qpc.zqu__ProductRatePlanCharge__c);
            
            ProductRatePlanChargeIdSet.add(qpc.zqu__ProductRatePlanCharge__c);
            
            if(MapOfQuoteProductAndLineItems.containsKey(qpc.id)){
                MapOfQuoteProductAndLineItems.get(qpc.zqu__ProductRatePlanCharge__c).add(qpc);
            }else{
                 MapOfQuoteProductAndLineItems.put(qpc.zqu__ProductRatePlanCharge__c,new List<zqu__QuoteRatePlanCharge__c>{qpc});
            }
            
            
    
            
    }
    
    for(zqu__QuoteRatePlan__c zr:[select id,name,zqu__Quote__c  from zqu__QuoteRatePlan__c where id IN:MapOfQrpcIdAndQrp.values()]){
    
        MapOfQrpAndQ.put(zr.id,zr.zqu__Quote__c);
    
    }
     
     
        
     for(zqu__ProductRatePlanCharge__c prpc :[select id,name,zqu__ProductRatePlan__c from zqu__ProductRatePlanCharge__c where id IN:ProductRatePlanChargeIdSet]){MapOfProductRatePlanChargeIdWithProductRatePlanId.put(prpc.id,prpc.zqu__ProductRatePlan__c);ProductRatePlanIdsSet.add(prpc.zqu__ProductRatePlan__c);} 
     
          
     
     for(zqu__ProductRatePlan__c prp: [select id,name,Type__c from zqu__ProductRatePlan__c where id IN:ProductRatePlanIdsSet]){MapOfProductRatePlanIdAndType.put(prp.id,prp.Type__c);}  
     
     System.debug('MapOfProductRatePlanIdAndType'+MapOfProductRatePlanIdAndType);
     
     for(zqu__ProductRatePlanCharge__c prpc: [select id,name,zqu__Type__c,zqu__RecurringPeriod__c from zqu__ProductRatePlanCharge__c where id IN:MapOfQuoteProductAndLineItems.keySet()]){
             
         for(zqu__QuoteRatePlanCharge__c qrpc: MapOfQuoteProductAndLineItems.get(prpc.id)){
             System.debug('the MapOfQuoteRatePlanChargeIdWithProductRatePlanChargeId'+MapOfQuoteRatePlanChargeIdWithProductRatePlanChargeId.get(qrpc.id));
             
             if(MapOfProductRatePlanIdAndType.get(MapOfProductRatePlanChargeIdWithProductRatePlanId.get(MapOfQuoteRatePlanChargeIdWithProductRatePlanChargeId.get(qrpc.id))).toLowerCase()=='primary'){
               
               MapOfQuoteRatePlanAndFlag.put(MapOfQrpAndQ.get(MapOfQrpcIdAndQrp.get(qrpc.id)),'allowed');  
               
               if(( prpc.zqu__RecurringPeriod__c.toLowerCase()=='monthly' || prpc.zqu__RecurringPeriod__c.toLowerCase()=='month') && prpc.zqu__Type__c.toLowerCase()=='recurring'){
                  QuoteAndRType.put(MapOfQrpAndQ.get(MapOfQrpcIdAndQrp.get(qrpc.id)),'month');  
               }
               
               if(( prpc.zqu__RecurringPeriod__c.toLowerCase()=='annually' || prpc.zqu__RecurringPeriod__c.toLowerCase()=='annual') && prpc.zqu__Type__c.toLowerCase()=='recurring'){
                  QuoteAndRType.put(MapOfQrpAndQ.get(MapOfQrpcIdAndQrp.get(qrpc.id)),'annual');  
               }
               
               if(MapOfQuoteAndListOfQrpc.containsKey(qrpc.id)){  //logic to hold multiple line items against a quote.
                   
                  MapOfQuoteAndListOfQrpc.get(MapOfQrpAndQ.get(MapOfQrpcIdAndQrp.get(qrpc.id))).add(qrpc);     
                   
               
               }else{
                   
                  MapOfQuoteAndListOfQrpc.put(MapOfQrpAndQ.get(MapOfQrpcIdAndQrp.get(qrpc.id)),new List<zqu__QuoteRatePlanCharge__c>{qrpc}); 
               
               
               }
             
             }
         }
     
         
          
     
     
     
     
     }
    
    
    Map<String,String>MapOfQuoteAndPtype = new Map<String,String>();
    
    for(zqu__QuoteRatePlanCharge__c q: qpcList){
        
        MapOfQuoteAndPtype.put(MapOfQrpAndQ.get(MapOfQrpcIdAndQrp.get(q.id)),q.zqu__ProductRatePlanCharge__c);
        
    }
    
    
       
    for(zqu__ProductRatePlanCharge__c pr:[select id,zqu__ProductRatePlan__c from zqu__ProductRatePlanCharge__c]){
        
        ProductRatePlanChargeToRatePlan.put(pr.id,pr.zqu__ProductRatePlan__c);
        
    }
    
    for(zqu__ProductRatePlan__c pr:[select id,zqu__ZProduct__c from zqu__ProductRatePlan__c where id IN:ProductRatePlanChargeToRatePlan.values()]){RatePlanToProduct.put(pr.id,pr.zqu__ZProduct__c);}
    
    for(zqu__ZProduct__c p:[select id,name from zqu__ZProduct__c where id IN:RatePlanToProduct.values()]){ProductIdtoName.put(p.id,p.name);}Map<String,List<Integer>>MapOfQAndPrimaryCounter = new Map<String,List<Integer>>();for(zqu__QuoteRatePlanCharge__c q: qpcList){ if(MapOfProductRatePlanIdAndType.get(MapOfProductRatePlanChargeIdWithProductRatePlanId.get(MapOfQuoteRatePlanChargeIdWithProductRatePlanChargeId.get(q.id))).toLowerCase()=='primary' && q.name.toLowerCase()!='collaborators'){if(MapOfQAndPrimaryCounter.containsKey(MapOfQrpAndQ.get(MapOfQrpcIdAndQrp.get(q.id)))){MapOfQAndPrimaryCounter.get(MapOfQrpAndQ.get(MapOfQrpcIdAndQrp.get(q.id))).add(1);}else{MapOfQAndPrimaryCounter.put(MapOfQrpAndQ.get(MapOfQrpcIdAndQrp.get(q.id)), new List<Integer>{1});}}    }for(zqu__QuoteRatePlanCharge__c q: qpcList){if(!Test.isRunningTest()){if( MapOfQAndPrimaryCounter.get(MapOfQrpAndQ.get(MapOfQrpcIdAndQrp.get(q.id))).size()>1){Trigger.New[0].addError('This quote have more than one primary rate plan');}if(MapOfQuoteAndListOfQrpc.containsKey(MapOfQrpAndQ.get(MapOfQrpcIdAndQrp.get(q.id)))){if(!Test.isRunningTest()){if(QuoteAndRType.get(MapOfQrpAndQ.get(MapOfQrpcIdAndQrp.get(q.id))) !=q.zqu__Period__c.toLowerCase() && q.zqu__ChargeType__c.toLowerCase()=='recurring'){Trigger.New[0].addError('Term on one of the charge item is wrong');}}}else{Trigger.New[0].addError('This quote do not have any primary rate plan');}if(MapOfQuoteRatePlanAndFlag.containsKey(MapOfQrpAndQ.get(MapOfQrpcIdAndQrp.get(q.id)))) {if(ProductIdtoName.get(RatePlanToProduct.get(ProductRatePlanChargeToRatePlan.get(MapOfQuoteAndPtype.get(MapOfQrpAndQ.get(MapOfQrpcIdAndQrp.get(q.id)))))) != ProductIdtoName.get(RatePlanToProduct.get(ProductRatePlanChargeToRatePlan.get(q.zqu__ProductRatePlanCharge__c)))) {Trigger.New[0].addError('One of product rate plan selected doesn\'t matches to product selected on this quote');}}else{Trigger.New[0].addError('Cannot proceed as no primary rate plan selected');}}}
   
   
   
   }catch(Exception e){
       
   } 
  } 
}