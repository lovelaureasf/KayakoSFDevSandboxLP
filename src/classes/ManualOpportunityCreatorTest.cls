@isTest
public class ManualOpportunityCreatorTest{
	//Test class for ManualOpportunityCreator controller
    static testmethod void Test_ManualOpportunityCreator(){
        List<UserRole> csmRoleId = [select id from userRole where name='Account Executive Europe' 
                                    OR name='Account Executive Americas' limit 1];
        User userAE = new User(alias = 'standt', 
                                 email='testingkayako@testorg.com', 
                                 emailencodingkey='UTF-8', 
                                 lastname='Testing', languagelocalekey='en_US', 
                                 localesidkey='en_US',
                                 UserRoleId = csmRoleId[0].Id,
                                 profileid = [Select Id From Profile where Name like 'System administrator' limit 1 ].id, 
                                 timezonesidkey='America/Los_Angeles', 
                                 username='userTest343232@kayako.com');
        insert userAE;
		System.runAs(userAE) {
            Test.startTest();
                Opportunity opp = new Opportunity();
                opp.amount=100;
                opp.name='test opp';
                opp.closedate=date.today();
                opp.stageName='Value Proposition';
                opp.type='due';
                opp.product__c='test';
                opp.plan__c='test';
                ApexPages.StandardController sc = new ApexPages.StandardController(opp);
                ManualOpportunityCreator moc = new ManualOpportunityCreator(sc);
                moc.opportunity=opp;
                moc.getlistOfTerritories();
                moc.getlistofCSMUsers();
                moc.save();
           Test.stopTest();
        }
    }
}