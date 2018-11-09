trigger CopyEmailtoUniqueEmail on Lead (before insert,before update) {
    try{
        for(lead l :Trigger.New){
            l.UniqueEmail__c = l.Email;
        }
    }catch(Exception e){
        SF_LogError.logError(e);
    }
}