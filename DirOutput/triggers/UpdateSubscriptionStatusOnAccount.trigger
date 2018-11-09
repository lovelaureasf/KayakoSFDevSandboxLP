/** Author : Sagar Pareek
    Description : This trigger updates type field on the account object whenever a subscription is updated/created in Salesforce.
    

**/

trigger UpdateSubscriptionStatusOnAccount on Zuora__Subscription__c (after update,after insert) {
    
    Map<String,Zuora__Subscription__c>accountAndStatusMap = new Map<String,Zuora__Subscription__c>();
    List<Account>accountList = new List<Account>();
   
    Map<Id,List<Zuora__Subscription__c>>AccountWithListOfSubscriptions = new Map<Id,List<Zuora__Subscription__c>>();
    
    
    for(Zuora__Subscription__c zs : Trigger.New){ //creates map of account linked to subscription with subscription record.
            
            if(zs.Zuora__Status__c!=null){
                accountAndStatusMap.put(zs.Zuora__Account__c,zs);    
            }
             
     }
     
     for(Zuora__Subscription__c z : [select id,Zuora__Account__c from Zuora__Subscription__c where id IN:accountAndStatusMap.keySet()]){ //creates map of account with list of all the subscriptions linked to it.
            
            if(!AccountWithListOfSubscriptions.containsKey(z.Zuora__Account__c)){
                AccountWithListOfSubscriptions.put(z.Zuora__Account__c,new List<Zuora__Subscription__c>{z});   
            }
            else{
                AccountWithListOfSubscriptions.get(z.Zuora__Account__c).add(z);
            }
             
     }
     
     /*
         The code below performs following operations -
         1.When a active subscription record is created it marks the account as Customer.
         2.When a subscription is cancelled and there is no more active subscription present in system, it marks the account - Cancelled.
        
     
     */
     
     
     for(account a : [select id,Type from account where id IN :accountAndStatusMap.keySet()]){ 
         Boolean customer =false;
         if(accountAndStatusMap.get(a.id).Zuora__Status__c=='Active' && Trigger.isInsert){
             a.Status__c='Active';
         }
         else if(accountAndStatusMap.get(a.id).Zuora__Status__c=='Cancelled'){
             if(AccountWithListOfSubscriptions.containsKey(a.id)){
                 for(Zuora__Subscription__c z1 : AccountWithListOfSubscriptions.get(a.id)){
                     if(z1.id!=accountAndStatusMap.get(a.id).id && z1.Zuora__Status__c=='Active' ){
                         customer =true;
                     }    
                 
                 }
            } 
             if(!customer){
                 a.Status__c='Cancelled';
             }
         }
         
         accountList.add(a);
     
     }
    
    update accountList;
    
}