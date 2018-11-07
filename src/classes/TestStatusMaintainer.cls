@isTest(SeeAllData = true)
public class TestStatusMaintainer {
   
    public static testMethod void processedScenario(){
        
        StatusMaintainer sm = new StatusMaintainer();
        
        //creating test data
        List<Account>accList = new List<Account>(); // this list will hold those accounts which needs to be passed on to the maintainer.
        
        Account acc = new Account();
        acc.Name = 'test account 1';
        insert acc;              // inserting test account1
        
        Zuora__CustomerAccount__c ba = new Zuora__CustomerAccount__c();
        ba.name = acc.Name;
        ba.Zuora__Account__c = acc.id;
        insert ba;          // inserting the billing account associated with account 1 
        
        Zuora__Subscription__c zs = new Zuora__Subscription__c();
        zs.Zuora__Status__c = 'Active';
        zs.Zuora__Account__c = acc.Id;
        insert zs; // inserting active subscription for the test account 1
        
        Zuora__ZInvoice__c zi = new Zuora__ZInvoice__c();
        zi.Zuora__Account__c = acc.id;
        zi.Zuora__PaymentAmount__c = 12;
        insert zi;
        
        Zuora__Payment__c zp = new Zuora__Payment__c();
        zp.Zuora__Account__c = acc.id;
        zp.Zuora__Status__c = 'Processed';
        zp.Zuora__Invoice__c = zi.Id;
        zp.Zuora__BillingAccount__c = ba.id;
        insert zp;
        
        
        Zuora__PaymentInvoice__c pi = new Zuora__PaymentInvoice__c();
        pi.Zuora__Payment__c =zp.id;
        pi.Zuora__Invoice__c = zi.id;
        pi.Zuora__ApplyAmount__c = 0;
        insert pi;
        
        
        
     
        
        accList.add(acc);
        
      
        
        sm.updater(accList);
    }
    
    
    public static testMethod void errorScenario(){
        
        StatusMaintainer sm = new StatusMaintainer();
        
        //creating test data
        List<Account>accList = new List<Account>(); // this list will hold those accounts which needs to be passed on to the maintainer.
        
        Account acc = new Account();
        acc.Name = 'test account 1';
        insert acc;              // inserting test account1
        
        Zuora__CustomerAccount__c ba = new Zuora__CustomerAccount__c();
        ba.name = acc.Name;
        ba.Zuora__Account__c = acc.id;
        insert ba;          // inserting the billing account associated with account 1 
        
        Zuora__Subscription__c zs = new Zuora__Subscription__c();
        zs.Zuora__Status__c = 'Active';
        zs.Zuora__Account__c = acc.Id;
        insert zs; // inserting active subscription for the test account 1
        
        Zuora__ZInvoice__c zi = new Zuora__ZInvoice__c();
        zi.Zuora__Account__c = acc.id;
        zi.Zuora__PaymentAmount__c = 12;
        insert zi;
        
        Zuora__Payment__c zp = new Zuora__Payment__c();
        zp.Zuora__Account__c = acc.id;
        zp.Zuora__Status__c = 'Error';
        zp.Zuora__Invoice__c = zi.Id;
        zp.Zuora__BillingAccount__c = ba.id;
        insert zp;
        
        Zuora__PaymentInvoice__c pi = new Zuora__PaymentInvoice__c();
        pi.Zuora__Payment__c =zp.id;
        pi.Zuora__Invoice__c = zi.id;
        pi.Zuora__ApplyAmount__c = 0;
        insert pi;
        
      
        
        accList.add(acc);
        
            
        
        sm.updater(accList);
    }
    
    public static testMethod void prospectScenario(){
        
        StatusMaintainer sm = new StatusMaintainer();
        
        //creating test data
        List<Account>accList = new List<Account>(); // this list will hold those accounts which needs to be passed on to the maintainer.
        
        Account acc = new Account();
        acc.Name = 'test account 1';
        insert acc;              // inserting test account1
        
        Zuora__CustomerAccount__c ba = new Zuora__CustomerAccount__c();
        ba.name = acc.Name;
        ba.Zuora__Account__c = acc.id;
        insert ba;          // inserting the billing account associated with account 1 
        
       
       
        accList.add(acc);
        
        
        
        sm.updater(accList);
    }
    
    public static testMethod void noPaymentScenario(){
        
        StatusMaintainer sm = new StatusMaintainer();
        
        //creating test data
        List<Account>accList = new List<Account>(); // this list will hold those accounts which needs to be passed on to the maintainer.
        
        Account acc = new Account();
        acc.Name = 'test account 1';
        insert acc;              // inserting test account1
        
        Zuora__CustomerAccount__c ba = new Zuora__CustomerAccount__c();
        ba.name = acc.Name;
        ba.Zuora__Account__c = acc.id;
        insert ba;          // inserting the billing account associated with account 1 
        
        Zuora__Subscription__c zs = new Zuora__Subscription__c();
        zs.Zuora__Status__c = 'Active';
        zs.Zuora__Account__c = acc.Id;
        insert zs; // inserting active subscription for the test account 1
        
        Zuora__ZInvoice__c zi = new Zuora__ZInvoice__c();
        zi.Zuora__Account__c = acc.id;
        zi.Zuora__PaymentAmount__c = 12;
        insert zi;
        
        
        
        
        accList.add(acc);
        
       
        sm.updater(accList);
    }
    
    public static testMethod void cancelledScenario(){
        
        StatusMaintainer sm = new StatusMaintainer();
        
        //creating test data
        List<Account>accList = new List<Account>(); // this list will hold those accounts which needs to be passed on to the maintainer.
        
        Account acc = new Account();
        acc.Name = 'test account 1';
        insert acc;              // inserting test account1
        
        Zuora__CustomerAccount__c ba = new Zuora__CustomerAccount__c();
        ba.name = acc.Name;
        ba.Zuora__Account__c = acc.id;
        insert ba;          // inserting the billing account associated with account 1 
        
        Zuora__Subscription__c zs = new Zuora__Subscription__c();
        zs.Zuora__Status__c = 'Cancelled';
        zs.Zuora__Account__c = acc.Id;
        insert zs; // inserting cancelled subscription for the test account 1
        
        Zuora__Subscription__c zs2 = new Zuora__Subscription__c();
        zs2.Zuora__Status__c = 'Cancelled';
        zs2.Zuora__Account__c = acc.Id;
        insert zs2; // inserting cancelled subscription for the test account 1
        
        
        Zuora__Subscription__c zs3 = new Zuora__Subscription__c();
        zs3.Zuora__Status__c = 'Cancelled';
        zs3.Zuora__Account__c = acc.Id;
        insert zs3; // inserting cancelled subscription for the test account 1
        
        
               
        accList.add(acc);
        
       
        
        sm.updater(accList);
    }
    
}