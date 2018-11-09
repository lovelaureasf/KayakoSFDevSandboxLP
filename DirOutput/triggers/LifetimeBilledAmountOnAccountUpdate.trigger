/*
*Created By: Sagar Pareek
*Created Date: 22April 2016
*Last Modified Date: 22 April 2016
*Description: This trigger updates the LifetimeBilledAmount on the account object whenever a invoice is created or updated.
*/

trigger LifetimeBilledAmountOnAccountUpdate on Zuora__Payment__c (after insert,after update) { // works on insert and update
 
 Map<String,List<Zuora__Payment__c>>MapOfAccountWithPayments = new Map<String,List<Zuora__Payment__c>>(); // map of Accounts with Payment
 List<Account>accountList = new List<Account>(); // list of accounts which will be updated at the end of the transaction 
 Set<String>accountSet = new Set<String>(); //set of account ids
 for(Zuora__Payment__c zp : Trigger.New){ // iterating over the incoming payments.
     accountSet.add(zp.Zuora__Account__c);
 }    
     
   for(Zuora__Payment__c zp:[select id,Zuora__Status__c,Zuora__Account__c,Zuora__Account__r.id,Zuora__Amount__c,Zuora__Invoice__r.Zuora__AmountWithoutTax__c from Zuora__Payment__c where Zuora__Account__r.id IN:accountset]){  
     if(zp.Zuora__Status__c=='Processed'){ // the payment must be in processed status
         
         if(MapOfAccountWithPayments.containsKey(zp.Zuora__Account__c)){ // collecting accounts with list of its payments.
             
             MapOfAccountWithPayments.get(zp.Zuora__Account__c).add(zp);
         
         }else{
             
             MapOfAccountWithPayments.put(zp.Zuora__Account__c, new List<Zuora__Payment__c>{zp});
         
         }
     }
      
      }   
 
 
 
  
   
    for(account  acc : [select id from account where id IN:accountSet]){ // now calculating the total amount
        
        Decimal totalAmount=0;
        
        if(MapOfAccountWithPayments.containsKey(acc.id)){
            
            for(Zuora__Payment__c zps : MapOfAccountWithPayments.get(acc.id)){
                
                if(zps.Zuora__Invoice__r.Zuora__AmountWithoutTax__c!=null){
                    totalAmount = totalAmount+zps.Zuora__Amount__c;
                }
            
            }
           
        }
        
        Account a = new Account();
        a.id= acc.id;
        a.LifeTimeBilledAmount__c = totalAmount;
        
        accountList.add(a); // adding into the update list , which will update the accountlist with amount.
    } 
    if(accountList.size()>0 && accountList!=null){
        update accountList;
    }
}