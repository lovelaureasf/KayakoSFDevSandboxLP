/* Description: This controller is responsible to handle the incomplete values such as lead stage and status.
   This controller also sets the user(owner) values if the user on lead is inactive.

*/

public class LeadDataFillinController {
    
    public Lead l {get;set;}
    
    public Map<String,String>countryIdWithRegionId; // Map of country Id with region ids. 
    
    public Map<String,String>countryNameWithId; // Map of country name with country ids.
    
    public Map<String,String>territoryIdWithName; // Map of territory id and name.
    
    public Set<String> activeUsers; // set to collect the active users.
    
    public Map<String,User>userIdWithUser; // Map of userId with their respective users.
    
    public Map<String,List<String>>parentTerritoryWithUsers; // Map of parent territory with list of users in it.

    public Set<String>userflag; //flag to check user already being used for assignment.
    
    public Map<String,String>MapOfTerritoryAndParentTerritoryId; // Map of territory with parent territory. 
    
    public List<user>usersToUpdate; // this list will update the counter of the user to whom the lead was assigned.
    
    public Set<String>usersInTerritory; // this set will be used to check if the current user is part of the territory.
    
    public Set<String>roleIds; // this set holds the AE and SDR role IDs. Used to check if currently logged in user is AE/SDR
    
    
    
    public LeadDataFillinController(ApexPages.StandardController controller) {
        
        l = new Lead();
        
        l = [select id,name,StatusToNurtureDate__c,StageToMQLDate__c,LeadSource,LeadType__c,StageToSALDate__c,StageToSRLDate__c,Country,CountryCode,Status,Stage__c,KA_Territory__c from lead where id=:ApexPages.currentPage().getParameters().get('id')];
        
        countryIdWithRegionId = new Map<String,String>();
        
        countryNameWithId = new Map<String,String>();
        
        territoryIdWithName = new Map<String,String>();
        
        activeUsers = new Set<String>();
        
        userIdWithUser = new Map<String,User>();
        
        parentTerritoryWithUsers = new Map<String,List<String>>(); 
        
        userflag = new Set<String>(); 
        
        mapOfTerritoryAndParentTerritoryId = new Map<String,String>();
        
        usersToUpdate = new List<user>();
        
        usersInTerritory = new Set<String>();
        
        roleIds = new Set<String>();
        
            
    }
    
    
    public pageReference submit(){
                
                
                for(UserRole ur:[select id,Name from UserRole where Name like:'Account Executive%' or Name like: 'Sales Developement%' limit 50000]){
                    
                    roleIds.add(ur.Id);
                
                }
                
                System.debug('**********the role ids are'+roleids);
                
                String currentStage = l.Stage__c;
                System.debug('the current stage is'+l.Stage__c);
                System.debug('The lead is'+l);
                if(currentStage == LeadStage.SDL)
                {
                    l.Stage__c = LeadStage.SQL;
                    l.Status = LeadStatus.QUALIFIED;
                    l.StageToSDLDate__c = null;
                    l.StageToSQLDate__c = Date.today();
                    l.StatusToNurtureDate__c = null;
                }
                else if(currentStage == LeadStage.SRL)
                {
                    
                    l.Stage__c = LeadStage.SAL;
                    l.Status = LeadStatus.OPEN;
                    l.StageToMQLDate__c = Date.today();
                    l.StageToSALDate__c = Date.today();
                    l.StageToSRLDate__c = null;
                    l.StatusToNurtureDate__c = null;
                    
                 }
                 
                    
                    for(Territory2 t : [SELECT id,Territory2Type.DeveloperName,DeveloperName,ParentTerritory2.id, ParentTerritory2.Name, ParentTerritory2.DeveloperName FROM Territory2 limit 50000]){
                        countryIdWithRegionId.put(t.id,t.ParentTerritory2.id);
                        countryNameWithId.put(t.DeveloperName,t.id);
                        territoryIdWithName.put(t.id,t.DeveloperName);
                        mapOfTerritoryAndParentTerritoryId.put(t.id,t.ParentTerritory2.id);
                    }
                
                    l.KA_Territory__c = territoryIdWithName.get(countryIdWithRegionId.get(countryNameWithId.get(l.CountryCode)));
                    
                    for(user u: [select id,name,isActive from user where isActive = true AND UserRoleId IN:roleIds]){
                        activeUsers.add(u.id);
                    }
                    
                    System.debug('!!!!THE ROLEIDS'+roleIds);
                    
                    for(user u : [select id,name,KA_LeadCounter__c,KA_Weightage__c from user where isActive=true and KA_Weightage__c>0  order by KA_Weightage__c limit 50000]){
                            userIdWithUser.put(u.id,u);
                        }
                    
                        for(UserTerritory2Association ut : [select IsActive,RoleInTerritory2,Territory2Id,UserId from UserTerritory2Association where IsActive = true AND UserId IN: activeUsers limit 50000]){
                            if(!parentTerritoryWithUsers.containsKey(ut.Territory2Id)){
                                
                                parentTerritoryWithUsers.put(ut.Territory2Id,new List<String>{ut.userId});    
                        
                            }else{
                                parentTerritoryWithUsers.get(ut.Territory2Id).add(ut.userId);
                            
                            }
                        
                        }
                    
                    
                    System.debug('@@@@@the countrynamewith id'+countryNameWithId.get(l.CountryCode));
                    System.debug('@@@@@the map of terri and parent terri is'+mapOfTerritoryAndParentTerritoryId);
                    System.debug('@@@the parent territory'+mapOfTerritoryAndParentTerritoryId.get(countryNameWithId.get(l.CountryCode)));
                    System.debug('@@@@ the map of parent territory and list of user'+parentTerritoryWithUsers);
                    System.debug('@@@the list of users we got is'+parentTerritoryWithUsers.get(mapOfTerritoryAndParentTerritoryId.get(countryNameWithId.get(l.CountryCode))));
                    
                    
                    for(String uid : parentTerritoryWithUsers.get(mapOfTerritoryAndParentTerritoryId.get(countryNameWithId.get(l.CountryCode)))){
                        usersInTerritory.add(uid);
                    }
                    
                    System.debug('######users in territory are'+usersInTerritory);
                    
                    if(usersInTerritory.contains(userInfo.getUserId())){
                           System.debug('in the first clause');
                           l.OwnerId = userInfo.getUserId();
                    }else if(!activeUsers.contains(l.ownerid) && !usersInTerritory.contains(userInfo.getUserId())){
                        System.debug('in the second clause');
                        //collect all the users
                        for(user u : [select id,name,KA_LeadCounter__c,KA_Weightage__c from user where isActive=true and KA_Weightage__c>0   order by KA_Weightage__c ]){
                            userIdWithUser.put(u.id,u);
                        }
                        
                        System.debug('user id with user'+useridWithUser);
                        
                        //collect all the parent territories with users
                        for(UserTerritory2Association ut : [select IsActive,RoleInTerritory2,Territory2Id,UserId from UserTerritory2Association where IsActive = true AND UserId IN: activeUsers]){
                            if(!parentTerritoryWithUsers.containsKey(ut.Territory2Id)){
                                
                                parentTerritoryWithUsers.put(ut.Territory2Id,new List<String>{ut.userId});    
                        
                            }else{
                                parentTerritoryWithUsers.get(ut.Territory2Id).add(ut.userId);
                            
                            }
                        
                        }
                        System.debug('countryNameWithId'+countryNameWithId);
                        System.debug('the current country is'+l.CountryCode);
                        System.debug('The parent territory with users'+parentterritoryWithUsers);
                        System.debug('The country id is'+countryNameWithId.get(l.CountryCode));
                        System.debug('The list of the parent territory and users is'+parentTerritoryWithUsers.get(mapOfTerritoryAndParentTerritoryId.get(countryNameWithId.get(l.CountryCode))));
           for(String uid : parentTerritoryWithUsers.get(mapOfTerritoryAndParentTerritoryId.get(countryNameWithId.get(l.CountryCode)))){
                System.debug('@@@@@in the looop');
                if(userIdWithUser.keySet().contains(uid)){
                if(userIdWithUser.get(uid).KA_Weightage__c>0){
                    
                    if((userIdWithUser.get(uid).KA_Weightage__c>userIdWithUser.get(uid).KA_LeadCounter__c) && !userflag.contains(uid)){ //if the weightage on the user record is great than the lead counter
                        
                        userIdWithUser.get(uid).KA_LeadCounter__c=userIdWithUser.get(uid).KA_LeadCounter__c+1;
                        l.OwnerId = uid;
                        userflag.add(uid);
                        usersToUpdate.add(userIdWithUser.get(uid));
                        break; 
                    
                    }else if(userIdWithUser.get(uid).KA_Weightage__c==userIdWithUser.get(uid).KA_LeadCounter__c && !userflag.contains(uid)){ //have we reached to all users count?
                         userflag.add(uid);
                         
                         //set all users lead counter to zero
                         if(userflag.size()==parentTerritoryWithUsers.get(countryNameWithId.get(l.KA_Territory__c)).size()){
                             for(String su : parentTerritoryWithUsers.get(countryNameWithId.get(l.KA_Territory__c))){
                                userIdWithUser.get(su).KA_LeadCounter__c=0;
                                usersToUpdate.add(userIdWithUser.get(su));
                             }
                             usersToUpdate[0].KA_LeadCounter__c=1;
                             l.OwnerId = usersToUpdate[0].id;
                             break;
                        }
                  }  
                
                }
                
                }
            }
                
           }    
                
           
        
                
                
               
                
                
                update l;
                
                PageReference pg = new PageReference('/'+l.id);
                pg.setRedirect(true);
                return pg;
    
    
    }

}