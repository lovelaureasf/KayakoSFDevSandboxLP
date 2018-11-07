@isTest
public class InstanceControllerTest {
    public static testMethod void positiveScenario(){
        Instance__c i = new Instance__c();
        i.name='testing.kayako.com';
        insert i;
        ApexPages.StandardController sc = new ApexPages.StandardController(i);
        InstanceController ic = new InstanceController(sc);
        PageReference pageRef = Page.instance;
        pageRef.getParameters().put('id', String.valueOf(i.Id));
        Test.setCurrentPage(pageRef);
        
        ic.getData();
    }
}