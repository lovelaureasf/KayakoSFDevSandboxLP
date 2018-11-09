trigger OppBlankStageFiller on Opportunity (before insert) {
     for(Opportunity opp: trigger.new){
           if(opp.StageName==null || opp.StageName==''){
               opp.stagename = 'Value Proposition';
           }
     }
}