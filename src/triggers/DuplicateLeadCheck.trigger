trigger DuplicateLeadCheck on Lead (before insert) {
    
    Set<String>existingLeadsEmails = new Set<String>();
    Set<String>IncomingEmailsSet = new Set<String>();
    
    for(lead l:Trigger.New){
        IncomingEmailsSet.add(l.Email);
    }
    
    for(Lead l :[select email from lead where isconverted=false and Email IN:IncomingEmailsSet]){
        existingLeadsEmails.add(l.email);    
    }
    
    for(Lead ln : Trigger.New){
        if(existingLeadsEmails.contains(ln.email)){
            if(!Test.isRunningTest()){
            ln.addError('Lead with this email already exists.');
            }
        }
    }
}