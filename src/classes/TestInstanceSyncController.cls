@isTest
public class TestInstanceSyncController{

public static testMethod void positiveScenario2(){
    
        KayakoAuditorKey__c km = new KayakoAuditorKey__c();
        km.name = 'tester';
        km.key__c = 'testing123';
        insert km;
        
        Instance__c i = new Instance__c();
        i.name = 'test.kayako.com';
        i.uuid__c = 'y3x-1111-33-444';
        i.instance_id__c = 2223;
        i.expiry_date__c = DateTime.now();
        insert i;
        
        Lead l = new Lead();
        l.company = 'test';
        l.email = 'test@test.com';
        l.lastname = 'test';
        l.ka_product__c = 'test';
        l.instance__c = i.id;
        insert l;
        
        test.startTest();
        /*ApexPages.StandardController sc = new ApexPages.StandardController(l);
        LeadButtonRenderer obj = new LeadButtonRenderer(sc);
        try{
        obj.GetCanAcceptOpenLead();
        obj.GetCanUpgrade();
        obj.GetCanMarkLeadContacted();
        obj.reject();
        obj.GetCanReopenLead();
        //obj.SeniorRoles();
        obj.GetCanConvertToContact();
        obj.convertToContact();
        }
        catch(exception e){}*/
        test.stopTest();
        
        }

    public static testMethod void positiveScenario(){
    
        KayakoAuditorKey__c km = new KayakoAuditorKey__c();
        km.name = 'tester';
        km.key__c = 'testing123';
        insert km;
        
        Instance__c i = new Instance__c();
        i.name = 'test.kayako.com';
        i.uuid__c = 'y3x-1111-33-444';
        i.instance_id__c = 2223;
        i.expiry_date__c = DateTime.now();
        insert i;
        
        Lead l = new Lead();
        l.company = 'test';
        l.email = 'test@test.com';
        l.lastname = 'test';
        l.ka_product__c = 'test';
        l.instance__c = i.id;
        insert l;
        
        
        Instance__c i2 = new Instance__c();
        i2.name = 'test.kayako.com';
        i2.uuid__c = 'y3x-1111-33-444';
        i2.instance_id__c = 2223;
        i2.expiry_date__c = DateTime.now();
        insert i2;
        
        Opportunity o = new Opportunity();
        o.name = 'test';
        o.product__c = 'test';
        o.plan__c ='test';
        o.instance__c = i2.id;
        o.stageName = 'Closed Won';
        o.CloseDate = Date.today();
        insert o;
        
        
        Test.setCurrentPageReference(new PageReference('Page.InstanceSync')); 
        System.currentPageReference().getParameters().put('id', i.id);
        ApexPages.StandardController sc = new ApexPages.StandardController(i);
        InstanceSyncController isc = new InstanceSyncController(sc);
        
        
        Test.setCurrentPageReference(new PageReference('Page.InstanceSync')); 
        System.currentPageReference().getParameters().put('id', i2.id);
        ApexPages.StandardController sc2 = new ApexPages.StandardController(i2);
        InstanceSyncController isc2 = new InstanceSyncController(sc2);
        
        
        
        Test.setCurrentPageReference(new PageReference('Page.InstanceHandler')); 
        System.currentPageReference().getParameters().put('id', i2.id);
        System.currentPageReference().getParameters().put('type', 'enable');
        InstanceHandlerController ihc0 = new  InstanceHandlerController();
        
        
        Test.setCurrentPageReference(new PageReference('Page.InstanceHandler')); 
        System.currentPageReference().getParameters().put('id', i2.id);
        System.currentPageReference().getParameters().put('type', 'disable');
        InstanceHandlerController ihc = new  InstanceHandlerController();
        ihc.goback();
        
        
        isc2.goBack();
        
    }
    
    public static testMethod void positiveScenarioInstanceSyncController2(){
    
        KayakoAuditorKey__c km = new KayakoAuditorKey__c();
        km.name = 'tester';
        km.key__c = 'testing123';
        insert km;
        
        Instance__c i = new Instance__c();
        i.name = 'test.kayako.com';
        i.uuid__c = 'y3x-1111-33-444';
        i.instance_id__c = 2223;
        i.expiry_date__c = DateTime.now();
        insert i;
        
        Lead l = new Lead();
        l.company = 'test';
        l.email = 'test@test.com';
        l.lastname = 'test';
        l.ka_product__c = 'test';
        l.instance__c = i.id;
        insert l;
        
        
        Instance__c i2 = new Instance__c();
        i2.name = 'test.kayako.com';
        i2.uuid__c = 'y3x-1111-33-444';
        i2.instance_id__c = 2223;
        i2.expiry_date__c = DateTime.now();
        insert i2;
        
        Opportunity o = new Opportunity();
        o.name = 'test';
        o.product__c = 'test';
        o.plan__c ='test';
        o.instance__c = i2.id;
        o.stageName = 'Closed Won';
        o.CloseDate = Date.today();
        insert o;
        
        
        Test.setCurrentPageReference(new PageReference('Page.InstanceSync')); 
        System.currentPageReference().getParameters().put('id', i.id);
        ApexPages.StandardController sc = new ApexPages.StandardController(i);
        InstanceSyncController2 isc = new InstanceSyncController2(sc);
        
        
        Test.setCurrentPageReference(new PageReference('Page.InstanceSync')); 
        System.currentPageReference().getParameters().put('id', i2.id);
        ApexPages.StandardController sc2 = new ApexPages.StandardController(i2);
        InstanceSyncController2 isc2 = new InstanceSyncController2(sc2);
        
        
        
        Test.setCurrentPageReference(new PageReference('Page.InstanceHandler')); 
        System.currentPageReference().getParameters().put('id', i2.id);
        System.currentPageReference().getParameters().put('type', 'enable');
        ApexPages.StandardController sc3 = new ApexPages.StandardController(i2);
        InstanceSyncController2 ihc0 = new  InstanceSyncController2(sc3);
        
        
        Test.setCurrentPageReference(new PageReference('Page.InstanceHandler')); 
        System.currentPageReference().getParameters().put('id', i2.id);
        System.currentPageReference().getParameters().put('type', 'disable');
        ApexPages.StandardController sc4 = new ApexPages.StandardController(i2);
        InstanceSyncController2 ihc = new  InstanceSyncController2(sc4);
        ihc.goback();
        
        
        isc2.goBack();
        
    }

}