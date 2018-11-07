trigger OnPaymentFailureOpportunityInsert on Opportunity (before insert)
{
    List<Opportunity>opportunityToUpdate = new List<Opportunity>(); //list of opportunities that will be updated at the end of the operation (trigger).
    
    Map<String,String>countryIdWithRegionId = new Map<String,String>(); // Map of country Id with region ids 
    
    Map<String,String>countryNameWithId = new Map<String,String>(); // Map of country name with country ids
    
    Map<String,List<String>>parentTerritoryWithUsers = new Map<String,List<String>>(); // Map of parent territory with list of users in it.
    
    Map<String,User>userIdWithUser = new Map<String,User>(); // Map of userId with their respective users.
    
    List<user>usersToUpdate = new List<user>(); // This list will contain all the users which participated in assignment, in last of the operation their lead counter will be updated using this list.
    
    Map<String,Account>accountIdWithAccount = new Map<String,Account>(); //Map of account ids with account record, this will help to lookup the account (to get the country name)
    
    Set<String>userflag = new Set<String>(); //flag to check user already being used for assignment.
    
    //collect all the countries with their regions
    for(Territory2 t : [SELECT id,DeveloperName,ParentTerritory2.id, ParentTerritory2.Name, ParentTerritory2.DeveloperName FROM Territory2 where Territory2Type.DeveloperName ='Payment_Failure_Countries']){
        countryIdWithRegionId.put(t.id,t.ParentTerritory2.id);
        countryNameWithId.put(t.DeveloperName,t.id);
    }
    
    //collect all the users
    for(user u : [select id,name,KA_LeadCounter__c,KA_Weightage__c from user where isActive=true and KA_Weightage__c>0  order by KA_Weightage__c]){
        userIdWithUser.put(u.id,u);
    }
    
    
    //collect all the parent territories with users
    for(UserTerritory2Association ut : [select IsActive,RoleInTerritory2,Territory2Id,UserId from UserTerritory2Association where IsActive = true AND UserId IN: userIdWithUser.keySet()]){
        if(!parentTerritoryWithUsers.containsKey(ut.Territory2Id)){
            
            parentTerritoryWithUsers.put(ut.Territory2Id,new List<String>{ut.userId});    
    
        }else{
            parentTerritoryWithUsers.get(ut.Territory2Id).add(ut.userId);
        
        }
    
    }
    
    Set<Id> acctId = new Set<Id>();
    
    for(Opportunity o :Trigger.New){
        acctId.add(o.AccountId);
    }
    
    
    
    //collect all account with names
    for(account ac :[select id,name,billingcountrycode from account where id in : acctId]){
        accountIdWithAccount.put(ac.id,ac);
    }
    
    //operations on newly created records 
    for(Opportunity o :Trigger.New){
        
        if(o.Type == 'Payment Failure'){ // only Payment Failure opportunities will take part in this.
            
            o.Territory2Id = countryIdWithRegionId.get(countryNameWithId.get('PF_'+accountIdWithAccount.get(o.AccountId).billingCountryCode));
            System.debug('the current territory id is'+o.Territory2Id);
            opportunityToUpdate.add(o);
            System.debug('the the parent territory with users is'+parentTerritoryWithUsers);
            for(String uid : parentTerritoryWithUsers.get(o.Territory2Id)){
                
                if(userIdWithUser.get(uid).KA_Weightage__c>0){
                    
                    if((userIdWithUser.get(uid).KA_Weightage__c>userIdWithUser.get(uid).KA_LeadCounter__c) && !userflag.contains(uid)){ //if the weightage on the user record is great than the lead counter
                        
                        userIdWithUser.get(uid).KA_LeadCounter__c=userIdWithUser.get(uid).KA_LeadCounter__c+1;
                        o.OwnerId = uid;
                        userflag.add(uid);
                        usersToUpdate.add(userIdWithUser.get(uid));
                        break; 
                    
                    }else if(userIdWithUser.get(uid).KA_Weightage__c==userIdWithUser.get(uid).KA_LeadCounter__c && !userflag.contains(uid)){ //have we reached to all users count?
                         userflag.add(uid);
                         
                         //set all users lead counter to zero
                         if(userflag.size()==parentTerritoryWithUsers.get(o.Territory2Id).size()){
                             for(String su : parentTerritoryWithUsers.get(o.Territory2Id)){
                                userIdWithUser.get(su).KA_LeadCounter__c=0;
                                usersToUpdate.add(userIdWithUser.get(su));
                             }
                             usersToUpdate[0].KA_LeadCounter__c=1;
                             o.OwnerId = usersToUpdate[0].id;
                             break;
                        }
                  }  
                }
            }
             userflag.clear(); // clearing the user flag for next opportunity assignment
        }
    }
    update usersToUpdate; //update the user records.
    
}