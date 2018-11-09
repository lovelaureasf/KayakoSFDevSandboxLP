public without sharing abstract class OpportunityButtonActionHandler 
{
    protected Opportunity opportunity;
    public Opportunity opp {get;set;}
    
    public String lostReason {get; set;}
    public String lostDetails {get;set;}
    public String wonReason {get;set;}
    public String wonDetails {get;set;}
    public String contractTerm {get;set;}
    public Decimal revenue{get;set;}
    public String lostStage{get;set;}
    public String competitors {get;set;}
    public List<SelectOption> lostStageList{get;set;}

    public OpportunityButtonActionHandler()
    {
        opportunity = OpportunityDataAccess.GetOpportunityById(getOpportunityId());
        opp = new opportunity();
        //adding closed lost values to the lost stage list 
        lostStageList = new List<SelectOption>();
        lostStageList.add(new SelectOption('Closed Lost: Dead','Closed Lost: Dead'));
        lostStageList.add(new SelectOption('Closed Lost: Duplicate','Closed Lost: Duplicate'));
        //lostStageList.add(new SelectOption('Closed Lost: Ignored','Closed Lost: Ignored'));
        opp = [select id,name,factors__c,comments__c,competitors__c,contractTerm__c,revenue__c from opportunity where id =:getOpportunityId()];
        
         if(opp!=null){
             wondetails = opp.comments__c;
             wonreason = opp.factors__c;
             contractTerm = opp.ContractTerm__c;
             opportunity.Competitors__c = opp.Competitors__c;
             revenue = opp.Revenue__c;
         }
        
    }

    protected Id getOpportunityId()
    {
        return ApexPages.currentPage().getParameters().get('id');
    }

    public PageReference DemoOpportunity()
    {
        opportunity.StageName = OpportunityStage.DEMO;
        opportunity.StageToDemoDate__c = Date.today();

        update opportunity;

        return Util.RedirectTo(getOpportunityId());
    }

    public PageReference ProjectPostponedOpportunity(){
        opportunity.StageName = OpportunityStage.PROJECT_POSTPONED;

        update opportunity;

        return Util.RedirectTo(getOpportunityId());
    }

    public PageReference ProvideProposalAndQuote()
    {
        opportunity.StageName = OpportunityStage.PROPOSAL_AND_QUOTE;
        opportunity.StageToProposalDate__c = Date.today();

        update opportunity;

        return Util.RedirectTo(getOpportunityId());
    }
    
    
    public PageReference markAsAccept()
    {
        opportunity.StageName = OpportunityStage.VALUE_PROPOSITION;
        opportunity.StageToValuePropositionDate__c = Date.today();

        update opportunity;

        return Util.RedirectTo(getOpportunityId());
    }
    
    
    public PageReference markAsReject()
    {
        opportunity.StageName = OpportunityStage.REJECTED;
        opportunity.LostDate__c = Date.today();

        update opportunity;

        return Util.RedirectTo(getOpportunityId());
    }
    
    
    

    public PageReference MarkAsLost()
    {
        
        if(lostStage == 'Closed Lost: Dead' && (lostReason=='' || lostReason==null)){
            
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select factor'));
            
            return null;
        
        }else{
        
        
        
        opportunity.LostDate__c = Date.today();
        opportunity.CloseDate = Date.today();
        opportunity.ClosedBy__c = 'Agent';
        opportunity.factors__c = lostReason;
        opportunity.comments__c = lostDetails;
        opportunity.StageName = lostStage;
        opportunity.Competitors__c = opp.Competitors__c;
        
        
        update opportunity;

        return Util.RedirectTo(getOpportunityId());
        
        }
    }

    public PageReference MarkAsWon()
    {
        opportunity.StageName = OpportunityStage.WON;
        opportunity.WonDate__c = Date.today();
        opportunity.CloseDate = Date.today();
        opportunity.ClosedBy__c = 'Agent';
        opportunity.comments__c = wondetails;
        opportunity.factors__c = wonreason;
        opportunity.ContractTerm__c = opp.contractTerm__c;
        opportunity.Competitors__c = opp.Competitors__c;
        opportunity.Revenue__c=revenue;
        update opportunity;

        return Util.RedirectTo(getOpportunityId());
    }
    
    
    public PageReference UpdateWonReason()
    {
        
        
        opportunity.comments__c = wondetails;
        opportunity.factors__c = wonreason;
        opportunity.ContractTerm__c = opp.contractTerm__c;
        opportunity.Competitors__c = opp.Competitors__c;
        opportunity.Revenue__c=revenue;
        update opportunity;

        return Util.RedirectTo(getOpportunityId());
    }

    public PageReference ReviewAndNegotiate()
    {
        opportunity.StageName = OpportunityStage.REVIEW_AND_NEGOTIATION;
        Opportunity.StageToNegotiationDate__c = Date.today();

        update opportunity;

        return Util.RedirectTo(getOpportunityId());
    }
    
    public List <SelectOption> GetLostReasonList()
    {
        return Util.GetPicklistValues(opportunity, 'factors__c');
    }
    
    public List <SelectOption> GetWonReasonList()
    {
        return Util.GetPicklistValues(opportunity, 'factors__c');
    }
    
    public List <SelectOption> GetCompetitorList()
    {
        return Util.GetPicklistValues(opportunity, 'competitors__c');
    }
    
    
    public List <SelectOption> GetContractTermList()
    {
        return Util.GetPicklistValues(opportunity, 'ContractTerm__c');
    }
    
    
    public PageReference upgrade()
    {
       
       List<opportunity>oList = new List<opportunity>();
       oList = [select id,name, Instance__c,Instance__r.id,Instance__r.Expiry_Date__c from opportunity where id =:opportunity.id limit 1];
       PageReference pg = new PageReference('/apex/productupdater?id='+olist[0].Instance__r.id+'&rec='+opportunity.id);
       pg.setRedirect(true);
       return pg; 

       
    }
    
}