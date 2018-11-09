@isTest
public class UpdateSubscriptionStatusOnAccountTest{

    static testMethod void subscriptionInsertTest1(){
        Account a = new Account();
        a.Name = 'Test Account';
        
        insert a;
        
        Zuora__Subscription__c zs = new Zuora__Subscription__c();
        zs.Zuora__Account__c = a.id;
        zs.Zuora__Status__c = 'Active';
        insert zs; 
    }    
     
    static testMethod void subscriptionInsertTest2(){
        Account a = new Account();
        a.Name = 'Test Account';
        
        insert a;
        
        Zuora__Subscription__c zs = new Zuora__Subscription__c();
        zs.Zuora__Account__c = a.id;
        zs.Zuora__Status__c = 'Cancelled';
        //insert zs; 
    } 

    
    
}