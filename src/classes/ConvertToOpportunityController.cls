public without sharing class ConvertToOpportunityController extends LeadFlowButtonHandler
{    
    public Opportunity opportunity { get; set; }
    public List <SelectOption> allCompetitors { get; set; }
    public List <String> opportunityCompetitors { get; set; }
    public Account acc;
    //public String selectedAccountId{get;set;}
    public String selectedAccountOption{get;set;}
    public Opportunity newOpportunity{get;set;}
    public Boolean showPanel{get;set;}
    public String ac;
    public Integer contactCount{get;set;}
    
    public ConvertToOpportunityController(ApexPages.StandardController controller)
    {
        super(controller);
        opportunity = new Opportunity();
        opportunity.CloseDate = Date.today().addDays(30);
        allCompetitors = GetListOfCompetitors();
        acc = new Account();
        selectedAccountOption ='Existing Account';
        newOpportunity = new Opportunity();
        contactCount = [select count() from contact where email=:lead.email];
        if(contactCount>0){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'A contact already exists. Click'+'<a href="/_ui/search/ui/UnifiedSearchResults?searchType=2&sen=001&sen=00Q&sen=003&sen=00T&sen=005&sen=00U&sen=006&sen=a19&sen=a1k&sen=a1m&sen=00O&str='+lead.email+'">'+'here</a>'+'to check. You might want to link this one to an existing account.');
            ApexPages.addMessage(myMsg);                
        }
    }
    
   
    
    public PageReference ConvertToOpportunity()
    {
        try{
            
            lead l = new lead(id=lead.id);
            l.CancelDripFlow__c = true;
            update l;

            Territory2 leadTerritory = TerritoryDataAccess.GetLeadRegion(lead);

            String role = TerritoryDataAccess.GetUserRole(user, leadTerritory);

            Id currentOwner = lead.OwnerId;
            Id NewOwner;
            // If user is an ADM and does not have a Manager, we cannot assign the lead to
            // anybody. In this case just show them an error so that they can talk to the
            // person responsible for assigning the manager to ADM.

            if (!Test.isRunningTest()) {
                if(role.equals(RoleName.ADM) || role.equals(RoleName.ISM))
                {
                    if(user.ManagerId == null)
                    {
                        lead.addError('You do not have a manager assigned to handle interested leads, therefor the lead cannot be marked as interested.');
                        return Util.RedirectTo(GetLeadId());
                    }
                    If (role.equals(RoleName.ISM)) {
                        NewOwner = lead.OwnerId;
                     //   NewOwner = user.ManagerId;

                    } else {
                        NewOwner = user.ManagerId;
                    }
                    System.debug('user id got is'+NewOwner);
                }
            }

            
            Database.LeadConvert converter = new Database.LeadConvert();

            converter.setLeadId(lead.Id);
            converter.setConvertedStatus(LeadStatus.CONVERTED);
            converter.setDoNotCreateOpportunity(false);
           
            
            if(newOpportunity.accountid!=null){
                account act = new account(id=newOpportunity.accountid,Type='Standard');
                update act;
                converter.setAccountid(newOpportunity.accountid);
            }
            Database.Leadconvertresult conversion = Database.convertLead(converter);
            if(Test.isRunningTest()){
                opportunity.id = conversion.getOpportunityId();
            }
            Id opportunityId = conversion.getOpportunityId();
            System.debug('the opportunity id is'+opportunityid);
            newOpportunity = OpportunityDataAccess.GetOpportunityById(opportunityId);
            
            newOpportunity.StageName   = OpportunityStage.CREATED;
            newOpportunity.Amount      = opportunity.Amount;
            newOpportunity.CloseDate   = opportunity.CloseDate;
            newOpportunity.Type        = opportunity.Type;
            newOpportunity.Plan__c     = opportunity.Plan__c;
            newOpportunity.Product__c  = opportunity.Product__c;
            
            if(!Test.isRunningTest()){
                
                // Update Lead owner as first SDR who worked on Lead
                newOpportunity.LeadOwner__c = lead.Assigned_SDR__c;
                newOpportunity.Reassigned_To__c = lead.Reassigned_To__c;
                System.debug('the new owner is'+newOwner);
                newOpportunity.OwnerId = newOwner;
            
            }
            // Update checklist values to Opportunity from lead
            newOpportunity.Budget_determined__c = lead.Budget_determined__c;
            newOpportunity.Authority_determined__c = lead.Authority_determined__c;
            newOpportunity.Needs_determined__c  = lead.Needs_determined__c;
            newOpportunity.Timeline_determined__c = lead.Timeline_determined__c;
            newOpportunity.The_number_of_seats__c = lead.The_number_of_seats__c;    
            newOpportunity.Proposed_Kayako_Plan__c = lead.Proposed_Kayako_Plan__c;  
            // Update infer score an rank on Opportunity
            newOpportunity.Lead_Infer_Fit_Score__c = lead.infer3__Infer_Rating__c;
            newOpportunity.Lead_Infer_Fit_Score_0_100__c = lead.infer3__Infer_Score__c;
            
            if(lead.infer3__Infer_Rating__c == '' || lead.infer3__Infer_Rating__c == null ||  lead.infer3__Infer_Score__c == null)
            {
                SF_Error_Log__c error = new SF_Error_Log__c();
                error.Class_Name__c ='ConvertToOpportunityController';
                error.Error_Trace__c ='Lead Infer is blank when converting Lead';
                error.Stack_Trace__c = 'NA';
                error.Error_Type__c = 'Lead Infer Score is Blank';
                error.Line_Number__c = 'NA';
                error.Method_Name__c = 'Convert Lead';
                error.Record_List__c = GetLeadId();
                error.User__c = userinfo.getuserid();
                
                insert error;
            }
                
            update newOpportunity;
            if(conversion.getaccountId()!=null){
                List<Lead>leadList = new List<Lead>();
                leadList =[select id,KA_Domain__c from Lead where id=:lead.id limit 1];
                
                if(leadList.size()>0 && leadList!=null){
                    acc.id = conversion.getAccountId();
                    if(leadList[0].KA_Domain__c!=null){ acc.KA_Domain__c = leadList[0].KA_Domain__c;acc.Type='Standard'; }
                    update acc;
                }
            }
            
            SetOpportunityCompetitors(newOpportunity, opportunityCompetitors);

            return Util.RedirectTo(GetLeadId());
        }
        catch(Exception e)
        {
            SF_Error_Log__c error = new SF_Error_Log__c();
            error.Class_Name__c ='ConvertToOpportunityController';
            error.Error_Trace__c =e.getMessage();
            error.Stack_Trace__c = e.getStackTraceString();
            error.Error_Type__c = 'Lead Convert';
            error.Line_Number__c = string.valueOf(e.getLineNumber());
            error.Method_Name__c = 'Convert Lead';
            error.Record_List__c = GetLeadId();
            error.User__c = userinfo.getuserid();
            
            insert error;
            return Util.RedirectTo(GetLeadId());
        }
    }
        
    public List <SelectOption> GetListOfCompetitors()
    {
        return Util.GetPicklistValues(new OpportunityCompetitor(), 'CompetitorName');
    }
    
    public void SetOpportunityCompetitors(Opportunity opportunity, List <String> competitors)
    {
        List <OpportunityCompetitor> opportunityCompetitors = new List <OpportunityCompetitor> ();
        for(String competitorName : competitors)
        {
            OpportunityCompetitor competitor = new OpportunityCompetitor();
            competitor.CompetitorName = competitorName;
            competitor.OpportunityId = opportunity.Id;
            opportunityCompetitors.add(competitor);
        }
        insert opportunityCompetitors;
    }
    
}