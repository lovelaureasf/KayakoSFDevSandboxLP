@isTest
public class EmailTemplateHandler_Test{
    
    public static testMethod void positiveScenario(){
        
        KayakoAuditorKey__c kak = new KayakoAuditorKey__c();
        kak.name = 'test';
        kak.key__c = 'test';
        insert kak;
        
        Instance__c i = new Instance__c();
        i.name = 'test.kayako.com';
        i.instance_id__c = 22233;
        insert i;
        
        Lead l = new Lead();
        l.lastname = 'test';
        l.email = 'test@test.com';
        l.company = 'test';
        l.instance__c = i.id;
        insert l;
        
       Test.setCurrentPageReference(new PageReference('Page.emailtemplate'));
       System.currentPageReference().getParameters().put('id', i.id);
       System.currentPageReference().getParameters().put('type', 'enable');
         

        
            
        EmailTemplateHandler et = new EmailTemplateHandler();
       
    }
    
    
    public static testMethod void negativeScenario(){
        
        KayakoAuditorKey__c kak = new KayakoAuditorKey__c();
        kak.name = 'test';
        kak.key__c = 'test';
        insert kak;
        
        Instance__c i = new Instance__c();
        i.name = 'test.kayako.com';
        i.instance_id__c = 22233;
        insert i;
        
        Lead l = new Lead();
        l.lastname = 'test';
        l.email = 'test@test.com';
        l.company = 'test';
        l.instance__c = i.id;
        insert l;
        
       Test.setCurrentPageReference(new PageReference('Page.emailtemplate'));
       System.currentPageReference().getParameters().put('id', i.id);
       System.currentPageReference().getParameters().put('type', 'disable');
         

        
            
        EmailTemplate et = new EmailTemplate();
       
    }

}