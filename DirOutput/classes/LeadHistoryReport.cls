public class LeadHistoryReport {

public List<Lead> ldList {get;set;}
public Map<Id, List<Ownerchange>> leaddetails {get;set;}
public List<Integer> maxcolumn {get;set;}
    public LeadHistoryReport()
    {
        Set<Id> leadids= new Set<Id>();
        Map<Id,Lead> leadmap = new Map<Id,Lead>();
        List<LeadHistory> leadhistoryList= new List<LeadHistory>();
        leaddetails = new Map<Id, List<Ownerchange>>();
        maxcolumn = new List<Integer>();
        
        ldList = new List<Lead>();
        ldList = [select id,Name,Company,firstName,LastName,email,LeadSource,Status from Lead];
        for(Lead ld:ldList)
        {
            leadmap.put(ld.id,ld); 
        }
        
        leadhistoryList =[SELECT CreatedById,CreatedDate,Field,Id,IsDeleted,LeadId,NewValue,OldValue FROM LeadHistory ORDER BY CreatedDate];
        
        for(LeadHistory ldh: leadhistoryList )
        {
            
            if(ldh.Field == 'Owner'  )
            {
                String ownername = (String)ldh.newValue;
                if(!ownername.startsWith('005') ) 
                {
                if(leaddetails.containskey(ldh.LeadId) )
                {
                    Ownerchange ow= new Ownerchange();
                    ow.owner = (String)ldh.newValue;
                    Datetime dt = ldh.CreatedDate;
                    Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
                    ow.transferdate = String.valueOf(myDate);
                    ow.ld = leadmap.get(ldh.LeadId);
                    
                    leaddetails.get(ldh.LeadId).add(ow);
                }
                else
                {
                    Ownerchange ow= new Ownerchange();
                    ow.owner = (String)ldh.newValue;
                    Datetime dt = ldh.CreatedDate;
                    Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
                    ow.transferdate = String.valueOf(myDate);

                    List<Ownerchange> owList = new List<Ownerchange>();
                    owList.add(ow);
                    ow.ld = leadmap.get(ldh.LeadId);
                    leaddetails.put(ldh.LeadId, owList);
                }
                }
            }
                    
        }
        Integer maxsize= 0;
        for(Id ldid:leaddetails.keySet())
        {
            if(leaddetails.get(ldid).Size() > maxsize)
            {
                maxsize= leaddetails.get(ldid).Size();
            }
        }
        for(Integer i=0;i<maxsize ; i++ )
        {
            maxcolumn.add(i);
        }
        System.debug('@@@@@@');
        system.debug(leaddetails);
        
    }
    
    public class Ownerchange 
    {
        public Lead ld {get;set;}
        public String company {get;set;}
        public String firstname {get;set;}
        public String lastName {get;set;}
        public String email {get;set;}
        public String source {get;set;}
        public String owner {get;set;}
        public String transferdate{get;set;} 
        public String status {get;set;}
    }
     
}