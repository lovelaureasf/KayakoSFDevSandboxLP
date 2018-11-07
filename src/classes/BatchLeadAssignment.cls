//Last modified by sruti on 2nd August 2018
//Added a field in query
global class BatchLeadAssignment implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        List<user> userList = new List<user>();
        userList = [select id,name from user where name='Backend Kayako' OR name='Hubspot SFDC' OR name='Rajiv Sharma' OR isActive=false];
        String stage = 'MQL';
        String status ='Open'; 
        String source = 'Unknown';
        String query = 'SELECT id,name,CountryCode,LeadSource from lead where ownerId IN: userList and Stage__c=:stage and Status=:status and ConvertedOpportunityId=null and isConverted=false and leadsource!=:source';
        return Database.getQueryLocator(query);
    }
   
    global void execute(Database.BatchableContext BC, List<Lead> scope) {
        try{     
             LeadOwnerAssigner.assignLeadOwner(scope);
        }
        catch(UnderflowException leadOwnerNotAssigned){
        
        }
    }   
    
    global void finish(Database.BatchableContext BC) {
    }
}