public class ManualOpportunityCreator {
    public opportunity opportunity{get;set;} //this instance will be access on the page.
    public String territoryId{get;set;} //this will store the territory2Id selected by the user
    public String ownerShipId {get;set;} // this will store the owner id for the ownership.
    public Boolean csOrRegionLeader{get;set;}
    public String currentRoleName;
    
    public List<SelectOption> getlistofTerritories() {
        List<SelectOption> option = new List<SelectOption>();
        for(territory2 t : [select id,name from territory2 where parentTerritory2Id=null AND name!='Renewals Territory Model']){
            
            option.add(new SelectOption(t.id,t.name));
        }
        for(territory2 t : [select id,name from territory2 where name like:'Renewals: %' AND name!='Renewals Territory Model']){
            
            option.add(new SelectOption(t.id,t.name));
        }
        return option;
    }
    
    public List<SelectOption> getlistofCSMUsers() {
        List<SelectOption> option = new List<SelectOption>();
        List<UserRole> csmRoleId = [select id from userRole where name='Account Executive Europe' OR name='Account Executive Americas'];
        
        if(currentRoleName=='Customer Service' || currentRoleName=='Region Leader Americas' || currentRoleName=='Region Leader Europe' || currentRoleName=='Sales Development Representative' ){
                
                for(user u : [select id,name from user where isActive=true AND UserRoleId IN : csmRoleId]){
            
                option.add(new SelectOption(u.id,u.name));
                
            }
            return option;
        }else{
            return null;  
        }
        
          
    }
    //constructor 
    public ManualOpportunityCreator(ApexPages.StandardController controller) {
        opportunity = new opportunity();
        currentRoleName = [select id,name from userRole where id=:UserInfo.getUserRoleId()][0].name;
        if(currentRoleName=='Customer Service' || currentRoleName=='Region Leader Americas' || currentRoleName=='Region Leader Europe' || currentRoleName=='Sales Development Representative' ){
            csOrRegionLeader = true;
        }else{
            csOrRegionLeader = false;
        }
    }
    
    //overriding the standard save method.
    public pageReference save() {
        //set the stageName as Value Proposition
        opportunity.StageName='Value Proposition';
        opportunity.territory2Id = territoryId;
        if(csOrRegionLeader) {
            opportunity.OwnerId = ownerShipId;
        }
        if(opportunity.Type=='Term Change') {
            opportunity.Amount = 0;
        }
        insert opportunity;
        //after insert of the opportunity the page is redirect to the newly created opportunity detial page.
        PageReference pg = new PageReference('/'+opportunity.id);
        pg.setRedirect(true);
        return pg;
    }

}