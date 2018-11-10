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
     
    }
 
    // This method is being used for assigning lead based on ther shift and round robin
    public static void leadAssignment(List<Lead> leadnewList,String event)
    {
        try{
            system.debug('@@@ Lead assignment started');
            List<User> sdrList = new List<User>();
            List<Lead> ldlist = new List<Lead>();
            Set<Id> ldlistId = new Set<Id>();
            List<Lead> leadtoUpdate = new List<Lead>();
            Map<id,User> UsertoUpdate = new Map<id,User>();
            Map<id,Lead> leadtoUpdateMap = new Map<id,Lead>();
            Map<Id,User> nonAdminUsersMap = new Map<Id,User>();
            
            sdrList = [Select Shift__c,KA_LeadCounter__c,KA_Weightage__c,Manager.Email,Start_Time__c,End_Time__c from user where SDR__c= true and isActive=true order by KA_LeadCounter__c];
            
            //Get list of id of all leads inserted/updated
            for(Lead ld: leadnewList){
                ldlistId.add(ld.id);
            }
            
            for(User usr: [select id,Name, profile.Name,Manager.Email from user where profile.name NOT in ('System Administrator','Developer') and IsActive=true]){
                nonAdminUsersMap.put(usr.id,usr);
            }
            
            //Fetch lead details
            if(ldlistId.size()>0){
                ldlist = [Select id,createdById, ownerid,createddate,Assigned_SDR__c ,SDR_Assign_Date__C ,SDR_First_Modified_Date_Time__c,IsReassigned__c,Reassigned_To__c  from lead where id in : ldlistId];
            }
            
            system.debug('@@@ ld list' + ldlist);
            
            if(event =='Insert')
            {
                //Below loop will update the owner of lead and set the lead counter on user record
                for(Lead ld: ldlist)
                {
                    system.debug('@@@System.now()' + System.now());
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
                        Boolean userfound = false;
                        for(User usr:sdrList)
                        {
                            DateTime dtStartTime = DateTime.newInstanceGMT(DateTime.now().dateGmt(), usr.Start_Time__c);
                            DateTime dtEndTime = DateTime.newInstanceGMT(DateTime.now().dateGmt(), usr.End_Time__c);
                            if(usr.End_Time__c.hour() < usr.Start_Time__c.hour())
                            {
                                if(DateTime.now().timeGmt().hour() < usr.Start_Time__c.hour())
                                {
                                    dtStartTime =  DateTime.newInstanceGMT(DateTime.now().dateGmt().addDays(-1), usr.Start_Time__c);
                                }
                                else
                                    dtEndTime = DateTime.newInstanceGMT(DateTime.now().dateGmt().addDays(1), usr.End_Time__c);
                            }   
                            system.debug('@@@ start time under capacity full' + dtStartTime);
                            system.debug('@@@ end time under capatity full' + dtEndTime);   
                            
                            if(usr.KA_LeadCounter__c == 0 && System.now()>=dtStartTime && System.now()<= dtEndTime)
                            {
                                system.debug('@@@ under user found');
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
                                userfound = true;
                                break;
                                    
                            }
                        }
                        if(capacityfull)
                        {
                            for(User usr:sdrList)
                            {
                                DateTime dtStartTime = DateTime.newInstanceGMT(DateTime.now().dateGmt(), usr.Start_Time__c);
                                DateTime dtEndTime = DateTime.newInstanceGMT(DateTime.now().dateGmt(), usr.End_Time__c);
                                if(usr.End_Time__c.hour() < usr.Start_Time__c.hour())
                                {
                                    if(DateTime.now().timeGmt().hour() < usr.Start_Time__c.hour())
                                    {
                                        dtStartTime =  DateTime.newInstanceGMT(DateTime.now().dateGmt().addDays(-1), usr.Start_Time__c);
                                    }
                                    else
                                        dtEndTime = DateTime.newInstanceGMT(DateTime.now().dateGmt().addDays(1), usr.End_Time__c);
                                }
                                system.debug('@@@ start time under capacity full' + dtStartTime);
                                system.debug('@@@ end time under capatity full' + dtEndTime);
                                system.debug('@@@ test' + DateTime.newInstanceGMT(Date.today(), usr.Start_Time__c));
                                if(userfound == false && System.now()>=dtStartTime && System.now()<= dtEndTime)
                                {
                                    system.debug('@@@ under user found');
                                    ld.ownerid= usr.id;
                                    ld.Owner_Manager_Email__c = usr.manager.email;
                                    if(ld.Assigned_SDR__c == null)
                                    {
                                        ld.Assigned_SDR__c = usr.id;
                                        ld.SDR_Assign_Date__C = System.now();
                                    }
                                    usr.KA_LeadCounter__c = 1;
                                    userfound = true;
                                    UsertoUpdate.put(usr.id,usr);
                                        
                                }
                                else if (userfound == true && System.now()>=dtStartTime && System.now()<= dtEndTime)
                                {
                                    usr.KA_LeadCounter__c = 0;
                                    UsertoUpdate.put(usr.id,usr);
                                }
                            }
                        }
                    }
                    leadtoUpdateMap.put(ld.id,ld);
                }                   
            }
            
            if(event =='Update')
            {
                
                for(Lead ld: ldlist)
                {
                    Boolean capacityfull = true;
                    Boolean userfound = false;
                    for(User usr:sdrList)
                    {
                        DateTime dtStartTime = DateTime.newInstanceGMT(DateTime.now().dateGmt(), usr.Start_Time__c);
                        DateTime dtEndTime = DateTime.newInstanceGMT(DateTime.now().dateGmt(), usr.End_Time__c);
                        if(usr.End_Time__c.hour() < usr.Start_Time__c.hour())
                        {
                            if(DateTime.now().timeGmt().hour() < usr.Start_Time__c.hour())
                            {
                                dtStartTime =  DateTime.newInstanceGMT(DateTime.now().dateGmt().addDays(-1), usr.Start_Time__c);
                            }
                            else
                                dtEndTime = DateTime.newInstanceGMT(DateTime.now().dateGmt().addDays(1), usr.End_Time__c);
                        }
                        system.debug('@@@ start time update' + dtStartTime);
                        system.debug('@@@ end time update' + dtEndTime);
                            
                        if(usr.KA_LeadCounter__c == 0 && System.now()>=dtStartTime && System.now()<= dtEndTime && usr.id != ld.ownerid)
                        {
                            ld.ownerid= usr.id;
                            ld.Owner_Manager_Email__c = usr.manager.email;
                            ld.IsReassigned__c = true;
                            ld.Reassigned_To__c = usr.id;
                            usr.KA_LeadCounter__c = 1;
                            UsertoUpdate.put(usr.id,usr);
                            capacityfull= false;
                            userfound = true;
                            break;
                                    
                        }
                    }
                    if(capacityfull)
                    {
                        for(User usr:sdrList)
                        {
                            DateTime dtStartTime = DateTime.newInstanceGMT(DateTime.now().dateGmt(), usr.Start_Time__c);
                            DateTime dtEndTime = DateTime.newInstanceGMT(DateTime.now().dateGmt(), usr.End_Time__c);
                            if(usr.End_Time__c.hour() < usr.Start_Time__c.hour())
                            {
                                if(DateTime.now().timeGmt().hour() < usr.Start_Time__c.hour())
                                {
                                    dtStartTime =  DateTime.newInstanceGMT(DateTime.now().dateGmt().addDays(-1), usr.Start_Time__c);
                                }
                                else
                                    dtEndTime = DateTime.newInstanceGMT(DateTime.now().dateGmt().addDays(1), usr.End_Time__c);
                            }
                            system.debug('@@@ start time under capacity full Update' + dtStartTime);
                            system.debug('@@@ end time under capatity full Update' + dtEndTime);
                            if(userfound == false && System.now()>=dtStartTime && System.now()<= dtEndTime && usr.id != ld.ownerid)
                            {
                                ld.ownerid= usr.id;
                                ld.Owner_Manager_Email__c = usr.manager.email;
                                ld.IsReassigned__c = true;
                                ld.Reassigned_To__c = usr.id;
                                usr.KA_LeadCounter__c = 1;
                                UsertoUpdate.put(usr.id,usr);
                                userfound = true;
                            }
                            else if (userfound == true && System.now()>=dtStartTime && System.now()<= dtEndTime)
                            {
                                usr.KA_LeadCounter__c = 0;
                                UsertoUpdate.put(usr.id,usr);
                            }
                                
                        }
                    }
                    if(userfound == false)
                    {
                        system.debug('@@@ inside default user ');
                        ld.ownerid= '005100000089AF7';
                        ld.Owner_Manager_Email__c ='david.morris@crossover.com';
                        ld.IsReassigned__c = true;
                        ld.Reassigned_To__c = '005100000089AF7';
                    }
                    
                    leadtoUpdateMap.put(ld.id,ld);
                }
            }
            
            if(leadtoUpdateMap.size()>0)
                update leadtoUpdateMap.values();
            
            if(UsertoUpdate.size()>0)
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
    
    
}