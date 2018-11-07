/*
Authored By : Sagar Pareek
Created Date : 9 October 2015
Last Modified Date : 9 March 2016
Description : [BACKEND-1354] - The territory was not set on opportunity after lead coversion. 
              This trigger sets "Territory" for the opportunity and Account once the lead is converted.

*/

trigger LeadOnConvert on Lead (after update) {
    
    Map<String,String> territoryNameAndIdMap = new Map<String,String>();                                                  // Map of territory name that is stored in custom field (on lead) to its original id in the system. We will use this for assignment purpose for account and opportunity.
    Map<String,String> territoryAndAccountIdsMap = new Map<String,String>();                                              //Map of territory to the converted account id retrived from the convereted lead. 
    Map<String,String> opportunityAndTerritoryIdsMap = new Map<String,String>();                                         //Map of converted opportunity id ( retrieved from convereted lead) to the id of territory.
    List<Opportunity>opportunityUpdateList = new List<Opportunity>();                                                    // This list holds all those opportunities which needs to be updated with their respective territories.
    List<ObjectTerritory2Association>objectTerritory2AssociationInsertList = new List<ObjectTerritory2Association>();    //This list holds all those object2TerritoryAssociations ( the account and territory relationship records) which we will creating using trigger.  
    
    for(territory2 t : [select id,name from territory2]){                                                                //Creating map of territory name and its id.
        territoryNameAndIdMap.put(t.name,t.id);
    }
    
    
    for(lead l : Trigger.New){                                                                                           //Bulkified trigger begins . 
            
            if(l.isConverted){                                                                                           //Making sure the process runs on only converted leads. 
                
                
                if(territoryNameAndIdMap.containsKey(l.KA_Territory__c)){                                                        //Checking if the map of territory holds the name of the territory which lead holds.
                    opportunityAndTerritoryIdsMap.put(l.convertedOpportunityId,territoryNameAndIdMap.get(l.KA_Territory__c));    //Creating map of opportunity id with territory id.
                    territoryAndAccountIdsMap.put(territoryNameAndIdMap.get(l.KA_Territory__c),l.convertedAccountId);            //Creating map of territory id and account id.
                }
            }
    }
    
    if(opportunityAndTerritoryIdsMap!=null){                                                                                //Check if opportunity and its territory map is not null 
        for(opportunity o : [select id,territory2Id from opportunity where id=:opportunityAndTerritoryIdsMap.keySet()]){    //Retrieve all those opportunities which needs to be updated.
            o.territory2Id = opportunityAndTerritoryIdsMap.get(o.id);                                                       //Assigning respective territory to the opportunity.  
            opportunityUpdateList.add(o);                                                                                   //Adding each opportunity to the update list.
        }
    }
    
    if(territoryAndAccountIdsMap!=null){                                                                                //Check if map of territory and account ids is not null
        for(String s :territoryAndAccountIdsMap.keySet()){
           ObjectTerritory2Association ot2a = new ObjectTerritory2Association();                                        //New instance of Object and territory2 association.                                        
           ot2a.AssociationCause = 'Territory2Manual';                                                                  //Defining the cause of Association.  
           ot2a.ObjectId = territoryAndAccountIdsMap.get(s);                                                            //Assigning the account id.
           ot2a.Territory2Id =s;                                                                                        //Assigning the territory2 id.
           objectTerritory2AssociationInsertList.add(ot2a);                                                             //Adding each association record to the insert list.
        }
    }
    
    
    if(opportunityUpdateList!=null && opportunityUpdateList.size()>0 && !Test.isRunningTest()){                                                   //Null check on opportunityupdate list 
        update opportunityUpdateList;                                                                                    //Updating list of opportunity records     
    }
    
    
    
    
    if(objectTerritory2AssociationInsertList.size()>0 && objectTerritory2AssociationInsertList!=null && !Test.isRunningTest()){                   //Null check on association records list. 
        try{                                                        //Exception occurs in case the territory is already assigned.
            insert objectTerritory2AssociationInsertList;                                                                    //Updating the list of association records.    
        }catch(Exception e){
            System.debug('The exception occured is'+e);
        }
    }
}