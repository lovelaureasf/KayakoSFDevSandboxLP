@isTest(SeeAllData=true)
public class DripEmailTest {

     static testMethod void positive(){  
         List<id>lList = new List<id>();
         List<id>oList = new List<id>();
         for(lead l :[select id from lead where ownerid!=null and Included_In_Drip_Date__c!=null and isconverted=false limit 1]){
             llist.add(l.id);
         }
         
         for(opportunity o: [select id from opportunity where ownerid!=null and lead_id__c!=null limit 1]){
            olist.add(o.id);      
         }
       
        EmailUtil1Hour.mailSender(llist); 
        EmailUtilOneHourK5.mailSender(llist);
        EmailUtilOneHour.mailSender(llist);
        
        
        EmailUtil168Hours.mailSender(llist);
        
        EmailUtil72Hour.mailSender(llist);
        EmailUtil170Hour2.mailSender(llist);
        EmailUtil336Hour.mailSender(llist);
        
        
        
        
        
        EmailUtil170Hour.mailSender(llist);
        EmailUtilLeadTrialExpiry.mailSender(llist);
        EmailUtilOpportunityTrialExpiry.mailSender(olist);
        EmailUtil600Hour.mailSender(llist);
        EmailUtil48Hour.mailSender(llist);
        
        
        EmailUtil93Hour.mailSender(llist);
        EmailUtil1HourForOpp.mailSender(llist); 
        EmailUtil170HourForOpp.mailSender(llist);
        EmailUtil600HourForOpp.mailSender(llist);
        EmailUtil93HourForOpp.mailSender(llist);
    }
}