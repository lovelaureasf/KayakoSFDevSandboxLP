/*
Created By : Sagar Pareek
Description: Whenever a New Business opportunity is marked as closed won, this trigger will update the billing account sales rep field.
*/

trigger UpdateSalesRepOnBillingAccount on Opportunity (after update) { // run on update
    
    Map<String,String>MapOfAccountWithSalesRep = new Map<String,String>(); //map of accounts with sales rep on incoming opportunity
    Map<String,String>MapOfUserIdAndActiveUserName = new Map<String,String>(); // map of userid and username (active users)
    Map<String,String>MapOfUserIdAndInActiveUserName = new Map<String,String>(); // map of userid and username (inactive users)
    List<Zuora__CustomerAccount__c>billingAccountList = new List<Zuora__CustomerAccount__c>(); // this is the list of billing account which will be used to update the billing accounts
    
    for(opportunity o : Trigger.New){ // iterating over the incoming opportunity
        
        if(o.Type == 'New Business' && o.StageName=='Closed Won'){ // if it is new business and closed won
            
            if(!MapOfAccountWithSalesRep.containsKey(o.accountid)){ //check if there is no existing entry
                
                MapOfAccountWithSalesRep.put(o.accountid,o.ownerid);    //putting the data
            
            }
        
        }
    
    }
    
    for(user u : [select id,name,isActive from user where isActive=true limit 200]){ //querying on the users and putting them in active and inactive maps
        if(u.isActive){
            MapofUserIdAndActiveUserName.put(u.id,u.name);
        }else{
            MapofUserIdAndInActiveUserName.put(u.id,u.name);
        }
    }
    
    
    
    if(MapOfAccountWithSalesRep!=null){ // if the map of account with sales rep is not null
            
            for(Zuora__CustomerAccount__c zca : [select id,Zuora__SalesRepName__c,Zuora__Account__c from Zuora__CustomerAccount__c where Zuora__Account__c IN:MapOfAccountWithSalesRep.keySet()]){ //querying on the billing accounts
                
               
                zca.Zuora__SalesRepName__c = MapOfUserIdAndActiveUserName.get(MapOfAccountWithSalesRep.get(zca.Zuora__Account__c)); //copying the names in sales rep field
                
                billingAccountList.add(zca); // adding the instance of the billing account in the list which will be updated.
            }
       }
    
    if(billingAccountList!=null && billingAccountList.size()>0){
        
        update billingAccountList; //updating the billing account list.
    
    }
}