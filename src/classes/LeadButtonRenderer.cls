public without sharing class LeadButtonRenderer extends LeadFlowButtonHandler
{
    private ApexPages.StandardController leadController;
    
    public LeadButtonRenderer(ApexPages.StandardController controller)
    {
        super(controller);
        leadController = controller;
    }

    public boolean GetCanAcceptOpenLead()
    {
        return LeadStage.MQL.equals(lead.Stage__c) && LeadStatus.OPEN.equals(lead.Status);
    }

    public boolean GetCanUpgrade()
    {
        
        List<lead>lList = new List<lead>();
        lList = [select id,name, Instance__c,Instance__r.state__c,Instance__r.Expiry_Date__c from  lead where (KA_Product__c = 'Growth' OR KA_Product__c = 'Enterprise' OR KA_Product__c= 'Standard' OR KA_Product__c = 'Loyalty' OR  KA_Product__c = 'Inbox' OR KA_Product__c = 'Free' OR KA_Product__c = 'Team' OR KA_Product__c = 'Scale') AND id =:lead.id limit 1];
        if(llist!=null && llist.size()>0 && llist[0].instance__c!=null && llist[0].Instance__r.state__c!='DELETED' && llist[0].Instance__r.Expiry_Date__c>=Date.today()-1){
            return true;
        }else{
            return false;
        }
            
        
        
         
    }

    public boolean GetCanRejectOpenLead()
    {
        return LeadStage.MQL.equals(lead.Stage__c) && LeadStatus.OPEN.equals(lead.Status);
    }

    public boolean GetCanMarkLeadContacted()
    {
        return LeadStage.SAL.equals(lead.Stage__c) && LeadStatus.OPEN.equals(lead.Status);
    }

    public boolean GetCanSetTerritory()
    {
        return LeadStage.SAL.equals(lead.Stage__c) && lead.KA_Territory__c == null;
    }

    public boolean GetCanQualifyLead()
    {
        return LeadStage.SAL.equals(lead.Stage__c) && LeadStatus.CONTACTED.equals(lead.Status);
    }

    public boolean GetCanEnrichLead()
    {
        return LeadStage.SAL.equals(lead.Stage__c) && LeadStatus.CONTACTED.equals(lead.Status);
    }

    public boolean GetCanUpdateContact()
    {
        return LeadStage.SAL.equals(lead.Stage__c) && (
            LeadStatus.OPEN.equals(lead.Status) ||
            LeadStatus.CONTACTED.equals(lead.Status) || LeadStatus.UNRESPONSIVE.equals(lead.Status)
        );
    }

    public boolean GetCanMarkLeadInterested()
    {
        Territory2 leadTerritory = null;
        
        try
        {
            leadTerritory = TerritoryDataAccess.GetLeadRegion(lead);
        }
        catch(UnderflowException noRegionByLeadCountry)
        {
            return false;
        }
        
        String userRole = TerritoryDataAccess.GetUserRole(user, leadTerritory);
        
        Boolean UserHasNoManager = user.ManagerId == null;

        if(RoleName.ADM.equals(userRole) && UserHasNoManager) return false;

        return LeadStatus.CONTACTED.equals(lead.Status) &&
                LeadStage.SAL.equals(lead.Stage__c);
    }

    public boolean GetCanMarkLeadUnresponsive()
    {
        return LeadStage.SAL.equals(lead.Stage__c) && (LeadStatus.OPEN.equals(lead.Status) || LeadStatus.CONTACTED.equals(lead.Status));
    }

    public boolean GetCanMarkLeadResponsive()
    {
        return LeadStage.SAL.equals(lead.Stage__c) && LeadStatus.UNRESPONSIVE.equals(lead.Status);
    }

    public boolean GetCanRejectAcceptedLead()
    {
        Set <String> requiredStatus = new Set <String> { LeadStatus.CONTACTED, LeadStatus.UNRESPONSIVE,LeadStatus.OPEN };
        return LeadStage.SAL.equals(lead.Stage__c) && requiredStatus.contains(lead.Status);
    }

    public boolean GetCanAcceptInterestedLead()
    {
        Territory2 leadTerritory = null;
        
        try
        {
            leadTerritory = TerritoryDataAccess.GetLeadRegion(lead);
        }
        catch(UnderflowException noRegionByLeadCountry)
        {
            return false;
        }
        
        return LeadStage.SAL.equals(lead.Stage__c) && LeadStatus.INTERESTED.equals(lead.Status) && SeniorRoles().contains(TerritoryDataAccess.GetUserRole(user, leadTerritory));
    }

    public boolean GetCanRejectInterestedLead()
    {
        Territory2 leadTerritory = null;
        
        try
        {
            leadTerritory = TerritoryDataAccess.GetLeadRegion(lead);
        }
        catch(UnderflowException noRegionByLeadCountry)
        {
            return false;
        }
        
        return LeadStage.SAL.equals(lead.Stage__c) && LeadStatus.INTERESTED.equals(lead.Status) && SeniorRoles().contains(TerritoryDataAccess.GetUserRole(user, leadTerritory));
    }

    public boolean GetCanReturnInterestedLead()
    {
        Territory2 leadTerritory = null;
        
        try
        {
            leadTerritory = TerritoryDataAccess.GetLeadRegion(lead);
        }
        catch(UnderflowException noRegionByLeadCountry)
        {
            return false;
        }

        return LeadStage.SAL.equals(lead.Stage__c) && LeadStatus.INTERESTED.equals(lead.Status) && SeniorRoles().contains(TerritoryDataAccess.GetUserRole(user, leadTerritory));
    }

    public boolean GetCanConvertToOpportunity()
    {
        Territory2 leadTerritory = null;
        
        try
        {
            leadTerritory = TerritoryDataAccess.GetLeadRegion(lead);
        }
        catch(UnderflowException noRegionByLeadCountry)
        {
            return false;
        }
        
        return (LeadStage.SQL.equals(lead.Stage__c) || LeadStage.SAL.equals(lead.Stage__c)) && (LeadStatus.QUALIFIED.equals(lead.Status)|| LeadStatus.CONTACTED.equals(lead.Status) || LeadStatus.INTERESTED.equals(lead.Status)) && SeniorRoles().contains(TerritoryDataAccess.GetUserRole(user, leadTerritory));
    }

    public boolean GetCanRejectQualifiedLead()
    {
        Territory2 leadTerritory = null;
        
        try
        {
            leadTerritory = TerritoryDataAccess.GetLeadRegion(lead);
        }
        catch(UnderflowException noRegionByLeadCountry)
        {
            return false;
        }
        
        return LeadStage.SQL.equals(lead.Stage__c) && LeadStatus.QUALIFIED.equals(lead.Status) && SeniorRoles().contains(TerritoryDataAccess.GetUserRole(user, leadTerritory));
    }
    
    public boolean GetCanCloseQualifiedLead()
    {
        Territory2 leadTerritory = null;
        
        try
        {
            leadTerritory = TerritoryDataAccess.GetLeadRegion(lead);
        }
        catch(UnderflowException noRegionByLeadCountry)
        {
            return false;
        }
        
        return LeadStage.SQL.equals(lead.Stage__c) && LeadStatus.QUALIFIED.equals(lead.Status) && SeniorRoles().contains(TerritoryDataAccess.GetUserRole(user, leadTerritory));
    }

    public boolean GetCanUpdateInstanceDetails()
    {
        return LeadStage.SAL.equals(lead.Stage__c) && (LeadStatus.CONTACTED.equals(lead.Status) || LeadStatus.INTERESTED.equals(lead.Status));
    }

    public boolean GetCanReopenLead()
    {
        return (LeadStage.SDL.equals(lead.Stage__c) || LeadStage.SRL.equals(lead.Stage__c)) && (LeadStatus.NURTURE.equals(lead.Status) || LeadStatus.DEAD.equals(lead.Status));
    }
    
    
    public boolean GetQualificationAnsweresAreInvalid()
    {
        if(String.isBlank(lead.Budgeted__c)         || lead.Budgeted__c.equals('Unanswered') || String.isBlank(lead.Role__c)          || lead.Role__c.equals('Unanswered') || String.isBlank(lead.Authority__c)     || lead.Authority__c.equals('Unanswered') || String.isBlank(lead.CurrentSystem__c) || lead.CurrentSystem__c.equals('Unanswered') || String.isBlank(lead.UsedFor__c)       || lead.UsedFor__c.equals('Unanswered') || String.isBlank(lead.Industry)         || lead.Industry.equals('Unanswered'))
        {
            return true;
        }
        
        return false;
    }


    private Set <String> SeniorRoles()
    {
        return new Set <String> { RoleName.ISM, RoleName.MNGR, RoleName.RL,RoleName.ADM };
    }
    
    public boolean GetCanConvertToContact(){
    
     if(lead.Status =='Contacted'){
         return true;
     }else{
         return false;
     
     }
    
    }
    
    public pageReference convertToContact(){
        
        PageReference pg = new PageReference('/apex/converttocontact?id='+lead.id);
        pg.setRedirect(true);
        return pg;
    }
    
    public PageReference reject(){
        PageReference pg = new PageReference('/apex/leadreject?id='+lead.id);
        pg.setRedirect(true);
        return pg;
    }
}