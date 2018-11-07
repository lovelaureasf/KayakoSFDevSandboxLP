@isTest
public class TestBatchExistingCustomerUpdater {
    static testmethod void testScheduleBatchUpdateNetNextChargeAmount(){
        test.startTest();
        ScheduleBatchUpdateNetNextChargeAmount obj = new ScheduleBatchUpdateNetNextChargeAmount();
        test.stopTest();
    }
    static testmethod void testScheduleBatchLifetimeBilledAmountUpdater(){
        test.startTest();
        ScheduleBatchLifetimeBilledAmountUpdater obj = new ScheduleBatchLifetimeBilledAmountUpdater();
        test.stopTest();
    }
    public static testMethod void positiveScenario(){
      
        
        lead l = new lead();
        l.lastname = 'test';
        l.email = 'test@test.com';
        l.company ='test';
        l.stage__c = 'SRL';
        insert l;
        Test.startTest(); //get all the limits back
        
        BatchExistingCustomerUpdater b = new BatchExistingCustomerUpdater(); //call the batch
        
        Database.executeBatch(b);
        
        Test.stopTest(); //out of limit execution block
    } 
    PRIVATE static testmethod void testInstanceSyncHandler() {
        List<Instance__c> aList = new List<Instance__c>();
       
            Instance__c a = new Instance__c();
            a.name='test.instance.com';
            a.uuid__c ='fhjk373379fhfjdkshfjks';
            a.Expiry_Date__c = DateTime.Now();
            a.instance_id__c = 444;
            insert a;


           Lead l = new Lead();
           l.lastName = 'test';
           l.Email = 'test@test.com';
           l.Company = 'test company';
           l.Instance__c = a.id;
           l.ka_product__c = 'Standard';
           insert l;
           
        insert (new KayakoAuditorKey__c(name = 'test', Key__c='12ssssssssssss') );
        Test.startTest(); //get all the limits back
        
        InstanceSyncHandler.handleEvent('fhjk373379fhfjdkshfjks', string.valueOf(DateTime.Now()), l.id, '');
        Test.stopTest(); //out of limit execution block
    }
    PRIVATE static testmethod void testLeadHandler() {
                
                             User userAE = new User(alias = 'standt', 
                                 email='testingkayako@testorg.com', 
                                 emailencodingkey='UTF-8', 
                                 lastname='Testing', languagelocalekey='en_US', 
                                 localesidkey='en_US',
                                 //UserRoleId = csmRoleId[0].Id,
                                 profileid = [Select Id From Profile where Name like 'System administrator' limit 1 ].id, 
                                 timezonesidkey='America/Los_Angeles', 
                                 username='userTest39943232@kayako.com');
                insert userAE;
        Lead l = new Lead(
                    email = 'newlead@mail.com', 
                    CountryCode = 'US', 
                    lastName = 'last name', 
                    firstName = 'first name', 
                    company = 'test company'
                    
                );

                
                l.put('Email', 'kayako.testing@kayako.com');
                l.put('CountryCode', 'US');
                l.put('KA_Product__c','test');
                l.put('KA_ProductType__c','test');
                insert l;
                
        Lead newLead = new Lead(id= l.Id, LeadSource = 'Demo Request', ownerid= userAE.Id);
        Test.startTest(); //get all the limits back
        Map<id, Lead> mapLead = new Map<id, Lead>();
        mapLead.put(l.Id, newLead);
        LeadTriggerHandler.handleBeforeInsert(new list<lead>{l}, mapLead);
        LeadTriggerHandler.handleafterInsert(new list<lead>{l}, mapLead);
        LeadTriggerHandler.handleBeforeupdate(new list<lead>{l}, mapLead);
        LeadTriggerHandler.handleafterupdate(new list<lead>{l}, mapLead);
        Test.stopTest(); //out of limit execution block
    }
    private static testmethod void testErrorlog() {
        try{
            insert new Lead();
        }
        catch(exception e) {
            SF_LogError.logError(e);
        }
    }
}