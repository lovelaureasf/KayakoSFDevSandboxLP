@isTest
public class UpdateSalesRepOnBillingAccountTest {
    public static testMethod void postiveScenario(){
        account acc = new account();
        acc.name = 'testacc';
        insert acc;
        
        Zuora__CustomerAccount__c z = new  Zuora__CustomerAccount__c();
        z.Zuora__Account__c = acc.id;
        insert z;
        
        opportunity o = new opportunity();
        o.type = 'New Business';
        o.StageName ='Value Proposition';
        o.accountid = acc.id;
        o.CloseDate = date.today()+30;
        o.Name='test opp';
        insert o;
        
        
        
        o.StageName = 'Closed Won';
        update o;
        
    }
    
    public static testMethod void negativeScenario(){
        account acc = new account();
        acc.name = 'testacc';
        insert acc;
        
        Zuora__CustomerAccount__c z = new  Zuora__CustomerAccount__c();
        z.Zuora__Account__c = acc.id;
        z.Zuora__SalesRepName__c ='Sagar Pareek';
        insert z;
        
        opportunity o = new opportunity();
        o.type = 'New Business';
        o.StageName ='Value Proposition';
        o.accountid = acc.id;
        o.CloseDate = date.today()+30;
        o.Name='test opp';
        insert o;
        
        
        
        o.StageName = 'Closed Won';
        update o;
        
    }
    
    public static testMethod void negativeScenario2(){
        account acc = new account();
        acc.name = 'testacc';
        insert acc;
        
        Zuora__CustomerAccount__c z = new  Zuora__CustomerAccount__c();
        z.Zuora__Account__c = acc.id;
        z.Zuora__SalesRepName__c ='Puneet Kataria';
        insert z;
        
        opportunity o = new opportunity();
        o.type = 'New Business';
        o.StageName ='Value Proposition';
        o.accountid = acc.id;
        o.CloseDate = date.today()+30;
        o.Name='test opp';
        insert o;
        
        
        
        o.StageName = 'Closed Won';
        update o;
        
    }
}