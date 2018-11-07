public class ProductUpdater {
    
    public Boolean showLead {get;set;}
    public Boolean showOpp {get;set;}
    public String ObjId;
    public String instanceid;
    public List<SelectOption> leadProductOptions{get;set;}
    public Opportunity opp {get;set;}
    public Set<String>productSet;
    public Lead l {get;set;}
    public ProductUpdater(){
            objId = ApexPages.currentPage().getParameters().get('rec');
            instanceid =  ApexPages.currentPage().getParameters().get('Id');
            leadProductOptions = new List<SelectOption>();
            productset = new Set<String>{'Enterprise','Growth','Standard','Free','Inbox','Team','Scale'};
            
            if(objId.startsWith('006')){
                List<Opportunity> oppList = [select id,name,type,product__c,plan__c,instance__r.id from opportunity where id =: objId limit 1];
                
                opp = new opportunity();
                opp.id = objId;
                opp.type = oppList[0].type;
                opp.product__c = oppList[0].product__c;
                opp.plan__c = oppList[0].plan__c;
                showOpp = true;
              
            }else if(objId.startsWith('00Q')){
                showLead = true;
                l = new lead();
                l.id =objId;
                List<Lead> leadList = [select id,ka_product__c,instance__r.id from lead where id =: objId limit 1];
                l.ka_product__c = leadlist[0].ka_product__c;
                Schema.DescribeFieldResult fieldResult = lead.ka_product__c.getDescribe();
                List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
                   for( Schema.PicklistEntry f : ple)
                   {
                      if(productSet.contains(f.getLabel())){
                      leadProductOptions.add(new SelectOption(f.getLabel(), f.getValue()));
                      }
                   }       
            }
    
         
    }
    
    public pageReference updateOpp(){
        pageReference pg = new pageReference('/apex/instancesync?id='+instanceid+'&rec='+objId);
        if(opp.type!='New Business' && opp.type!='Existing - K4 to Kayako'){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Opportunity type is not valid, allowed values are only New Business and Existing K4 to Kayako');
            ApexPages.addMessage(myMsg);
            return null;
            
        }else if(!opp.product__c.startsWith('Kayako (')){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Opportunity Product is not valid, product should start with Kayako (');
            ApexPages.addMessage(myMsg);
            return null;
        
        }else{
            update opp;
            return pg;
        }
        
        
        
        
    }
    
    public pageReference updateLead(){
        pageReference pg = new pageReference('/apex/instancesync?id='+instanceId+'&rec='+objId);
            
            update l;
            return pg;
        }
        
    public pageReference cancel(){
        pageReference pg = new PageReference('/'+objId);
        return pg;
    }    
        
        
    }