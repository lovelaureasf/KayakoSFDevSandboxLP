public class CreateNewLeadController
{
    public boolean error{get;set;}
    public Lead currentLead;
    Public String proPickValSelected { get; set; }
    public ApexPages.StandardController LeadController;
    
    
    public CreateNewLeadController(ApexPages.StandardController controller)
    {
        LeadController = controller;
        error =false;
    }
    
    
    public List<SelectOption> getPickLstValue() {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Lead.KA_Product__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry f : ple)
        {
                        System.debug('the value of the picval is'+f.getValue());
                        if(f.getValue() != 'Case' && f.getValue() != 'Engage' && f.getValue() != 'Fusion')
                        {
                                        options.add(new SelectOption(f.getLabel(), f.getValue()));
                        }
        } 
        return options;           
    }
    
    public void save()
    {
        error =false;
        currentLead = (Lead) LeadController.getRecord();
        currentLead.CreationStage__c = LeadStage.SAL;
        
        String phone = currentLead.Phone;
        
        if( ! phone.startsWith('+') || phone.containsWhitespace() || phone.containsAny('-()#'))
        {
            
           error = true; 
           
           
        }
        
        currentLead.FirstName = Util.SentenceCase(currentLead.FirstName);
        currentLead.LastName = Util.SentenceCase(currentLead.LastName);
        currentLead.Company = Util.SentenceCase(currentLead.Company);
        currentLead.KA_Product__c = proPickValSelected;
        
        
    }
    
    public PageReference finalSave(){
       
            return LeadController.save();
            
       
    } 
}