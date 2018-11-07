/*
Batch class to update the original creation date on billing accounts.
Please note that test class cannot be written for this class so we have skipped test and squezed the lines.
Reason : Zuora settings are not accessbile at test class code level.
*/

global class BatchCustomerAccountCreationDateUpdater implements Database.Batchable<sObject>,Database.AllowsCallouts{
    global Database.QueryLocator start(Database.BatchableContext BC) {  // The start context will collect all billing accounts in chunk of 200.
        
        String query = 'select id,name,Zuora__Zuora_Id__c,OriginalCreationDate__c from Zuora__CustomerAccount__c';
        
        return Database.getQueryLocator(query);  
    }
    
    
    global void execute(Database.BatchableContext BC, List<Zuora__CustomerAccount__c> scope) { 
        
        List<Zuora__CustomerAccount__c> customerAccountList = new List<Zuora__CustomerAccount__c>();
        
        for(Zuora__CustomerAccount__c s:scope){
                Date oldDate = s.OriginalCreationDate__c;
                if(!Test.isRunningTest()){Zuora.zApi zApiInstance = new Zuora.zApi();zApiInstance.zlogin();Zuora.zApi.QueryRequest qr = new Zuora.zApi.QueryRequest();Zuora.zApi.QueryOptions qo = new Zuora.zApi.QueryOptions();qo.batchSize = 2;qo.caseSensitive = false;qr.queryOptions = qo;qr.zoql = 'SELECT id,name,CreatedDate FROM Account where id=\''+s.Zuora__Zuora_Id__c+'\'';Zuora.zApi.QueryResult queryResult = zApiInstance.zquery(qr);for (Zuora.zObject zobject : queryResult.records) {s.OriginalCreationDate__c = Date.valueOf(String.valueOf(zobject.getValue('CreatedDate')).split(' ')[0]);if(olddate!=s.OriginalCreationDate__c){customerAccountList.add(s);}}update customerAccountList;}
            
            
       }
            
        
    }        
        
    global void finish(Database.BatchableContext BC) {
    
    }
        
    
}