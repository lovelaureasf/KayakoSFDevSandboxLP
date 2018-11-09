public without sharing abstract class LeadFlowButtonHandler
{
    ApexPages.StandardController LeadController;
        
    protected Lead lead;

    protected User user;
    
    public lead lead2 {get;set;}
    
    public LeadFlowButtonHandler(ApexPages.StandardController controller)
    {
        LeadController = controller;
        lead = LeadDataAccess.getLeadById(getLeadId());
        user = UserDataAccess.GetCurrentUser();
        lead2 = new lead();
    }

    protected Id GetLeadId()
    {
        return ApexPages.currentPage().getParameters().get('id');
    }

    
    public PageReference upgrade()
    {
       
       List<lead>lList = new List<lead>();
       lList = [select id,name, Instance__c,Instance__r.id,Instance__r.Expiry_Date__c from lead where (KA_Product__c = 'Growth' OR KA_Product__c = 'Enterprise' OR KA_Product__c= 'Standard' OR KA_Product__c = 'Loyalty' OR  KA_Product__c = 'Inbox' OR KA_Product__c = 'Free' OR KA_Product__c = 'Team' OR KA_Product__c = 'Scale') AND id =:lead.id limit 1];
       PageReference pg = new PageReference('/apex/productupdater?id='+llist[0].Instance__r.id+'&rec='+lead.id);
       pg.setRedirect(true);
       return pg; 

       
    }
    
    
    
    public PageReference AcceptOpenLead()
    {
        lead.Stage__c = LeadStage.SAL;
        lead.StageToSALDate__c = Date.today();
        lead.StageLastUpdatedDate__c = Date.today();
        system.debug('@@@ in accept');
        if(lead.OwnerId == null)
        {
            lead.OwnerId = user.Id;
        }
        
        try
        {
            update lead;
            return Util.RedirectTo(GetLeadId());
        }
        catch(Exception ex){
            system.debug('@@@@ inside catch');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR, ex.getdmlMessage(0)));

            return null;
        }
        
                
    }

    public PageReference RejectOpenLead()
    {
        lead.Stage__c = LeadStage.SRL;
        lead.Status = LeadStatus.NURTURE;
        lead.StageLastUpdatedDate__c = Date.today();
        lead.StageToSRLDate__c = Date.today();
        lead.StatusLastUpdatedDate__c = Date.today();
        lead.StatusToNurtureDate__c = Date.today();
        lead.Factors__c = lead2.Factors__c;
        lead.Comments__c = lead2.Comments__c;
        update lead;

        return Util.RedirectTo(GetLeadId());
    }

    public PageReference MarkLeadContacted()
    {
        lead.Status = LeadStatus.CONTACTED;
        lead.StatusToContactedDate__c = Date.today();
        lead.StatusLastUpdatedDate__c = Date.today();

        update lead;

        return Util.RedirectTo(GetLeadId());
        
       /*     Territory2 leadTerritory = TerritoryDataAccess.GetLeadRegion(lead);
        String role = TerritoryDataAccess.GetUserRole(user, leadTerritory);

        Id currentOwner = lead.OwnerId;
        
        // If user is an ADM and does not have a Manager, we cannot assign the lead to
        // anybody. In this case just show them an error so that they can talk to the
        // person responsible for assigning the manager to ADM.
        if(role.equals(RoleName.ADM))
        {
            if(user.ManagerId == null)
            {
                lead.addError('You do not have a manager assigned to handle interested leads, therefor the lead cannot be marked as interested.');
                return Util.RedirectTo(GetLeadId());
            }

            lead.OwnerId = user.ManagerId;
        }

        lead.PreviousOwner__c = currentOwner;
        
        //lead.StatusToInterestedDate__c = Date.today();
        
        lead.StatusToContactedDate__c = Date.today();
        lead.StatusLastUpdatedDate__c = Date.today();
        lead.Status = LeadStatus.CONTACTED;

        update lead;

        return Util.RedirectTo(GetLeadId());
        
        */
        
        
    }

    public PageReference MarkLeadInterested()
    {
        Territory2 leadTerritory = TerritoryDataAccess.GetLeadRegion(lead);
        String role = TerritoryDataAccess.GetUserRole(user, leadTerritory);

        Id currentOwner = lead.OwnerId;
        
        // If user is an ADM and does not have a Manager, we cannot assign the lead to
        // anybody. In this case just show them an error so that they can talk to the
        // person responsible for assigning the manager to ADM.
        if(role.equals(RoleName.ADM))
        {
            if(user.ManagerId == null)
            {
                lead.addError('You do not have a manager assigned to handle interested leads, therefor the lead cannot be marked as interested.');
                return Util.RedirectTo(GetLeadId());
            }

            lead.OwnerId = user.ManagerId;
        }

        lead.PreviousOwner__c = currentOwner;
        
        lead.StatusToInterestedDate__c = Date.today();
        lead.StatusLastUpdatedDate__c = Date.today();
        lead.Status = LeadStatus.INTERESTED;

        update lead;

        return Util.RedirectTo(GetLeadId());
    }

    public PageReference MarkLeadUnresponsive()
    {
        lead.Status = LeadStatus.UNRESPONSIVE;
        lead.StatusLastUpdatedDate__c = Date.today();
        lead.StatusToUnresponsiveDate__c = Date.today();

        update lead;

        return Util.RedirectTo(GetLeadId());
    }

    public PageReference MarkLeadResponsive()
    {
        lead.Status = LeadStatus.CONTACTED;
        lead.StatusLastUpdatedDate__c = Date.today();
        lead.StatusToContactedDate__c = Date.today();

        update lead;

        return Util.RedirectTo(GetLeadId());
    }

    public PageReference RejectAcceptedLead()
    {
        lead.Status = LeadStatus.NURTURE;
        lead.Stage__c = LeadStage.SRL;
        lead.StageLastUpdatedDate__c = Date.today();
        lead.StageToSRLDate__c = Date.today();
        lead.StatusLastUpdatedDate__c = Date.today();
        lead.StatusToNurtureDate__c = Date.today();
        lead.Factors__c = lead2.Factors__c;
        lead.Comments__c = lead2.Comments__c;
        update lead;

        return Util.RedirectTo(GetLeadId());
    }

    public PageReference AcceptInterestedLead()
    {
        lead.Status = LeadStatus.QUALIFIED;
        lead.Stage__c = LeadStage.SQL;
        lead.StatusToQualifiedDate__c = Date.today();
        lead.StatusLastUpdatedDate__c = Date.today();

        update lead;

        return Util.RedirectTo(GetLeadId());
    }

    public PageReference RejectInterestedLead()
    {
        lead.Status = LeadStatus.NURTURE;
        lead.Stage__c = LeadStage.SDL;
        lead.StageToSDLDate__c = Date.today();
        lead.StatusToNurtureDate__c = Date.today();
        lead.StatusLastUpdatedDate__c = Date.today();
        lead.Factors__c = lead2.Factors__c;
        lead.Comments__c = lead2.Comments__c;
        update lead;

        return Util.RedirectTo(GetLeadId());
    }

    public PageReference ReturnInterestedLead()
    {
        lead.Status = LeadStatus.CONTACTED;
        lead.Stage__c = LeadStage.SAL;
        lead.StatusToContactedDate__c = Date.today();
        lead.StatusLastUpdatedDate__c = Date.today();
        
        Id previousOwner = lead.PreviousOwner__c;
        lead.PreviousOwner__c = lead.OwnerId;
        lead.OwnerId = previousOwner;
        
        update lead;

        return Util.RedirectTo(GetLeadId());
    }

    public PageReference RejectQualifiedLead()
    {
        lead.Status = LeadStatus.NURTURE;
        lead.Stage__c = LeadStage.SDL;
        lead.StageToSDLDate__c = Date.today();
        lead.StatusToNurtureDate__c = Date.today();
        lead.StatusLastUpdatedDate__c = Date.today();
        lead.Factors__c = lead2.Factors__c;
        lead.Comments__c = lead2.Comments__c;
        update lead;

        return Util.RedirectTo(GetLeadId());
    }
    
    public PageReference CloseQualifiedLead()
    {
        lead.Stage__c = LeadStage.SDL;
        lead.Status = LeadStatus.DEAD;
        lead.StatusLastUpdatedDate__c = Date.today();
        lead.StageToSDLDate__c = Date.today();
        
        update lead;
        
        return Util.RedirectTo(GetLeadId());
    }
    
    public PageReference ReopenLead()
    {
        if(lead.country=='' || lead.country==null || lead.LeadSource==null || lead.LeadSource==null || lead.LeadType__c =='' || lead.LeadType__c == null){
            
            PageReference pg = new PageReference('/apex/leaddatafillin?id='+lead.id);
            pg.setRedirect(true);
            return pg;
            
        }
        
        else{
            
                String currentStage = lead.Stage__c;
                
                if(currentStage == LeadStage.SDL)
                {
                    lead.Stage__c = LeadStage.SQL;
                    lead.Status = LeadStatus.QUALIFIED;
                    lead.StageToSDLDate__c = null;
                    lead.StageToSQLDate__c = Date.today();
                    lead.StatusToNurtureDate__c = null;
                }
                else if(currentStage == LeadStage.SRL)
                {
                    lead.Stage__c = LeadStage.SAL;
                    lead.Status = LeadStatus.OPEN;
                    lead.StageToMQLDate__c = Date.today();
                    lead.StageToSALDate__c = Date.today();
                    lead.StageToSRLDate__c = null;
                    lead.StatusToNurtureDate__c = null;
                }
                
                update lead;
                
                return Util.RedirectTo(GetLeadId());
                
            }
    }
    
    public PageReference cancel(){
        PageReference pg = new PageReference('/'+lead.id);
        pg.setRedirect(true);
        return pg;
    }
}