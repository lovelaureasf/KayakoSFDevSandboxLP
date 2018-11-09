/*
Created By: Sagar Pareek
Description: This Batch job updates the Net Next Charge Amount On Account  field on Account
*/

global class BatchNetNextChargeAmountOnAccountUpdater implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {  // The start context will collect all the charges in chunk of 200.
        
        //String query = 'select id,Zuora__Type__c,Zuora__Subscription__r.Zuora__Status__c,name,Zuora__Account__c,Zuora__ExtendedAmount__c,Zuora__Price__c from Zuora__SubscriptionProductCharge__c limit 200';
        String query = 'select id,NetNextChargeAmount__c from account limit 200';
        return Database.getQueryLocator(query);  
    }
   
    global void execute(Database.BatchableContext BC, List<Account> scope) { //The execute context performs the main operation that is filling net next charge amount field.
        
       Map<String,List<Zuora__SubscriptionProductCharge__c>>MapOfAccountWithPositiveSubs = new Map<String,List<Zuora__SubscriptionProductCharge__c>>(); //for non discounted values
       Map<String,List<Zuora__SubscriptionProductCharge__c>>MapOfAccountWithNegativeSubs = new Map<String,List<Zuora__SubscriptionProductCharge__c>>(); //for discounted values
       List<Account>accountList = new List<Account>(); //list that will be updated at last of the operation
       Set<String>accountSet = new Set<String>(); // stores accounts as unique values
         
         for(Zuora__SubscriptionProductCharge__c zsc : [select id,Zuora__Type__c,Zuora__Subscription__r.Zuora__Status__c,name,Zuora__Account__c,Zuora__ExtendedAmount__c,Zuora__Price__c from Zuora__SubscriptionProductCharge__c where Zuora__Account__r.id IN: scope]){
             accountSet.add(zsc.Zuora__Account__c);
             if(zsc.Zuora__Subscription__r.Zuora__Status__c=='Active' && !(zsc.Name.contains('Discount')) && zsc.Zuora__Type__c =='Recurring'){
                 
                 if(MapOfAccountWithPositiveSubs.containsKey(zsc.Zuora__Account__c)){
                     
                     MapOfAccountWithPositiveSubs.get(zsc.Zuora__Account__c).add(zsc);
                 
                 }else{
                     
                     MapOfAccountWithPositiveSubs.put(zsc.Zuora__Account__c, new List<Zuora__SubscriptionProductCharge__c>{zsc});
                 
                 }
             }else if(zsc.Zuora__Subscription__r.Zuora__Status__c=='Active' && zsc.Name.contains('Discount') && zsc.Zuora__Type__c =='Recurring'){
               
               if(MapOfAccountWithNegativeSubs.containsKey(zsc.Zuora__Account__c)){
                     
                     MapOfAccountWithNegativeSubs.get(zsc.Zuora__Account__c).add(zsc);
                 
                 }else{
                     
                     MapOfAccountWithNegativeSubs.put(zsc.Zuora__Account__c, new List<Zuora__SubscriptionProductCharge__c>{zsc});
                 
                 }
              
              }   
         
         }
 
  
   
    for(account acc : [select id,NetNextChargeAmount__c from account where id IN: accountSet]){
        Decimal oldtotalAmount = acc.NetNextChargeAmount__c;
        Decimal totalAmount=0;
        if(MapOfAccountWithPositiveSubs!=null){
            if(MapOfAccountWithPositiveSubs.containsKey(acc.id)){
               
                    for(Zuora__SubscriptionProductCharge__c zspc : MapOfAccountWithPositiveSubs.get(acc.id)){
                            
                      /*  if(String.valueOf(zspc.Zuora__Price__c).contains('(')){ // ( means its not discount but its negative value
                            String newVal = String.valueOf(zspc.Zuora__Price__c).replace('(','-');
                            newVal = newVal.replace(')','');
                            zspc.Zuora__Price__c = Integer.valueOf(newVal);
                            System.debug('the new negative value is'+zspc.Zuora__Price__c);
                        }*/
                        
                        totalAmount = totalAmount+zspc.Zuora__ExtendedAmount__c;
                    
                    }
                
            } 
        }  
       
        
            if(MapOfAccountWithNegativeSubs!=null){
                if(MapOfAccountWithNegativeSubs.containsKey(acc.id)){
                    for(Zuora__SubscriptionProductCharge__c zspc : MapOfAccountWithNegativeSubs.get(acc.id)){
                        
                    
                        totalAmount = totalAmount-(totalAmount*zspc.Zuora__Price__c)/100;
                    
                    }
                }
            }
        
        
        
        Account a = new Account();
        a.id= acc.id;
        a.NetNextChargeAmount__c = totalAmount;
        if(totalamount!=oldtotalamount){
            accountList.add(a);
        }
    } 

    if(accountList.size()>0 && accountList!=null){
        update accountList;
    }
    }   
    
    global void finish(Database.BatchableContext BC) {
    
    }
}