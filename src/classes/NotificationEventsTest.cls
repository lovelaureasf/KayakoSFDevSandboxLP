@IsTest
public class NotificationEventsTest
{
    /*@IsTest(SeeAllData = true)
    public static void testAlertOnOpportunityAmountManipulation()
    {
        Test.setMock(HttpCalloutMock.class, new WebhookTest());
        
        List <Opportunity> opportunities = [select id, amount from opportunity limit 1];
        
        for(Integer i = 0; i < opportunities.size(); i++)
        {
            Double adjustment = Math.random() * -10;
            
            Opportunity o = opportunities.get(i);
            if(o.Amount == null) o.Amount = 0;
            o.Amount = o.Amount + adjustment;
            o.StageName = OpportunityStage.LOST;
        }

        update opportunities;
        
        for(Integer i = 0; i < opportunities.size(); i++)
        {
            Double adjustment = Math.random() * 10;
            
            Opportunity o = opportunities.get(i);
            if(o.Amount == null) o.Amount = 0;
            o.Amount = o.Amount + adjustment;
            o.StageName = OpportunityStage.DEMO;
        }
        
        update opportunities;
        
        for(Integer i = 0; i < opportunities.size(); i++)
        {
            Double adjustment = Math.random() * -10;
            
            Opportunity o = opportunities.get(i);
            if(o.Amount == null) o.Amount = 0;
            o.Amount = o.Amount + adjustment;
            o.StageName = OpportunityStage.LOST;
        }
        
        update opportunities;
    }*/
}