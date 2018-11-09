public class convertToContact {
    public contact c {get;set;}
    public String selectedAccountOption{get;set;}
    public AccountContactRole acr {get;set;}
    public convertToContact(){
        selectedAccountOption = 'Existing Account';
        c = new contact();
        acr = new AccountContactRole();
        acr.role = null;
    }
    
    public pageReference convert(){
        
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(ApexPages.currentPage().getParameters().get('id'));
        lc.setDoNotCreateOpportunity(true);
        lc.setConvertedStatus(LeadStatus.CONVERTED);
        if(selectedAccountOption =='Existing Account'){
            lc.setAccountId(c.accountId);
        }
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        if(acr.Role!=null){
            acr.AccountId = lcr.getAccountId();
            acr.ContactId = lcr.getContactId();
            insert acr;
        }
        PageReference pg = new PageReference('/'+lcr.getContactId());
        pg.setRedirect(true);
        return pg;
    }

}