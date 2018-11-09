trigger GenerateToken on Account (before insert,before update) {
    for(account a: Trigger.New){
            a.SecurityToken__c = RandomString.generateRandomString(254) ;
    }
}