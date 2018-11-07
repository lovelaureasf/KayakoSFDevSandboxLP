global class BatchLifetimeBilledAmountUpdater implements Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {  // The start context will collect all the accounts in chunk of 200.
        
        
        String query='select id from account';
        return Database.getQueryLocator(query);  
    }
   
    global void execute(Database.BatchableContext BC, List<Account> scope) { //The execute context performs the main operation that is filling net next charge amount field.
        
       Map<String,List<Zuora__Payment__c>>MapOfAccountWithPayments = new Map<String,List<Zuora__Payment__c>>();
       List<Account>accountList = new List<Account>();
       Set<String>accountSet = new Set<String>();
       
       
       
       
         for(Zuora__Payment__c zp : [select id,Zuora__Status__c,name,Zuora__Account__c,Zuora__Amount__c,Zuora__Invoice__r.Zuora__AmountWithoutTax__c from Zuora__Payment__c where Zuora__Account__r.id IN:scope ]){
             
             if(zp.Zuora__Status__c=='Processed'){
                 accountSet.add(zp.Zuora__Account__c);
                 if(MapOfAccountWithPayments.containsKey(zp.Zuora__Account__c)){
                     
                     MapOfAccountWithPayments.get(zp.Zuora__Account__c).add(zp);
                 
                 }else{
                     
                     MapOfAccountWithPayments.put(zp.Zuora__Account__c, new List<Zuora__Payment__c>{zp});
                 
                 }
             }
              
              }   
 
 
 
  
   
    for(account acc : [select id,LifeTimeBilledAmount__c from account where id IN:accountSet]){
        
        Decimal totalAmount=0;
        Decimal oldTotalAmount = acc.LifeTimeBilledAmount__c;
        if(MapOfAccountWithPayments.containsKey(acc.id)){
            
            for(Zuora__Payment__c zps : MapOfAccountWithPayments.get(acc.id)){
                
                /* if(String.valueOf(zps.Zuora__Amount__c).contains('(')){ // ( means its negative value
                            String newVal = String.valueOf(zps.Zuora__Amount__c).replace('(','-');
                            newVal = newVal.replace(')','');
                            zps.Zuora__Amount__c = Integer.valueOf(newVal);
                            System.debug('the new negative value is'+zps.Zuora__Amount__c);
                  }*/
                
                if(zps.Zuora__Invoice__r.Zuora__AmountWithoutTax__c!=null){
                    totalAmount = totalAmount+zps.Zuora__Invoice__r.Zuora__AmountWithoutTax__c;
                }
            }
          
        }
         Account a = new Account();
         a.id= acc.id;
         a.LifeTimeBilledAmount__c = totalAmount;
         if(a.LifeTimeBilledAmount__c!=oldtotalAmount){
             accountList.add(a);
         }
        
    } 

    update accountList;

    
    }   
    
    global void finish(Database.BatchableContext BC) {
    
    }
}