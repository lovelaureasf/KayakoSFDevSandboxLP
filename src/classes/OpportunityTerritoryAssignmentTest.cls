@isTest
public class OpportunityTerritoryAssignmentTest {

    static testmethod void  positiveTest(){

    account acc = new account();
    acc.name ='testopp';
    acc.billingcountrycode='IN';
    insert acc;
    
    opportunity o = new opportunity();
    o.name='testopp';
    o.type='New Business';
    o.StageName='Value Proposition';
    o.CloseDate=Date.today();
    o.accountId=acc.id;
    o.amount=33.25;
    insert o;
    

}
    
    
}