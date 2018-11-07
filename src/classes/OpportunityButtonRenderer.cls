public without sharing class OpportunityButtonRenderer extends OpportunityButtonActionHandler
{
    public OpportunityButtonRenderer(ApexPages.StandardController controller) {}

    public boolean GetCanDemoOpportunity()
    {
        return OpportunityStage.VALUE_PROPOSITION.equals(opportunity.StageName);
    }

    public boolean GetCanProjectPostponedOpportunity()
    {
        return (OpportunityStage.DEMO.equals(opportunity.StageName) || OpportunityStage.VALUE_PROPOSITION.equals(opportunity.StageName)) ;
    }

    public boolean GetCanProvideProposalAndQuote()
    {
        return OpportunityStage.VALUE_PROPOSITION.equals(opportunity.StageName) ||
            OpportunityStage.DEMO.equals(opportunity.StageName);
    }

    public boolean GetCanMarkAsLost()
    {
        return ! (Opportunity.StageName == 'Created' || Opportunity.StageName == 'Closed Lost: Dead' || Opportunity.StageName=='Closed Lost: Duplicate' || Opportunity.StageName=='Closed Won');
    }
    
    
    public boolean GetCanMarkAsAccept()
    {
           User currentUser = UserDataAccess.GetCurrentUser();
           Set<String>RoleSet = new Set<String>();
            for(UserRole r :[select id from UserRole where name LIKE 'Account Executive%' OR name LIKE 'Region Leaders%']){
                RoleSet.add(r.id);
            }
           return  (Opportunity.StageName == 'Created' && (currentUser.Profile.Name == 'System Administrator' || RoleSet.contains(currentUser.UserRoleId)));
    }
    
    public boolean GetCanMarkAsReject()
    {
        User currentUser = UserDataAccess.GetCurrentUser();
        Set<String>RoleSet = new Set<String>();
        for(UserRole r :[select id from UserRole where name LIKE 'Account Executive%' OR name LIKE 'Region Leaders%']){
            RoleSet.add(r.id);
        }
        return  (Opportunity.StageName == 'Created' && (currentUser.Profile.Name == 'System Administrator' || RoleSet.contains(currentUser.UserRoleId)));

    
    }
    public boolean GetCanMarkAsWon()
    {
       
       if(Opportunity.Type!='New Business' && Opportunity.Type!='Existing - K4 to Kayako'){ 
        
        User currentUser = UserDataAccess.GetCurrentUser();
        Set<String>RoleSet = new Set<String>();
        for(UserRole r :[select id from UserRole where name LIKE 'Region Leader%']){
            RoleSet.add(r.id);
        }
        return (currentUser.Profile.Name == 'System Administrator' || RoleSet.contains(currentUser.UserRoleId)) && ( 
            (OpportunityStage.REVIEW_AND_NEGOTIATION.equals(opportunity.StageName) ||
            OpportunityStage.PROPOSAL_AND_QUOTE.equals(opportunity.StageName))
        );
    
      }else{ 
        
        User currentUser = UserDataAccess.GetCurrentUser();
        
        
        return (currentUser.Profile.Name == 'System Administrator' && 
            (OpportunityStage.REVIEW_AND_NEGOTIATION.equals(opportunity.StageName) ||
            OpportunityStage.PROPOSAL_AND_QUOTE.equals(opportunity.StageName))
        ); 
          
          
      }
    
    }

    public boolean GetCanReviewAndNegotiate()
    {
        return OpportunityStage.PROPOSAL_AND_QUOTE.equals(opportunity.StageName);
    }

    public boolean GetCanProvideNewQuote()
    {
        return OpportunityStage.PROPOSAL_AND_QUOTE.equals(opportunity.StageName) || Opportunity.StageName.equals('Negotiation/Review');
    }
    
    public boolean GetCanUpdatePrice()
    {
        return ! (OpportunityStage.CREATED.equals(Opportunity.StageName) || OpportunityStage.WON.equals(opportunity.StageName) || OpportunityStage.LOST.equals(opportunity.StageName));
    }
    
    public boolean GetCanUpdateInstanceDetails()
    {
        return ! (OpportunityStage.WON.equals(opportunity.StageName) || OpportunityStage.LOST.equals(opportunity.StageName));
    }
    
    public boolean GetCanUpgrade()
    {
        
        List<opportunity>oList = new List<opportunity>();
        oList = [select id,name, Instance__c,Instance__r.state__c,Instance__r.Expiry_Date__c,Product__c from opportunity where (Type = 'New Business' OR Type= 'Existing - K4 to Kayako') AND id =:opportunity.id limit 1];
        if(olist!=null && olist.size()>0 && olist[0].instance__c!=null && olist[0].Instance__r.state__c!='DELETED' && olist[0].Instance__r.Expiry_Date__c>=Date.today()-1 && olist[0].Product__c.startsWith('Kayako (') ){
            return true;
        }else{
            return false;
        }
            
        
        
      }
    
}