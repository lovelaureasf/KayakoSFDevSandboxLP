/*
This trigger creates a task and sends email to the lead owner whenver a new instance is linked to a lead.
*/
trigger CreateTaskOnInstanceLink on Lead (after update) {
    
    if(checkRecursive.runOnce()){ // checks if the trigger is not firing recursively 
    
        List<Task>taskList = new List<Task>(); // task list that will be inserted to create task.
        Map<String,String>mapOfIdAndName = new Map<String,String>(); // map of id and name of instance
        
        Set<String>userSet = new Set<String>();
        List<String> proIdList = new List<String>() ;
        
        for(profile p:[select id,name from profile where name='System Administrator']){
            proIdList.add(p.id);
        }
        for(user u: [select id,name from user where profileId IN:proIdList]){
            userSet.add(u.id);
        }
        
        
        
        for(lead l : Trigger.New){
            if(Trigger.NewMap.get(l.id).Instance__c!=null && Trigger.OldMap.get(l.id).Instance__c!=Trigger.NewMap.get(l.id).Instance__c && (Trigger.OldMap.get(l.id).Stage__c!='SRL' || Trigger.OldMap.get(l.id).Stage__c!='SDL') && UserInfo.getFirstName()=='Backend' && !userSet.contains(l.ownerId) ){
                     System.debug('in the loop');
                     Task t = new Task();
                     t.Subject='Check-in call. Lead just signed up for a new trial at ' +[select id,name from instance__c where id=:l.Instance__c limit 1].name;
                     t.OwnerId = l.OwnerId;
                     t.WhoId = l.id;
                     t.Priority = 'High';
                     taskList.add(t);
                     
                     if(l.KA_Product__c==null && l.KA_ProductType__c==null){
                        l.addError('Product and Product Type is not set on this lead. Please set it before linking it with any Instance.');
                     }
                 
            }
            
            
        }
        if(taskList!=null && taskList.size()>0){
            Database.DMLOptions notifyOption = new Database.DMLOptions(); //dml class reference.
            notifyOption.EmailHeader.triggerUserEmail = true; // send email when a task is created.
            System.debug('in the insert');
            Database.insert(taskList, notifyOption); // create task and send email.
        }
    }
    
}