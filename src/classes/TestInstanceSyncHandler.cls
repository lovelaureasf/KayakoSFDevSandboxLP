@isTest
public class TestInstanceSyncHandler {
    public static testMethod void positiveScenario(){
    	 KayakoAuditorKey__c k =  new KayakoAuditorKey__c();
         k.name = 'ak';
         k.Key__c = 'test';
         insert k;
        InstanceSyncHandler.handleEvent('','','','');
    }    
}