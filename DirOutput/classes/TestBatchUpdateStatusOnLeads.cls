/**
  * ───────────────────────────────────────────────────────────────────────────────────────────────┐
  * Type - Apex Test Class
  * ────────────────────────────────────────────────────────────────────────────────────────────────
  * @Object      None  
  * @Description This class will be used to test the batch class created
  * @OrigialCls  BatchUpdateStatusOnLeads
  * @Author      Manoj Sankaran
  * ───────────────────────────────────────────────────────────────────────────────────────────────┘
  * Modification Log
  * 09-21-2018 - Created by Manoj Sankaran
  * 
  */

@isTest(SeeAllData = false)
private class TestBatchUpdateStatusOnLeads {
  static testmethod void test_RunBatchUpdateStatusOnLeads() {
        
        User u = [Select Id, Name from user where Name = 'Backend Kayako' limit 1];
    
        System.runAs(u) {
              
            
            Instance__c ins = new Instance__c();
            ins.Name = 'Test Instance';
            ins.Expiry_Date__c = system.today().addDays(-30);
            insert ins;
            
            Lead objLead = new Lead(Company = 'JohnMiller', LastName = 'Mike', Status = 'Open', Stage__c = 'MQL',leadSource = 'Web',Instance__c = ins.id);
            insert objLead;
             
            Test.startTest();
                List<AsyncApexJob> listJob = [ Select id ,Status, ApexClass.Name from AsyncApexJob where Status='Running'];
                if(listJob == null || listJob.size() ==0 ) {
                    BatchUpdateStatusOnLeads bla= new BatchUpdateStatusOnLeads();
                    Database.executeBatch(bla);
                }
            Test.stopTest();
        }
    }
}