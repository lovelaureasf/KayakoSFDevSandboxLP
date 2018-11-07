/*
Created By : Sagar Pareek
Description: This trigger check if the opportunity (newly created) /New Business/Term Change/Expansion owner matches the billing account sales rep else throw an error
If the AE is not active in that case if updates it with opportunity's owner (AE).
*/

trigger CheckSalesRepOnCreate on Opportunity (before insert) { //on insert of the opportunity
    
    Map<String,String>MapOfOppIdWithRep = new Map<String,String>(); // map of opp with owner
    Map<String,String>MapOfOppIdWithAccountId = new Map<String,String>(); // map of opp with account id
    Set<String>AccountIds = new Set<String>(); // set of account ids
    Map<String,String>MapOfBAccountWithRepName = new Map<String,String>(); // map of billing accounts with rep name
    Map<String,String>MapOfActiveUserIdWithUserName = new Map<String,String>(); // map of user ids with user names (active)
    Map<String,String>MapOfActiveUserNameWithUserId = new Map<String,String>(); // map of username with userids (active)
    Map<String,String>MapOfInActiveUserIdWithUserName = new Map<String,String>(); // map of user ids with user names (inactive)
    Map<String,String>MapOfInActiveUserNameWithUserId = new Map<String,String>(); // map of username with userids (inactive)
    Map<String,String>MapOfAccIdWithOppId = new Map<String,String>(); // map of account ids to opp ids.
    List<Zuora__CustomerAccount__c>billingAccountList = new List<Zuora__CustomerAccount__c>(); // list of the billing accounts
    
    for(user u : [select id,name,isActive from user]){ //collecting all the active users and inactive users.
        if(u.isActive){
            MapOfActiveUserIdWithUserName.put(u.id,u.name);
            MapOfActiveUserNameWithUserId.put(u.Name,u.id);
        }
        else{
            MapOfInActiveUserIdWithUserName.put(u.id,u.name);
            MapOfInActiveUserNameWithUserId.put(u.Name,u.id);
        }
    }
    
    for(opportunity o: Trigger.New){ //iterating over the incoming opp
        
        if(o.Type=='New Business' || o.Type.contains('Term') || o.Type.contains('Expansion')){ // only applicable on term change/new business and expansion
            MapOfOppIdWithRep.put(o.id,o.ownerId);
            MapOfOppIdWithAccountId.put(o.id,o.accountId);
            MapOfAccIdWithOppId.put(o.accountId,o.id);
            AccountIds.add(o.accountid);
        }    
        
    }
    
    if(AccountIds!=null && AccountIds.size()>0){ //iterating on the billing accounts now
        for(Zuora__CustomerAccount__c zca:[select id,Zuora__Account__c, Zuora__SalesRepName__c from Zuora__CustomerAccount__c where Zuora__Account__c IN:AccountIds ]){
                if(MapOfActiveUserNameWithUserId.keySet().contains(zca.Zuora__SalesRepName__c)){
                    MapOfBAccountWithRepName.put(zca.Zuora__Account__c,zca.Zuora__SalesRepName__c );
                }
                else if(MapOfInActiveUserNameWithUserId.keySet().contains(zca.Zuora__SalesRepName__c) || zca.Zuora__SalesRepName__c==null){ // in case the sales rep field is blank or it holds inactive user 
                    zca.Zuora__SalesRepName__c = MapOfActiveUserIdWithUserName.get(MapOfOppIdWithRep.get(MapOfAccIdWithOppId.get(zca.Zuora__Account__c)));
                    billingAccountList.add(zca);
                }
        }
        
        for(opportunity o : Trigger.New){
        if(o.Type=='New Business' || o.Type.contains('Term') || o.Type.contains('Expansion')){
            if(MapOfBAccountWithRepName.get(o.accountId)!=null){
                if(MapOfBAccountWithRepName.get(o.accountId)!=MapOfActiveUserIdWithUserName.get(o.OwnerId)){
                    o.addError('Owner of Opportunity is not same as of Billing Account');
                }
            }
        }
        }        
    
    }
    
}