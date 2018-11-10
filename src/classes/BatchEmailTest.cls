// Change for demo
@isTest(SeeAllData = true)
public class BatchEmailTest {
    static testMethod void positivescenario(){        
    BatchLeadTrialExpiryEmail e = new BatchLeadTrialExpiryEmail();
    BatchOpportunityTrialExpiryEmail e2 = new BatchOpportunityTrialExpiryEmail();
    Test.startTest();
        Database.executeBatch(e);
        Database.executeBatch(e2);
    Test.stopTest();
    }
}
// Demo Changes .. to commit to git