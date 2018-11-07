//******************************************************************
// Name: BatchUpdateStatusOnLeads
// Purpose: This is a batch which updates Trial leads 
// Author: sruti Srivastava
// Date: 27/09/2018 
//******************************************************************
global class BatchUpdateStatusOnLeads implements Database.Batchable<sObject>,Database.AllowsCallouts {
    
    //QUerying trials leads with 22 days of post expiry 
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        Date date22DaysfromToday = Date.today().addDays(-22);
        String query = 'select Id,Name,KA_Product__c,isConverted,Instance__c from Lead where LeadSource != \'Demo Requested\' '+
                        ' AND LeadSource != \'Webinar\' AND LeadSource != \'Kayako Demo\' '+
                        ' AND Status!= \'Expired Trial\'  AND Trial_Expiry_Date__c <= :date22DaysfromToday and isConverted = false';
        return Database.getQueryLocator(query);  
    }
    
    global void execute(Database.BatchableContext BC, List<Lead> scope) { 
      
        Map<Id,Lead> mapLead = new Map<Id, Lead>();
        List<User> users = [select id FROm USER where name like 'Hamzah Tariq%' limit 1];
        
        //Querying assigning Owner as hamzah and setting up stage as MQL
        for(Lead l:  scope){
            l.Status= 'Expired Trial';
            l.OwnerId = (users != null && users.size() > 0 )?users[0].Id:l.OwnerId;
            l.Stage__c= 'MQL';
            mapLead.put(l.id,l);
        }
        if(!mapLead.isEmpty())  
            update mapLead.values();
    } 
      
    global void finish(Database.BatchableContext BC) {
    }    
}