trigger OpportunityTerritoryAssignment on Opportunity (before insert,before update)
{
    List<Opportunity>opportunityToUpdate = new List<Opportunity>(); //list of opportunities that will be updated at the end of the operation (trigger).
    
    Map<String,String>countryIdWithRegionId = new Map<String,String>(); // Map of country Id with region ids 
    
    Map<String,String>countryNameWithId = new Map<String,String>(); // Map of country name with country ids
    
    Map<String,Account>accountIdWithAccount = new Map<String,Account>(); //Map of account ids with account record, this will help to lookup the account (to get the country name)
    
    Set<String>countryName = new Set<String>();
    
    Set<String>accountIds = new Set<String>();
    
    
    for(Opportunity o: Trigger.New){
        if(o.Accountid!=null){
            accountIds.add(o.AccountId);
        }
    }
    
    //collect all account with names
    
    
    
    for(account ac :[select id,name,billingcountrycode from account where Id IN:accountIds]){
        accountIdWithAccount.put(ac.id,ac);
    }
    
    
    for(Opportunity o :Trigger.New){
        
        if(o.Type != 'Perpetual Renewal' && o.Type != 'Payment Failure'){
          if(o.AccountId!=null){  
            countryName.add(accountIdWithAccount.get(o.AccountId).billingCountryCode);
          }  
        }
    }    
    
    
    
    for(Territory2 t : [SELECT id,Territory2Type.DeveloperName,DeveloperName,ParentTerritory2.id, ParentTerritory2.Name, ParentTerritory2.DeveloperName FROM Territory2 where Territory2Type.DeveloperName ='Sales_Countries' AND (ParentTerritory2.DeveloperName = 'Europe' OR ParentTerritory2.DeveloperName = 'Middle_East_Asia' OR ParentTerritory2.DeveloperName = 'APAC' OR ParentTerritory2.DeveloperName = 'Americas' OR ParentTerritory2.DeveloperName = 'Oceania') AND DeveloperName IN:countryName]){
        countryIdWithRegionId.put(t.id,t.ParentTerritory2.id);
        countryNameWithId.put(t.DeveloperName,t.id);
    }
    
    //operations on newly created records that are perpetual or payment failure and needs to assigned to renewals.
    for(Opportunity o :Trigger.New){
        
        if(o.Type != 'Perpetual Renewal' && o.Type != 'Payment Failure'){ // only opportunities other than Perpetual Renewal and Payment Failure will take part in this.
            if(o.AccountId!=null){
                o.Territory2Id = countryIdWithRegionId.get(countryNameWithId.get(accountIdWithAccount.get(o.AccountId).billingCountryCode));
                
                opportunityToUpdate.add(o);
            }
            
        }
    }
   
    
}