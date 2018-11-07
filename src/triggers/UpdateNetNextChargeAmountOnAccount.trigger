/*
*Created By: Sagar Pareek
*Created Date: 22April 2016
*Last Modified Date: 22 April 2016
*Description: This trigger updates the Net Next charge amount on the account object whenever a subscription product and charge is inserted or updated.
*/

trigger UpdateNetNextChargeAmountOnAccount on Zuora__SubscriptionProductCharge__c (after insert,after update) { // works on insert and update.
 
 Map<String,List<Zuora__SubscriptionProductCharge__c>>MapOfAccountWithPositiveSubs = new Map<String,List<Zuora__SubscriptionProductCharge__c>>(); // map of account with non discount charges
 Map<String,List<Zuora__SubscriptionProductCharge__c>>MapOfAccountWithNegativeSubs = new Map<String,List<Zuora__SubscriptionProductCharge__c>>(); // map of account with discount charges
 List<Account>accountList = new List<Account>();
 Set<String> accountSet = new Set<String>();
 for(Zuora__SubscriptionProductCharge__c zsc : Trigger.New){ // iterating over incoming charges
     accountSet.add(zsc.Zuora__Account__c);
 }    
     
 for(Zuora__SubscriptionProductCharge__c zsc: [select id,name,Zuora__Subscription__r.Zuora__Status__c,Zuora__Type__c,Zuora__Account__r.id,Zuora__Account__c,Zuora__ExtendedAmount__c,Zuora__Price__c from Zuora__SubscriptionProductCharge__c where Zuora__Account__r.id IN:accountSet ]){    
     if(zsc.Zuora__Subscription__r.Zuora__Status__c=='Active' && !(zsc.Name.contains('Discount')) && zsc.Zuora__Type__c =='Recurring'){ // checking if subscription status is active and is its not a discount charge.
         
         if(MapOfAccountWithPositiveSubs.containsKey(zsc.Zuora__Account__r.id)){ // creating collection of account with list of positive value charges
             
             MapOfAccountWithPositiveSubs.get(zsc.Zuora__Account__r.id).add(zsc);
         
         }else{
             
             MapOfAccountWithPositiveSubs.put(zsc.Zuora__Account__r.id, new List<Zuora__SubscriptionProductCharge__c>{zsc});
         
         }
     }else if(zsc.Zuora__Subscription__r.Zuora__Status__c=='Active' && zsc.Name.contains('Discount') && zsc.Zuora__Type__c =='Recurring'){ // checking if subscription is active and charge is discount charge
       
       if(MapOfAccountWithNegativeSubs.containsKey(zsc.Zuora__Account__r.id)){ //creating collection of account with negative subscription
             
             MapOfAccountWithNegativeSubs.get(zsc.Zuora__Account__r.id).add(zsc);
         
         }else{
             
             MapOfAccountWithNegativeSubs.put(zsc.Zuora__Account__r.id, new List<Zuora__SubscriptionProductCharge__c>{zsc});
         
         }
      
      }   
 
 }
 
  
   
    for(account acc : [select id from account where id IN: accountSet]){
        
        Decimal totalAmount=0;
        if(MapOfAccountWithPositiveSubs!=null){
            if(MapOfAccountWithPositiveSubs.containsKey(acc.id)){
               
                    for(Zuora__SubscriptionProductCharge__c zspc : MapOfAccountWithPositiveSubs.get(acc.id)){
                        
                       /* if(String.valueOf(zspc.Zuora__Price__c).contains('(')){ // ( means its not discount but its negative value
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
        
        accountList.add(a);
    } 
    if(accountList.size()>0 && accountList!=null){
        update accountList;
    }
    
}