//******************************************************************
// Name: LeadTriggerHandler
// Purpose: This Class is being Used to write the business logic for various event on Lead
// Author: Gaurav Agarwal
// Date: 24/08/2018 
//******************************************************************
public class LeadTriggerHandler
{
    public static Set<Id> ownerlistids = new Set<Id>(); 
    public static map<id,String> userEmail = new map<id, String>();
   
    public static void handleBeforeInsert(List<Lead> leadnewList, Map<id, Lead> leadoldmap)
    {
        
        List<User> usrList = [Select id, name from User where Name Like '%Hamzah%' limit 1];
        if(usrList.size() >0)
        {
            for(Lead ld: leadnewList)
            {
                if(ld.LeadSource =='Demo Request' || ld.LeadSource =='Kayako Demo')
                {
                    if(ld.CountryName__c != null && ld.CountryName__c !='')
                      ld.Country = ld.CountryName__c;
                }
                         
            }
        }
        //updateTrialEpiryDate(leadnewList, true);
        
    }
    
    public static void handleAfterInsert(List<Lead> leadnewList, Map<id, Lead> leadoldmap)
    {
        
        
        
    }
    
    public static void handleBeforeUpdate(List<Lead> leadnewList, Map<id, Lead> leadoldmap)
    {
        
    }
    
    public static void handleAfterUpdate(List<Lead> leadnewList, Map<id, Lead> leadoldmap)
    {
        
        try{
            Set<Id> leadidList = new Set<Id>();
            List<Lead> slaBreachedLead = new List<Lead>();
            for(Lead ld: leadnewList)
            {
                leadidList.add(ld.id); 
            }
            List<Lead> ldList = [Select id,Assigned_SDR__c,Assigned_SDR__r.id,ownerid ,Status,SDR_First_Modified_Date_Time__c,IsResponded__c,SLA_Breached__c,Reassigned_To__c,LeadSource,createdById from lead where id in : leadidList ];
            List<Lead> leadtoUpdate = new List<Lead>();
            Map<Id,Lead> demoLeadUpdate = new Map<Id,Lead>();
            
            for(Lead ld: ldList)
            {
                System.debug('@@ Demo Lead operation');
                if(ld.LeadSource == 'Demo Request' && ld.ownerid =='00510000003Kv6B' && ld.Assigned_SDR__c != null && ld.IsResponded__c == false)
                {
                    system.debug('@@@ ideal SDR owner should be :: ' + ld.Assigned_SDR__c);
                    ld.ownerid= ld.Assigned_SDR__c;
                    demoLeadUpdate.put(ld.id,ld);
                }               
            }
            
            if(demoLeadUpdate.size()>0)
            {
                system.debug('@@@@ new updated lead map');
                system.debug(demoLeadUpdate.values());
                update demoLeadUpdate.values();
            }
            
            for(Lead ld: ldList)
            {
                if(ld.Assigned_SDR__c != null  && ld.Status != leadoldmap.get(ld.id).status)
                {
                    if(ld.IsResponded__c == false)
                    {
                        ld.SDR_First_Modified_Date_Time__c = System.now();
                        ld.IsResponded__c = true;
                    }
                    leadtoUpdate.add(ld);
                }
                
                if(ld.SLA_Breached__c == true && leadoldmap.get(ld.id).SLA_Breached__c== false)
                {
                    System.debug('@@@ Lead change' + ld.id + '  @@@ new sla' + ld.SLA_Breached__c + ' @@@ old SLA ' + leadoldmap.get(ld.id).SLA_Breached__c);
                    slaBreachedLead.add(ld);
                }
            }
            if(leadtoUpdate.size()>0)
                update leadtoUpdate ;
            if(slaBreachedLead.size()>0 && checkRecursive.runOnce())
                leadAssignment(slaBreachedLead,'Update');
        }
        catch(Exception e)
        {
            SF_Error_Log__c error = new SF_Error_Log__c();
            error.Class_Name__c ='LeadTriggerHandler';
            error.Error_Trace__c =e.getMessage();
            error.Stack_Trace__c = e.getStackTraceString();
            error.Error_Type__c = 'Lead Update';
            error.Line_Number__c = string.valueOf(e.getLineNumber());
            error.Method_Name__c = 'handleAfterUpdate';
            error.Record_List__c = String.valueOf(leadnewList);
            error.User__c = userinfo.getuserid();
            
            insert error;
        }   
        /*
        List<Lead> leadToReassign = new List<Lead>();
        
        // Check if owner has been changed on Lead then pull email for previous and new owner
        for(Lead ld: leadnewList)
        {
                       
            if(ld.OwnerId != leadoldmap.get(ld.id).OwnerId)
            {
                ownerlistids.add(ld.OwnerId);
                ownerlistids.add(leadoldmap.get(ld.id).OwnerId);
            }
        }
        
       
        for(User usr: [select id, email from user where id IN:ownerlistids])
        {
            userEmail.put(usr.id,usr.email); 
        }
        for(Lead ld: leadnewList)
        {
            if(ld.OwnerId != leadoldmap.get(ld.id).OwnerId)
            {
                // If Owner has been changed then call method to send email notification.
                //sendNotifcation(ld.id,ld.OwnerId, leadoldmap.get(ld.id).OwnerId);
            }
        }
        */
    }
    /*
    public static void sendNotifcation(String leadid,String newOwner, String OldOwner)
    {
     
        String Recordlink = URL.getSalesforceBaseUrl().toExternalForm()+'/'+leadid;

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.toAddresses = new String[] { userEmail.get(newOwner), userEmail.get(OldOwner) };
        mail.subject = 'Lead Owner Changed';
        String messageBody = '<html><body>Hi, A Lead has been reassigned to a new owner. Click the link below to view the record in Salesforce.  &nbsp;&nbsp;&nbsp; <a href="' + Recordlink + '"> Record link </a></body>  </html>';
        mail.setHtmlBody(messageBody); 
        List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
        allmsg.add(mail);
        System.debug('@@@ mail details');
        System.debug(mail);
        try{    
            Messaging.sendEmail(allmsg,false);
           }
           catch(exception e)
           {
               system.debug('@@@ error' + e.getMessage());
           }

    }
    */
    // This method is being used for assigning lead based on ther shift and round robin
    public static void leadAssignment(List<Lead> leadnewList,String event)
    {
        try{
            system.debug('@@@ Lead assignment started');
            List<Shift_Plan__c> shiftPlanList= new List<Shift_Plan__c>();
            List<User> sdrList = new List<User>();
            Map<String,List<User>> shiftuserByCounter = new Map<String,List<User>>();
            List<Lead> ldlist = new List<Lead>();
            Set<Id> ldlistId = new Set<Id>();
            Map<String,List<Lead>> leadbyShift = new Map<String,List<Lead>>();
            List<Lead> leadtoUpdate = new List<Lead>();
            Map<id,User> UsertoUpdate = new Map<id,User>();
            Map<id,Lead> leadtoUpdateMap = new Map<id,Lead>();
            Set<Id> creatorIdSet = new Set<Id>();
            Map<Id,User> nonAdminUsersMap = new Map<Id,User>();
            
            //Fetch all the avilable shift in system
            shiftPlanList = [Select id, Shift_Name__c, Start_Time__c, End_Time__c from Shift_Plan__c];
            //Fetch all the SDR in system
            sdrList = [Select Shift__c,KA_LeadCounter__c,KA_Weightage__c,Manager.Email from user where SDR__c= true order by KA_LeadCounter__c];
            
            // Created a map which define list of users in each shift with below loop
            for(User usr: sdrList)
            {
                if(shiftuserByCounter.containskey(usr.Shift__c))
                {
                    List<User> usrList = new List<User>();
                    usrList= shiftuserByCounter.get(usr.Shift__c);
                    usrList.add(usr);
                    shiftuserByCounter.put(usr.Shift__c,usrList);
                }
                else
                {
                    List<User> usrList = new List<User>();
                    usrList.add(usr);
                    shiftuserByCounter.put(usr.Shift__c,usrList);
                    
                }
            }
            
            if(Test.isRunningTest()){
                List<User> usrList = [Select Shift__c,KA_LeadCounter__c,KA_Weightage__c,Manager.Email from user where id =: userinfo.getuserid() limit 1];
                shiftuserByCounter.put('Shift1',usrList);
            }
            
            //Get list of id of all leads inserted/updated
            for(Lead ld: leadnewList)
            {
                ldlistId.add(ld.id);
                creatorIdSet.add(ld.createdById);
            }
            
            for(User usr: [select id,Name, profile.Name,Manager.Email from user where profile.name NOT in ('System Administrator','Developer') and IsActive=true])
            {
                nonAdminUsersMap.put(usr.id,usr);
            }
            
            
            
            
            //Fetch lead details
            if(ldlistId.size()>0)
                ldlist = [Select id,createdById, ownerid,createddate,Assigned_SDR__c ,SDR_Assign_Date__C ,SDR_First_Modified_Date_Time__c,IsReassigned__c,Reassigned_To__c  from lead where id in : ldlistId];
                system.debug('@@@ ld list' + ldlist);
            //Below loop will create a map of lead with key as the shift they are applicable    
            for(lead ld: ldlist)
            {
                Datetime nowtime =DateTime.newInstanceGMT(date.today(), Datetime.now().time());
                date dt = Date.today();
                String shiftName = 'Shift2';
                
                for(Shift_Plan__c obj : shiftPlanList)
                {
                    DateTime dtStartTime = DateTime.newInstanceGMT(dt, obj.Start_Time__c);
                    DateTime dtEndTime = DateTime.newInstanceGMT(dt, obj.End_Time__c);
                    System.debug('@@@ now time' + nowtime);
                    System.debug('@@@ System.now' + System.now());
                    System.debug('@@@ created date' + ld.createddate);
                    System.debug('@@@ dtStartTime' + dtStartTime);
                    System.debug('@@@ dtEndTime' + dtEndTime);
                    if(System.now()>=dtStartTime && System.now()<= dtEndTime) {
                        system.debug('@@@ inside if');
                        shiftName = obj.Shift_Name__c;
                        break;
                    }
                }
                system.debug('@@@@ found shift name' + shiftName);
                if(shiftName !='')
                {
                    if(leadbyShift.containskey(shiftName))
                    {
                        List<Lead> leadlist = new List<Lead>();
                        leadList= leadbyShift.get(shiftName);
                        leadList.add(ld);
                        leadbyShift.put(shiftName,leadList);
                    }
                    else
                    {
                        List<Lead> leadlist = new List<Lead>();
                        leadList.add(ld);
                        leadbyShift.put(shiftName,leadList);
                    }
                }
                if(Test.isRunningTest()){
                    List<Lead> leadlist = new List<Lead>();
                    leadList.add(ld);
                    leadbyShift.put('Shift1',leadlist);
                }
                        
                
            }
            
            System.debug('@@@ USer based on shift');
            system.debug(shiftuserByCounter);
            
            System.debug('@@@ Lead based on shift');
            System.debug(leadbyShift);
            
            if(event =='Insert')
            {
                //Below loop will update the owner of lead and set the lead counter on user record
                for(String str: leadbyShift.keySet())
                {
                    for(Lead ld: leadbyShift.get(str))
                    {
                        if(nonAdminUsersMap.containsKey(ld.createdById))
                        {
                            ld.ownerid= ld.createdById;
                            ld.Owner_Manager_Email__c = nonAdminUsersMap.get(ld.createdById).manager.email;
                            ld.Assigned_SDR__c = ld.createdById;
                            ld.SDR_Assign_Date__C = System.now();
                            User usr= new User();
                            usr.id = ld.createdById;
                            usr.KA_LeadCounter__c = 1;
                            UsertoUpdate.put(usr.id,usr);
                            
                        }
                        else
                        {
                            Boolean capacityfull = true;
                            for(User usr:shiftuserByCounter.get(str))
                            {
                                if(usr.KA_LeadCounter__c == 0)
                                {
                                    ld.ownerid= usr.id;
                                    ld.Owner_Manager_Email__c = usr.manager.email;
                                    if(ld.Assigned_SDR__c == null)
                                    {
                                        ld.Assigned_SDR__c = usr.id;
                                        ld.SDR_Assign_Date__C = System.now();
                                    }
                                    usr.KA_LeadCounter__c = 1;
                                    UsertoUpdate.put(usr.id,usr);
                                    capacityfull= false;
                                    break;
                                    
                                }
                            }
                            if(capacityfull)
                            {
                                for(User usr:shiftuserByCounter.get(str))
                                {
                                    usr.KA_LeadCounter__c= 0;
                                    UsertoUpdate.put(usr.id,usr);
                                }
                                ld.ownerid= shiftuserByCounter.get(str)[0].id;
                                ld.Owner_Manager_Email__c = shiftuserByCounter.get(str)[0].manager.email;
                                if(ld.Assigned_SDR__c == null)
                                {
                                    ld.Assigned_SDR__c = shiftuserByCounter.get(str)[0].id;
                                    ld.SDR_Assign_Date__C = System.now();
                                }
                                User usrtemp = shiftuserByCounter.get(str)[0];
                                usrtemp.KA_LeadCounter__c = 1;
                                UsertoUpdate.put(usrtemp.id,usrtemp);
                            }
                        }
                        leadtoUpdateMap.put(ld.id,ld);
                        //leadtoUpdate.add(ld);
                    }
                }
            }
            
            if(event =='Update')
            {
                //Below loop will update the owner of lead and set the lead counter on user record
                for(String str: leadbyShift.keySet())
                {
                    for(Lead ld: leadbyShift.get(str))
                    {
                        Boolean capacityfull = true;
                        for(User usr:shiftuserByCounter.get(str))
                        {
                            if(usr.KA_LeadCounter__c == 0 && usr.id != ld.ownerid)
                            {
                                ld.ownerid= usr.id;
                                ld.Owner_Manager_Email__c = usr.manager.email;
                                ld.IsReassigned__c = true;
                                ld.Reassigned_To__c = usr.id;
                                usr.KA_LeadCounter__c = 1;
                                UsertoUpdate.put(usr.id,usr);
                                capacityfull= false;
                                break;
                                
                            }
                        }
                        if(capacityfull)
                        {
                            List<User> templist = new List<User>();
                            for(User usr:shiftuserByCounter.get(str))
                            {
                                if(usr.id != ld.ownerid)
                                    templist.add(usr);
                            }
                            for(User usr:templist)
                            {
                                usr.KA_LeadCounter__c= 0;
                                UsertoUpdate.put(usr.id,usr);
                            }
                            if(templist.Size()>0)
                            {
                                ld.ownerid= templist[0].id;
                                ld.Owner_Manager_Email__c = templist[0].manager.email;
                                ld.IsReassigned__c = true;
                                ld.Reassigned_To__c = templist[0].id;
                                User usrtemp = templist[0];
                                usrtemp.KA_LeadCounter__c = 1;
                                UsertoUpdate.put(usrtemp.id,usrtemp);
                            }
                        }
                        leadtoUpdateMap.put(ld.id,ld);
                        //leadtoUpdate.add(ld);
                    }
                }
            }
            
            if(leadtoUpdateMap.size()>0)
                update leadtoUpdateMap.values();
            
            if(UsertoUpdate.values().size()>0)
                update UsertoUpdate.values();
        }
        catch(Exception e)
        {
            SF_Error_Log__c error = new SF_Error_Log__c();
            error.Class_Name__c ='LeadTriggerHandler';
            error.Error_Trace__c =e.getMessage();
            error.Stack_Trace__c = e.getStackTraceString();
            error.Error_Type__c = 'Lead Assignment';
            error.Line_Number__c = string.valueOf(e.getLineNumber());
            error.Method_Name__c = event;
            error.User__c = userinfo.getuserid();
            error.Record_List__c = String.valueOf(leadnewList);
            insert error;
        }       
            
    }
    
    //Populate Trial_expiry from Instance, this field value has been used in workflow
   /* private static void updateTrialEpiryDate(List<Lead> leadnewList, Boolean isInsert) {
        Set<Id> setInstanceId = new Set<Id>();
        for(Lead ld: leadnewList)
        {
            
            if(isInsert)
                ld.Trial_expiry__c = ld.Trial_Expiry_Date__c;
            
        }
        if(!setInstanceId.isEmpty()) {
            Map<Id, Instance__c> mapInstances = new Map<Id, Instance__c>([Select ID, Expiry_Date__c from INSTANCE__C where ID IN: setInstanceId]);
            for(Lead ld: leadnewList)
            {
                if(ld.Instance__c != null && mapInstances.containsKey(ld.Instance__c)) {
                    ld.Trial_expiry__c = mapInstances.get(ld.Instance__c).Expiry_Date__c;
                }
            }
        }
            
    }*/
}