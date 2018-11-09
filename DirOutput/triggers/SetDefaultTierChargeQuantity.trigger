/*
Description: This trigger checks the Quote Rate Plan Charges and their corresponding tiers. 
If quantity of the collaborator charge falls in the tier range than it updates the collaborator qunatity with the ending unit of the tier. 
Initial Story : BIZ - 1042
*/



// Triggers after insert and update.
trigger SetDefaultTierChargeQuantity on zqu__QuoteCharge_Tier__c (after insert, after update) {
    
    Boolean tiered = false; // flag to check that it works on tiered plan
    Integer quantity = 0;   // holds the quantity that was entered by user 
    Integer finalquantity;  // holds the final quantity that needs to be updated after checking tiered value.
    
    List<zqu__QuoteRatePlanCharge__c>qrpcList = new List<zqu__QuoteRatePlanCharge__c>(); //collects the rate plan charge to be updated
    
    Set<String>QuoteRatePlanChargeIds = new Set<String>(); // holds the id of quote rate plan charge.
    
    for(zqu__QuoteCharge_Tier__c qct: Trigger.New){ //loop to collect ids.
        
         QuoteRatePlanChargeIds.add(qct.zqu__QuoteRatePlanCharge__c);
         
        
    } 
    
    
    for(zqu__QuoteRatePlanCharge__c qrpc: [select id,zqu__Model__c from zqu__QuoteRatePlanCharge__c where id IN: QuoteRatePlanChargeIds]){
        
        if(qrpc.zqu__Model__c == 'Tiered Pricing' ){ // check if the model is tiered pricing
           
            tiered = true;
            
        }
        
        
        
    }
    
    
    for(zqu__QuoteRatePlanCharge__c qrpc: [select Name,id,zqu__Model__c,zqu__Quantity__c from zqu__QuoteRatePlanCharge__c where id IN: QuoteRatePlanChargeIds]){
        
        
        
        if(qrpc.Name == 'Collaborators' && tiered == true){
            
           quantity = Integer.valueOf(qrpc.zqu__Quantity__c);
          
        }
    
    }
    
    System.debug('the quantity is'+quantity);
    System.debug('quote rate plan'+QuoteRatePlanChargeIds);
    
    for(zqu__QuoteCharge_Tier__c qt:[select id,zqu__EndingUnit__c,zqu__StartingUnit__c from  zqu__QuoteCharge_Tier__c where zqu__QuoteRatePlanCharge__r.id IN:QuoteRatePlanChargeIds AND zqu__PriceFormat__c='Flat Fee']){
         
         System.debug('starting unit'+qt.zqu__StartingUnit__c);
         System.debug('ending unit'+qt.zqu__EndingUnit__c);
       
        if(quantity >=Integer.valueOf(qt.zqu__StartingUnit__c) && quantity<=Integer.valueOf(qt.zqu__EndingUnit__c) && quantity!=1){
        
            finalquantity = Integer.valueOf(qt.zqu__EndingUnit__c);
        
        }else if(quantity == 1){
            finalquantity = 0;
        }
    }
    
    System.debug('the final quantity is'+finalquantity);
    
    for(zqu__QuoteRatePlanCharge__c qrpc: [select id,name,zqu__Quantity__c from zqu__QuoteRatePlanCharge__c where id IN:QuoteRatePlanChargeIds]){
        
        
        
        if(qrpc.Name == 'Collaborators'){
            
           qrpc.zqu__Quantity__c = finalquantity;
           
           qrpcList.add(qrpc);
        }
    
    }
    
    
    if(qrpcList!=null && qrpcList.size()>0){
        
        update qrpcList;
    
    }
}