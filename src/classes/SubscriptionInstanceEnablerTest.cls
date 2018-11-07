@isTest(SeeAllData = True)
public class SubscriptionInstanceEnablerTest {
    public static  testmethod void enableTest(){
    	
        Zuora__Subscription__c zs = new Zuora__Subscription__c(); 
        
        zs =[select id,SecurityToken__c,Zuora__Zuora_Id__c from Zuora__Subscription__c limit 1];    
		
        ApexPages.StandardController sc = new ApexPages.StandardController(zs);
        
        PageReference pageRef = new PageReference('/'+zs.Id);
        pageRef.getParameters().put('id', String.valueOf(zs.Id));
        Test.setCurrentPage(pageRef);
        
        SubscriptionInstanceEnabler sie = new SubscriptionInstanceEnabler(sc);
     	
        
        
        sie.recordId = zs.id;
        
        sie.submitUpdateRequest();
        
        SubscriptionExpiryExtender see = new SubscriptionExpiryExtender(sc);
        
        see.recordId = zs.id;
        
        see.daySelected='7';
        
        see.backToDetailPage();
        
        see.submitExpiry();
    }
}