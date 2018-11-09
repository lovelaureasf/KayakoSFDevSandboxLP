//We cannot test this class since this is part of the managed packaged code.
global class BatchSubscriptionVersionDateUpdater implements Database.Batchable<sObject>,Database.AllowsCallouts{
    global Database.QueryLocator start(Database.BatchableContext BC) {  // The start context will collect all subs in chunk of 200.
        
        String query = 'select id,name from zuora__subscription__c';
      
        return Database.getQueryLocator(query);  
    }
    
    
    global void execute(Database.BatchableContext BC, List<zuora__subscription__c> scope) { Set<String>recordIds = new Set<String>();
        
        for(zuora__subscription__c zs:scope){recordIds.add(zs.id);}List<Zuora__Subscription__c>subsList = new List<Zuora__Subscription__c>();for(Zuora__Subscription__c zs:[select id,name,Zuora__Version__c,VersionCreatedDate__c from Zuora__Subscription__c where id IN:recordIds]){Zuora.zApi zApiInstance = new Zuora.zApi();zApiInstance.zlogin();Zuora.zApi.QueryRequest qr = new Zuora.zApi.QueryRequest();Zuora.zApi.QueryOptions qo = new Zuora.zApi.QueryOptions();qo.batchSize = 2000;qo.caseSensitive = false;qr.queryOptions = qo;String subName = '\''+zs.name+'\'';String VersionNumber = '\''+String.valueOf(zs.Zuora__Version__c)+'\'';qr.zoql = 'Select  Version, Status, Name, Id,CreatedDate  from Subscription where name ='+subName+' AND Version='+versionNumber;Zuora.zApi.QueryResult queryResult = zApiInstance.zquery(qr);for (Zuora.zObject zobject : queryResult.records) {zs.VersionCreatedDate__c = Date.valueOf(String.valueOf(zobject.getValue('CreatedDate')).split(' ')[0]);}Zuora.zApi.QueryResult queryMoreResult;if(!queryResult.done){Zuora.zApi.QueryMoreRequest qmr = new Zuora.zApi.QueryMoreRequest();qmr.queryLocator = queryResult.queryLocator;queryMoreResult = zApiInstance.zqueryMore(qmr);for(Zuora.zObject zobject: queryMoreResult.records) { zs.VersionCreatedDate__c = Date.valueOf(String.valueOf(zobject.getValue('CreatedDate')).split(' ')[0]);}}subsList.add(zs);}update subslist;}        global void finish(Database.BatchableContext BC) {}
        
}