@isTest
public class OnOpportunityClosedLostTest{
    public static testMethod void positiveScenario(){
        account a = new account();
        a.name = 'test';
        insert a;
        
        opportunity o = new opportunity();
        o.stageName='Demo';
        o.CloseDate = date.today()+30;
        o.name = 'testopp';
        insert o;
        
        opportunity o2 = new opportunity();
        o2.id=o.id;
        o2.StageName='Closed Lost:Dead';
        update o2;
    }
}